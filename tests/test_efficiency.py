"""Synthetic arithmetic tests, NOT measurements of model savings."""
import importlib.util
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

spec=importlib.util.spec_from_file_location('efficiency',Path(__file__).resolve().parents[1]/'scripts/evaluate-efficiency.py')
mod=importlib.util.module_from_spec(spec)
spec.loader.exec_module(mod)


def row(**changes):
    value=dict(task_class='S2-feature',accepted=True,wall_seconds=100,
               input_tokens=1000,cached_input_tokens=800,output_tokens=200,
               billed_cost=1,currency='USD',human_interventions=0)
    value.update(changes)
    return value


class EfficiencyTests(unittest.TestCase):
    def test_cost_growth_without_time_saving_triggers_review(self):
        result=mod.compare([row(task_id=str(i)) for i in range(5)],
                           [row(task_id=str(i),billed_cost=1.5,wall_seconds=95) for i in range(5)])
        self.assertEqual(result['signal'],'review-route')
        self.assertFalse(result['preliminary'])

    def test_missing_billing_cannot_be_invented_from_tokens(self):
        result=mod.compare([row(billed_cost=None)],[row(billed_cost=None,input_tokens=2000)])
        self.assertEqual(result['signal'],'unmeasured')
        self.assertIsNone(result['cost_ratio'])
        self.assertGreater(result['token_ratio_proxy_only'],1)

    def test_failed_attempts_cost_counts_and_cache_not_added_twice(self):
        result=mod.summarize([row(),row(accepted=False)])
        self.assertEqual(result['cost_per_accepted'],2)
        self.assertEqual(result['tokens_per_accepted'],2400)
        self.assertEqual(result['acceptance_rate'],.5)

    def test_zero_acceptance_is_not_infinite_or_false_saving(self):
        result=mod.compare([row()],[row(accepted=False)])
        self.assertEqual(result['signal'],'unmeasured')
        self.assertIsNone(result['candidate']['cost_per_accepted'])

    def test_invalid_or_noncomparable_records_rejected(self):
        for records in [[row(accepted='true')],[row(cached_input_tokens=2000)],[],[row(),row(task_class='S4')]]:
            with self.assertRaises(ValueError):
                mod.summarize(records)
        with self.assertRaises(ValueError):
            mod.compare([row()],[row(task_class='S3')])

    def test_currency_mismatch_and_partial_usage_are_unmeasured(self):
        result=mod.compare([row()],[row(currency='CNY',input_tokens=None,cached_input_tokens=None)])
        self.assertIsNone(result['cost_ratio'])
        self.assertIsNone(result['token_ratio_proxy_only'])

    def test_duplicate_ids_rejected_and_missing_ids_remain_preliminary(self):
        with self.assertRaises(ValueError):
            mod.summarize([row(task_id='same')]*5)
        self.assertTrue(mod.compare([row()]*5,[row()]*5)['preliminary'])

    def test_failed_task_time_cannot_masquerade_as_overall_speedup(self):
        result=mod.compare([row()],[row(wall_seconds=10),row(accepted=False,wall_seconds=1000)])
        self.assertEqual(result['accepted_only_median_wall_ratio'],.1)
        self.assertEqual(result['wall_ratio'],10.1)
        self.assertEqual(result['signal'],'review-route')


DIAGNOSTIC_FIELDS = ('compaction_count', 'compaction_seconds', 'git_retry_count',
                     'external_blocked_seconds', 'child_count', 'rework_seconds')


