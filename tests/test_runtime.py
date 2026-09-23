"""Read-only runtime inventory tests; all config and secrets are synthetic.

These exercise local CLI behavior, not model routing, provider availability,
hook invocation, effective context settings or production authorization.
"""
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]
SCRIPT = ROOT / 'scripts/runtime-inspect.py'
SECRET = 'SYNTHETIC_CONFIG_SECRET_DO_NOT_ECHO_73'
CONTEXT_KEYS = ('model_context_window', 'model_auto_compact_token_limit')


class RuntimeTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory(prefix='runtime-inventory-tests-')
        self.addCleanup(self.tmp.cleanup)
        self.scratch = Path(self.tmp.name).resolve()
        self.root = self.scratch / 'project'
        self.root.mkdir()
        self.home = self.scratch / 'isolated-home'
        self.home.mkdir()
        self.config = self.root / '.codex/config.toml'
        self.env = dict(os.environ, HOME=str(self.home), USERPROFILE=str(self.home),
                        CODEX_HOME=str(self.home / '.codex'),
                        PYTHONDONTWRITEBYTECODE='1')

    def write(self, relative, contents, *, encoding='utf-8'):
        path = self.root / relative
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(contents, encoding=encoding)
        return path

    def snapshot(self):
        return {str(path.relative_to(self.scratch)):
                (path.read_bytes(), path.stat().st_mtime_ns) if path.is_file() else None
                for path in self.scratch.rglob('*')}

    def cli(self):
        before = self.snapshot()
        result = subprocess.run([sys.executable, '-I', '-B', str(SCRIPT),
                                 '--project', str(self.root)],
                                cwd=self.scratch, env=self.env, capture_output=True,
                                text=True, encoding='utf-8', errors='replace', timeout=20)
        self.assertEqual(self.snapshot(), before, 'inventory must not mutate local state')
        self.assertNotIn(SECRET, result.stdout + result.stderr)
        return result

    def inventory(self):
        result = self.cli()
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(result.stderr, '')
        return json.loads(result.stdout)

    def assert_invalid(self):
        result = self.cli()
        self.assertEqual(result.returncode, 2, result.stdout + result.stderr)
        self.assertEqual(result.stdout, '')
        self.assertIn('contents omitted', result.stderr)
        self.assertNotIn('Traceback', result.stderr)

    def assert_runtime_unknown(self, data):
        self.assertEqual(data['schema_version'], 1)
        self.assertEqual(data['kind'], 'static_inventory_not_live_readiness')
        self.assertEqual(data['actual_model'], 'unverified')
        self.assertEqual(data['hooks_invoked'], 'unverified')
        self.assertEqual(data['production_authorization'], 'unverified')
        self.assertEqual(data['delegation_permission'],
                         'check_current_user_and_platform_instructions')
        self.assertEqual(set(data['context']), set(CONTEXT_KEYS))
        for key in CONTEXT_KEYS:
            self.assertEqual(data['context'][key]['effective_runtime_value'], 'unavailable')
        for role in data['roles']:
            self.assertEqual(role['runtime_consumed'], 'unverified')

    def test_missing_configuration_returns_only_unknown_runtime_facts(self):
        data = self.inventory()
        self.assert_runtime_unknown(data)
        self.assertEqual(data['roles'], [])
        self.assertIs(data['hooks_file_present'], False)
        self.assertIs(data['signed_request_runner_present'], False)
        for key in CONTEXT_KEYS:
            self.assertIsNone(data['context'][key]['project_config_value'])

    def test_empty_configuration_is_not_live_readiness(self):
        self.write('.codex/config.toml', '')
        data = self.inventory()
        self.assert_runtime_unknown(data)
        self.assertEqual(data['roles'], [])

    def test_context_values_are_labeled_project_only(self):
        self.write('.codex/config.toml',
                   'model_context_window = 160000\nmodel_auto_compact_token_limit = 120000\n')
        data = self.inventory()
        self.assert_runtime_unknown(data)
        self.assertEqual(data['context']['model_context_window']['project_config_value'], 160000)
        self.assertEqual(data['context']['model_auto_compact_token_limit']['project_config_value'],
                         120000)

    def test_partial_context_does_not_invent_other_limit(self):
        self.write('.codex/config.toml', 'model_context_window = 8192\n')
        data = self.inventory()
        self.assert_runtime_unknown(data)
        self.assertEqual(data['context']['model_context_window']['project_config_value'], 8192)
        self.assertIsNone(data['context']['model_auto_compact_token_limit']['project_config_value'])

    def test_registered_roles_and_present_files_do_not_prove_runtime(self):
        self.write('.codex/config.toml',
                   '[agents.offline_reviewer]\nconfig_file = "agents/reviewer.toml"\n')
        self.write('.codex/agents/reviewer.toml', 'name = "offline_reviewer"\n')
        self.write('.codex/hooks.json', '{}\n')
        self.write('.codex/hooks/invoke-authorized.ps1', '# inert fixture; never executed\n')
        data = self.inventory()
        self.assert_runtime_unknown(data)
        self.assertIs(data['hooks_file_present'], True)
        self.assertIs(data['signed_request_runner_present'], True)
        self.assertEqual(data['roles'], [dict(role='offline_reviewer', file='reviewer.toml',
                                            standalone_definition='invalid_metadata',
                                            legacy_registration='matches_definition',
                                            registration_present=True,
                                            configured_model=None,
                                            configured_reasoning_effort=None,
                                            runtime_consumed='unverified')])

    def test_role_file_without_configuration_is_unregistered(self):
        self.write('.codex/agents/worker.toml', 'name = "offline_worker"\n')
        data = self.inventory()
        self.assert_runtime_unknown(data)
        self.assertIs(data['roles'][0]['registration_present'], False)
        self.assertEqual(data['roles'][0]['legacy_registration'], 'absent')

    def test_registration_by_role_file_stem_matches_migrator_convention(self):
        self.write('.codex/config.toml',
                   '[agents.terra-worker]\nconfig_file = "agents/terra-worker.toml"\n')
        self.write('.codex/agents/terra-worker.toml', 'name = "terra_worker"\n')
        data = self.inventory()
        self.assert_runtime_unknown(data)
        self.assertEqual(data['roles'][0]['role'], 'terra_worker')
        self.assertEqual(data['roles'][0]['file'], 'terra-worker.toml')
        self.assertIs(data['roles'][0]['registration_present'], True,
                      'a role registered under its managed file stem must be recognized')

    def test_empty_or_unrelated_registration_does_not_register_role(self):
        self.write('.codex/agents/worker.toml', 'name = "offline_worker"\n')
        for config in ('[agents.offline_worker]\n',
                       '[agents.offline_worker]\nconfig_file = ""\n',
                       '[agents.other_role]\nconfig_file = "agents/worker.toml"\n'):
            with self.subTest(config=config):
                self.write('.codex/config.toml', config)
                data = self.inventory()
                self.assert_runtime_unknown(data)
                self.assertIs(data['roles'][0]['registration_present'], False)

    def test_registration_without_role_file_does_not_invent_role(self):
        self.write('.codex/config.toml',
                   '[agents.missing]\nconfig_file = "agents/missing.toml"\n')
        data = self.inventory()
        self.assertEqual(data['roles'], [])
        self.assertEqual(data['legacy_registrations'], [dict(role='missing',
                                                             target_status='missing_target',
                                                             target_file=None)])
        self.assert_runtime_unknown(data)

    def test_standalone_definition_and_configured_routing_are_distinct_from_runtime(self):
        self.write('.codex/agents/sol-planner.toml', '''
name = "sol_planner"
description = "Read-only planning"
developer_instructions = "Plan with project facts"
model = "gpt-6-sol"
model_reasoning_effort = "high"
''')
        data = self.inventory()
        self.assert_runtime_unknown(data)
        self.assertEqual(data['roles'][0]['standalone_definition'], 'valid_metadata')
        self.assertEqual(data['roles'][0]['legacy_registration'], 'absent')
        self.assertIs(data['roles'][0]['registration_present'], False)
        self.assertEqual(data['roles'][0]['configured_model'], 'gpt-6-sol')
        self.assertEqual(data['roles'][0]['configured_reasoning_effort'], 'high')

    def test_incomplete_standalone_metadata_is_reported_without_instructions(self):
        self.write('.codex/agents/luna-qa.toml',
                   f'name = "luna_qa"\ndescription = "{SECRET}"\n'
                   'model = "gpt-6-luna"\nmodel_reasoning_effort = "low"\n')
        data = self.inventory()
        self.assertEqual(data['roles'][0]['standalone_definition'], 'invalid_metadata')
        self.assertEqual(data['roles'][0]['configured_model'], 'gpt-6-luna')

    def test_registration_target_must_exist_and_match_role_file(self):
        self.write('.codex/agents/worker.toml', 'name = "worker"\n')
        self.write('.codex/agents/other.toml', 'name = "other"\n')
        self.write('.codex/config.toml',
                   '[agents.worker]\nconfig_file = "agents/other.toml"\n')
        data = self.inventory()
        worker = next(role for role in data['roles'] if role['role'] == 'worker')
        self.assertEqual(worker['legacy_registration'], 'wrong_definition')
        self.assertIs(worker['registration_present'], False)
        self.write('.codex/config.toml',
                   '[agents.worker]\nconfig_file = "agents/absent.toml"\n')
        data = self.inventory()
        worker = next(role for role in data['roles'] if role['role'] == 'worker')
        self.assertEqual(worker['legacy_registration'], 'missing_target')
        self.assertIs(worker['registration_present'], False)

    def test_registration_outside_project_agents_is_not_probed(self):
        self.write('.codex/agents/worker.toml', 'name = "worker"\n')
        self.write('.codex/config.toml',
                   f'[agents.worker]\nconfig_file = "../../{SECRET}.toml"\n')
        data = self.inventory()
        self.assertEqual(data['roles'][0]['legacy_registration'], 'invalid_target')
        self.assertEqual(data['legacy_registrations'][0]['target_status'],
                         'outside_agent_directory')
        self.assertIsNone(data['legacy_registrations'][0]['target_file'])

    def test_role_inventory_is_sorted_and_exposes_only_public_metadata(self):
        self.write('.codex/agents/z.toml', 'name = "z_worker"\n')
        self.write('.codex/agents/a.toml', 'name = "a_reviewer"\n')
        data = self.inventory()
        self.assertEqual([r['file'] for r in data['roles']], ['a.toml', 'z.toml'])
        for role in data['roles']:
            self.assertEqual(set(role), {'role', 'file', 'standalone_definition',
                                         'legacy_registration', 'registration_present',
                                         'configured_model', 'configured_reasoning_effort',
                                         'runtime_consumed'})

    def test_config_and_role_secrets_never_appear_in_success_output(self):
        self.write('.codex/config.toml', f'''
model = "{SECRET}"
api_key = "{SECRET}"
actual_model = "spoofed-live-model"
hooks_invoked = true
production_authorization = "granted"
effective_runtime_value = 999999
[agents.offline_reviewer]
config_file = "agents/reviewer.toml"
private_token = "{SECRET}"
[model_providers.synthetic]
api_key = "{SECRET}"
''')
        self.write('.codex/agents/reviewer.toml', f'''
name = "offline_reviewer"
description = "{SECRET}"
model = "{SECRET}"
developer_instructions = "{SECRET}"
api_key = "{SECRET}"
''')
        data = self.inventory()
        self.assert_runtime_unknown(data)
        self.assertNotIn('spoofed-live-model', json.dumps(data))
        self.assertNotIn('api_key', json.dumps(data))

    def test_auth_global_config_and_transcripts_are_not_inventory_inputs(self):
        global_codex = self.home / '.codex'
        global_codex.mkdir()
        # Invalid synthetic files would fail parsing if treated as config inputs.
        (global_codex / 'config.toml').write_text(SECRET + ' = [', encoding='utf-8')
        (global_codex / 'auth.json').write_text(SECRET, encoding='utf-8')
        self.write('.codex/auth.json', SECRET)
        self.write('.codex/sessions/session.jsonl', SECRET)
        data = self.inventory()
        self.assert_runtime_unknown(data)
        for key in CONTEXT_KEYS:
            self.assertIsNone(data['context'][key]['project_config_value'])

    def test_malformed_config_is_redacted_and_fails_closed(self):
        self.write('.codex/config.toml', f'api_key = "{SECRET}"\nbroken = [\n')
        self.assert_invalid()

    def test_invalid_utf8_config_is_redacted_and_fails_closed(self):
        self.config.parent.mkdir()
        self.config.write_bytes(SECRET.encode() + b'\xff')
        self.assert_invalid()

    def test_non_table_agents_configuration_is_invalid(self):
        for value in ('true', '7', '[]', f'"{SECRET}"'):
            with self.subTest(value_type=value[:2]):
                self.write('.codex/config.toml', 'agents = ' + value + '\n')
                self.assert_invalid()

    def test_invalid_context_values_are_not_effective_runtime_facts(self):
        for key in CONTEXT_KEYS:
            for value in ('0', '-1', 'true', '1.5', 'nan', 'inf', '[]',
                          '{ invalid = 1 }', f'"{SECRET}"'):
                with self.subTest(key=key, value_type=value[:2]):
                    self.write('.codex/config.toml', key + ' = ' + value + '\n')
                    self.assert_invalid()

    def test_malformed_role_is_redacted_and_fails_closed(self):
        self.write('.codex/agents/invalid.toml', f'name = "reviewer"\nsecret = "{SECRET}"\nbad = [')
        self.assert_invalid()

    def test_invalid_role_name_type_or_length_is_rejected(self):
        for value in ('7', 'true', '[]', '"' + 'x' * 81 + '"'):
            with self.subTest(value=value[:10]):
                self.write('.codex/agents/invalid.toml', 'name = ' + value + '\n')
                self.assert_invalid()
        self.write('.codex/agents/invalid.toml', 'description = "missing name"\n')
        self.assert_invalid()

    def test_bom_encoded_project_and_role_configuration_is_supported(self):
        self.write('.codex/config.toml', 'model_context_window = 8192\n', encoding='utf-8-sig')
        self.write('.codex/agents/reviewer.toml', 'name = "reviewer"\n', encoding='utf-8-sig')
        data = self.inventory()
        self.assert_runtime_unknown(data)
        self.assertEqual(data['roles'][0]['role'], 'reviewer')
        self.assertEqual(data['context']['model_context_window']['project_config_value'], 8192)

    def test_existing_config_directory_is_invalid_not_missing_configuration(self):
        self.config.mkdir(parents=True)
        self.assert_invalid()


if __name__ == '__main__':
    unittest.main(verbosity=2)
