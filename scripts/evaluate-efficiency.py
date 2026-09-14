"""Read already-authorized task records; no APIs, pricing lookup, or paid replay.

Usage: python scripts/evaluate-efficiency.py baseline.json candidate.json
Each file is a JSON array. Each record represents a whole task (including retries
and children), with task_id, task_class, accepted, wall_seconds, input_tokens,
cached_input_tokens (subset of input), output_tokens, billed_cost, currency,
human_interventions. Unknown numerical fields are null. Compare one class at a time.
"""
import json
import math
import statistics
import sys


def number(value):
    return isinstance(value, (int, float)) and not isinstance(value, bool) and math.isfinite(value) and value >= 0


def summarize(rows):
    if not rows or len({r.get('task_class') for r in rows}) != 1 or not rows[0].get('task_class'):
        raise ValueError('nonempty records of one comparable task_class required')
    if any(type(r.get('accepted')) is not bool for r in rows):
        raise ValueError('accepted must be a boolean; missing outcomes cannot pass')
    accepted = [r for r in rows if r['accepted']]
    ids = [r.get('task_id') for r in rows]
    supplied_ids = [value for value in ids if value is not None]
    if any(not isinstance(value, str) or not value.strip() for value in supplied_ids):
        raise ValueError('task_id must be a nonempty string when supplied')
    if len(set(supplied_ids)) != len(supplied_ids):
        raise ValueError('duplicate task_id; aggregate retries/children into one task record')
    def complete(field):
        return all(number(r.get(field)) for r in rows)
    tokens_known = complete('input_tokens') and complete('output_tokens')
    for r in rows:
        cached = r.get('cached_input_tokens')
        if cached is not None and (not number(cached) or not number(r.get('input_tokens')) or cached > r['input_tokens']):
            raise ValueError('cached_input_tokens must be a subset of input_tokens')
    currencies = {r.get('currency') for r in rows}
    cost_known = complete('billed_cost') and len(currencies) == 1 and bool(rows[0].get('currency'))
    diagnostic_fields = ('compaction_count', 'compaction_seconds', 'git_retry_count',
                         'external_blocked_seconds', 'child_count', 'rework_seconds')
    diagnostics = {}
    coverage = {}
    for field in diagnostic_fields:
        values = [r.get(field) for r in rows]
        if any(value is not None and not number(value) for value in values):
            raise ValueError('invalid diagnostic measurement')
        coverage[field] = sum(value is not None for value in values)
        diagnostics[field] = sum(values)/len(rows) if all(value is not None for value in values) else None
    return dict(diagnostics_mean_per_task=diagnostics, diagnostics_known_tasks=coverage,
                diagnostics_note='recorded durations can overlap each other/background work; never subtract as net savings or add as batch makespan',
                task_class=rows[0]['task_class'], attempts=len(rows), accepted=len(accepted),
                unique_task_ids_known=len(supplied_ids) == len(rows),
                acceptance_rate=len(accepted)/len(rows),
                cost_per_accepted=sum(r['billed_cost'] for r in rows)/len(accepted) if cost_known and accepted else None,
                currency=rows[0]['currency'] if cost_known else None,
                tokens_per_accepted=sum(r['input_tokens']+r['output_tokens'] for r in rows)/len(accepted) if tokens_known and accepted else None,
                median_accepted_wall_seconds=statistics.median(r['wall_seconds'] for r in accepted) if accepted and all(number(r.get('wall_seconds')) for r in accepted) else None,
                task_seconds_per_accepted=sum(r['wall_seconds'] for r in rows)/len(accepted) if complete('wall_seconds') and accepted else None,
                human_interventions_per_accepted=sum(r['human_interventions'] for r in rows)/len(accepted) if complete('human_interventions') and accepted else None)


def compare(baseline, candidate):
    old, new = summarize(baseline), summarize(candidate)
    if old['task_class'] != new['task_class']:
        raise ValueError('task classes differ; stratify before comparison')
    def ratio(field):
        a,b = old[field],new[field]
        return b/a if a is not None and b is not None and a > 0 else None
    cost = ratio('cost_per_accepted') if old['currency'] == new['currency'] else None
    # Whole-task wall times include retries/children already. Sum across task
    # records measures time burden per acceptance, NOT parallel batch makespan.
    wall = ratio('task_seconds_per_accepted')
    verdict = 'unmeasured'
    if cost is not None and wall is not None:
        verdict = 'review-route' if cost > 1.25 and wall > .85 else 'no-cost-time-trigger'
    return dict(baseline=old,candidate=new,cost_ratio=cost,wall_ratio=wall,
                accepted_only_median_wall_ratio=ratio('median_accepted_wall_seconds'),
                token_ratio_proxy_only=ratio('tokens_per_accepted'),
                preliminary=min(old['accepted'],new['accepted']) < 5 or not (old['unique_task_ids_known'] and new['unique_task_ids_known']),
                signal=verdict,
                note='wall_ratio is total task-seconds per acceptance including failed tasks, not parallel makespan; accepted-only median can hide failures. Missing task IDs keep evidence preliminary. Signal is not a release gate or causal quality verdict. Review defects, difficulty and Human interventions before adjustment; never remove mandatory safeguards.')


if __name__ == '__main__':
    if len(sys.argv) != 3:
        raise SystemExit('usage: evaluate-efficiency.py baseline.json candidate.json')
    with open(sys.argv[1],encoding='utf-8-sig') as f:
        baseline=json.load(f)
    with open(sys.argv[2],encoding='utf-8-sig') as f:
        candidate=json.load(f)
    print(json.dumps(compare(baseline,candidate),ensure_ascii=False,indent=2,allow_nan=False))