class EfficiencyDiagnosticTests(unittest.TestCase):
    def test_complete_diagnostics_report_all_means_and_coverage(self):
        first = {field: 2 * (i + 1) for i, field in enumerate(DIAGNOSTIC_FIELDS)}
        second = {field: 4 * (i + 1) for i, field in enumerate(DIAGNOSTIC_FIELDS)}
        result = mod.summarize([row(task_id='accepted', **first),
                                row(task_id='failed', accepted=False, **second)])
        self.assertEqual(result['diagnostics_known_tasks'],
                         dict.fromkeys(DIAGNOSTIC_FIELDS, 2))
        self.assertEqual(result['diagnostics_mean_per_task'],
                         {field: 3 * (i + 1) for i, field in enumerate(DIAGNOSTIC_FIELDS)})
        self.assertIn('overlap', result['diagnostics_note'])
        self.assertIn('never subtract', result['diagnostics_note'])

    def test_missing_and_explicit_null_fields_stay_unknown(self):
        for optional in ({}, dict.fromkeys(DIAGNOSTIC_FIELDS, None)):
            with self.subTest(explicit_null=bool(optional)):
                result = mod.summarize([row(**optional)])
                self.assertEqual(result['diagnostics_known_tasks'],
                                 dict.fromkeys(DIAGNOSTIC_FIELDS, 0))
                self.assertEqual(result['diagnostics_mean_per_task'],
                                 dict.fromkeys(DIAGNOSTIC_FIELDS, None))

    def test_partial_coverage_does_not_average_only_known_tasks(self):
        for field in DIAGNOSTIC_FIELDS:
            for missing in (True, False):
                with self.subTest(field=field, omitted=missing):
                    first = dict.fromkeys(DIAGNOSTIC_FIELDS, 4)
                    second = dict.fromkeys(DIAGNOSTIC_FIELDS, 8)
                    if missing:
                        del second[field]
                    else:
                        second[field] = None
                    result = mod.summarize([row(**first), row(accepted=False, **second)])
                    self.assertEqual(result['diagnostics_known_tasks'][field], 1)
                    self.assertIsNone(result['diagnostics_mean_per_task'][field])
                    for other in set(DIAGNOSTIC_FIELDS) - {field}:
                        self.assertEqual(result['diagnostics_known_tasks'][other], 2)
                        self.assertEqual(result['diagnostics_mean_per_task'][other], 6)

    def test_zero_is_an_observed_value_not_missing(self):
        result = mod.summarize([row(**dict.fromkeys(DIAGNOSTIC_FIELDS, 0))])
        self.assertEqual(result['diagnostics_known_tasks'], dict.fromkeys(DIAGNOSTIC_FIELDS, 1))
        self.assertEqual(result['diagnostics_mean_per_task'], dict.fromkeys(DIAGNOSTIC_FIELDS, 0))

    def test_invalid_diagnostics_rejected_even_on_failed_tasks(self):
        invalid = (-1, True, False, '2', '', [], {}, float('nan'),
                   float('inf'), float('-inf'))
        for field in DIAGNOSTIC_FIELDS:
            for value in invalid:
                for accepted in (True, False):
                    with self.subTest(field=field, value=value, accepted=accepted):
                        with self.assertRaisesRegex(ValueError, 'invalid diagnostic measurement'):
                            mod.summarize([row(), row(accepted=accepted, **{field: value})])

    def test_fractional_durations_are_valid_measurements(self):
        durations = ('compaction_seconds', 'external_blocked_seconds', 'rework_seconds')
        result = mod.summarize([row(**dict.fromkeys(durations, .25)),
                                row(**dict.fromkeys(durations, .5))])
        for field in durations:
            self.assertEqual(result['diagnostics_mean_per_task'][field], .375)
            self.assertEqual(result['diagnostics_known_tasks'][field], 2)

    def test_overlapping_diagnostics_do_not_change_cost_time_or_verdict(self):
        baseline = [row(task_id='old')]
        candidate = [row(task_id='new', billed_cost=1.5, wall_seconds=95)]
        plain = mod.compare(baseline, candidate)
        # Observed overlapping background durations can exceed task wall time.
        enriched = mod.compare(
            [{**r, **dict.fromkeys(DIAGNOSTIC_FIELDS, 1000)} for r in baseline],
            [{**r, **dict.fromkeys(DIAGNOSTIC_FIELDS, 2000)} for r in candidate])
        for field in ('cost_ratio', 'wall_ratio', 'accepted_only_median_wall_ratio',
                      'token_ratio_proxy_only', 'preliminary', 'signal'):
            self.assertEqual(enriched[field], plain[field])
        for route in ('baseline', 'candidate'):
            for field, value in plain[route].items():
                if not field.startswith('diagnostics_'):
                    self.assertEqual(enriched[route][field], value)

    def test_complete_diagnostics_cannot_invent_missing_billing_or_elapsed(self):
        unknown = row(billed_cost=None, wall_seconds=None,
                      **dict.fromkeys(DIAGNOSTIC_FIELDS, 1))
        result = mod.compare([unknown], [unknown])
        self.assertEqual(result['signal'], 'unmeasured')
        self.assertIsNone(result['cost_ratio'])
        self.assertIsNone(result['wall_ratio'])

    def test_zero_acceptances_preserve_diagnostics_without_claiming_savings(self):
        result = mod.compare([row()], [row(accepted=False,
                                         **dict.fromkeys(DIAGNOSTIC_FIELDS, 3))])
        self.assertEqual(result['candidate']['diagnostics_mean_per_task'],
                         dict.fromkeys(DIAGNOSTIC_FIELDS, 3))
        self.assertEqual(result['signal'], 'unmeasured')
        self.assertIsNone(result['wall_ratio'])

    def test_cli_emits_diagnostics_and_nulls_as_strict_json(self):
        with tempfile.TemporaryDirectory(prefix='efficiency-diagnostics-') as tmp:
            root = Path(tmp)
            baseline, candidate = root / 'baseline.json', root / 'candidate.json'
            baseline.write_text(json.dumps([row(**dict.fromkeys(DIAGNOSTIC_FIELDS, 2))]),
                                encoding='utf-8-sig')
            candidate.write_text(json.dumps([row(compaction_count=0)]), encoding='utf-8')
            before = (baseline.read_bytes(), candidate.read_bytes())
            result = subprocess.run([sys.executable, '-I', '-B', str(spec.origin),
                                     str(baseline), str(candidate)], cwd=root,
                                    capture_output=True, text=True, timeout=20)
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
            self.assertNotIn('NaN', result.stdout)
            self.assertNotIn('Infinity', result.stdout)
            data = json.loads(result.stdout)
            self.assertEqual(data['baseline']['diagnostics_known_tasks'],
                             dict.fromkeys(DIAGNOSTIC_FIELDS, 1))
            self.assertEqual(data['candidate']['diagnostics_mean_per_task']['compaction_count'], 0)
            self.assertIsNone(data['candidate']['diagnostics_mean_per_task']['rework_seconds'])
            self.assertEqual(before, (baseline.read_bytes(), candidate.read_bytes()))


if __name__=='__main__':
    unittest.main(verbosity=2)
