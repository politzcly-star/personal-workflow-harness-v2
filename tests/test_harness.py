"""Offline behavior tests. Protected commands are inspected only; runner execution uses harmless temporary markers."""
import base64
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest
from datetime import datetime, timedelta, timezone

from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric import padding, rsa

ROOT = Path(__file__).resolve().parents[1]
PS = shutil.which(os.environ.get('HARNESS_TEST_POWERSHELL', 'powershell')) or shutil.which('pwsh')


class HarnessBehavior(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.key = rsa.generate_private_key(public_exponent=65537, key_size=2048)
        public = cls.key.public_key().public_numbers()
        def b64int(n):
            return base64.b64encode(n.to_bytes((n.bit_length()+7)//8, 'big')).decode()
        cls.public_xml = '<RSAKeyValue><Modulus>'+b64int(public.n)+'</Modulus><Exponent>'+b64int(public.e)+'</Exponent></RSAKeyValue>'

    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory(prefix='harness-behavior-')
        self.root = Path(self.tmp.name)
        for name in ['.codex/hooks/harness-hook.ps1', '.codex/hooks/authorize-command.ps1',
                     '.codex/hooks/validate-report.ps1', '.codex/hooks/invoke-authorized.ps1',
                     'scripts/goal-state.ps1', 'scripts/stop-check.ps1', 'scripts/scope-check.ps1']:
            dst = self.root/name
            dst.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(ROOT/name, dst)
        (self.root/'src').mkdir()
        (self.root/'tasks').mkdir()
        self.contract = self.root/'tasks/goal.md'
        self.contract.write_text('Goal ID: test\n<!-- harness:allowed-paths:start -->\n- src/\n<!-- harness:allowed-paths:end -->\n', encoding='utf-8')
        self.env = dict(os.environ, HARNESS_AUTHORITY_PUBLIC_KEY_XML=self.public_xml)
        # Let a PS5 child discover its own modules rather than inheriting PS7's module path.
        for name in list(self.env):
            if name.lower() == 'psmodulepath':
                del self.env[name]
        self.addCleanup(self.tmp.cleanup)

    def ps(self, script, *args, stdin=None, env=None):
        p = subprocess.run([PS, '-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', str(self.root/script), *args],
                           input=stdin, text=True, encoding='utf-8', errors='replace', capture_output=True,
                           cwd=self.root, env=env or self.env, timeout=30)
        return p

    def hook(self, command='', tool='exec_command', extra=None, event='PreToolUse', raw=None):
        inp = {'cmd': command, 'cwd': str(self.root)}
        if extra:
            inp.update(extra)
        payload = {'tool_name': tool, 'tool_input': command if tool == 'apply_patch' else inp}
        p = self.ps('.codex/hooks/harness-hook.ps1', '-Event', event,
                    stdin=raw if raw is not None else json.dumps(payload))
        self.assertEqual(p.returncode, 0, p.stdout+p.stderr)
        return json.loads(p.stdout.lstrip('\ufeff'))

    def denied(self, result):
        return result.get('hookSpecificOutput', {}).get('permissionDecision') == 'deny'

    def assertDecision(self, command, deny, **kwargs):
        result = self.hook(command, **kwargs)
        self.assertEqual(self.denied(result), deny, (command, result))

    def grant(self, command, changes=None):
        now = datetime.now(timezone.utc)
        payload = {'schema_version': 1, 'id': 'offline-fixture', 'project_root': str(self.root),
                   'cwd': str(self.root), 'target': 'test/api', 'version': 'sha256:AAA',
                   'not_before': (now-timedelta(minutes=1)).isoformat().replace('+00:00', 'Z'),
                   'expires_at': (now+timedelta(minutes=5)).isoformat().replace('+00:00', 'Z'),
                   'repeat_safe': True, 'command_sha256': [hashlib.sha256(command.encode()).hexdigest()],
                   'health_checks': ['health'], 'abort_conditions': ['unhealthy'],
                   'rollback': {'artifact': 'sha256:BBB', 'data_rollback_authorized': False}}
        payload.update(changes or {})
        data = json.dumps(payload).encode()
        envelope = {'Payload': base64.b64encode(data).decode(),
                    'Signature': base64.b64encode(self.key.sign(data, padding.PKCS1v15(), hashes.SHA256())).decode()}
        return {'harness_authorization': envelope, 'harness_target': 'test/api', 'harness_version': 'sha256:AAA'}

    def activate(self):
        for args in [('-Action', 'Initialize', '-GoalId', 'test', '-ContractPath', 'tasks/goal.md'),
                     ('-Action', 'Activate')]:
            p = self.ps('scripts/goal-state.ps1', *args)
            self.assertEqual(p.returncode, 0, p.stdout+p.stderr)

    def test_local_and_schema_work_is_allowed(self):
        for command in ['mkdir work', 'Copy-Item src/a.txt work/a.txt', 'echo OK > work/result.txt',
                        'Get-Content src/api.ts', 'Get-Content .env.example',
                        'echo "token=STRING"', 'echo "password=$env:PASSWORD"',
                        'npm test', 'python scripts/check.py', 'git status --short',
                        'Write-Output "sqlite3 CREATE TABLE example"',
                        'sqlite3 :memory: "CREATE TABLE example (id INTEGER);"']:
            with self.subTest(command=command):
                self.assertDecision(command, False)
        self.assertDecision('*** Begin Patch\n*** Add File: .env.example\n+TOKEN=PLACEHOLDER\n*** End Patch', False, tool='apply_patch')
        self.assertFalse(self.denied(self.hook(tool='mcp__docs__search', raw=json.dumps({'tool_name':'mcp__docs__search','tool_input':{'query':'testing'}}))))

    def test_secret_material_is_denied(self):
        for command in ['Get-Content .env.production', 'cat id_rsa', 'echo token=abcd1234realcredential',
                        'echo "Authorization: Bearer abcdefghijklmnop"']:
            with self.subTest(command=command):
                self.assertDecision(command, True)
        for patch in ['*** Add File: .env\n+X=1', '*** Add File: src/a.ts\n+token=abcd1234realcredential',
                      '*** Update File: src/a\n*** Move to: .env.production']:
            self.assertDecision(patch, True, tool='apply_patch')

    def test_unapproved_protected_commands_and_markers(self):
        for command in ['Remove-Item -LiteralPath tmp -Recurse', 'rm -r -f tmp', 'git reset --hard',
                        'psql test -c "DELETE FROM records"', 'npx prisma migrate deploy',
                        'systemctl restart api', 'kubectl apply -f release.yaml', 'npm run deploy',
                        'docker compose up -d', 'ssh prod "echo hi"', 'scp release prod:/srv',
                        'kubectl --context prod apply -f release.yaml', 'docker --context production compose up -d',
                        'systemctl restart api # approved: true harness:human-go']:
            with self.subTest(command=command):
                self.assertDecision(command, True, extra={'approved':True})

    def test_narrow_remote_inspection_only(self):
        self.assertDecision("ssh prod 'systemctl status api' # harness:server-inspection", False)
        for command in ["ssh prod 'systemctl status api; touch /tmp/x' # harness:server-inspection",
                        "ssh prod 'uname'; echo x # harness:server-inspection",
                        'ssh prod "systemctl status $(touch /tmp/x)" # harness:server-inspection']:
            self.assertDecision(command, True)

    def test_signed_exact_command_authorization(self):
        command = 'systemctl restart api'
        self.assertDecision(command, False, extra=self.grant(command))
        for changes in [{'target':'other'}, {'version':'other'}, {'cwd':str(self.root/'src')},
                        {'project_root':str(self.root/'src')}, {'repeat_safe':False}, {'repeat_safe':'true'},
                        {'expires_at':'2020-01-01T00:00:00Z'}, {'not_before':'2099-01-01T00:00:00Z'},
                        {'health_checks':[]}, {'command_sha256':['0'*64]}]:
            with self.subTest(changes=changes):
                self.assertDecision(command, True, extra=self.grant(command, changes))
        extra = self.grant(command)
        extra['harness_authorization']['Signature'] = base64.b64encode(b'wrong').decode()
        self.assertDecision(command, True, extra=extra)
        self.assertDecision(command+' ', True, extra=self.grant(command))
        secret = command+'; echo token=abcd1234realcredential'
        self.assertDecision(secret, True, extra=self.grant(secret))

    def test_malformed_input_fails_closed(self):
        for raw in ['{', '', '{}', '[]', 'null']:
            with self.subTest(raw=raw):
                self.assertTrue(self.denied(self.hook(raw=raw)))
        self.assertDecision('', True)

    def test_goal_scope_traversal_move_and_policy(self):
        self.activate()
        self.assertDecision('*** Add File: src/a.txt\n+hello', False, tool='apply_patch')
        for target in ['outside.txt', 'src/../../escape.txt', 'AGENTS.md', '.codex/hooks/harness-hook.ps1']:
            self.assertDecision('*** Add File: '+target+'\n+x', True, tool='apply_patch')
        self.assertDecision('*** Update File: src/a.txt\n*** Move to: outside.txt', True, tool='apply_patch')
        self.assertDecision('Set-Content src/a.txt hi', True)
        self.assertDecision('Set-Content src/a.txt hi', True, extra=self.grant('Set-Content src/a.txt hi'))
        self.assertDecision('Get-Content src/a.txt', False)
        self.assertDecision('mkdir src/generated', False)
        self.assertDecision('mkdir src/generated', True, extra={'workdir':str(self.root/'tasks')})
        self.assertDecision('mkdir src/generated', True, extra={'cwd':str(self.root/'tasks')})
        self.assertDecision('mkdir generated', False, extra={'cwd':None,'workdir':str(self.root/'src')})
        self.assertDecision('mkdir src/../../escaped', True)
        self.assertDecision('Write-Output "mkdir work"',False)

    def test_goal_checkpoint_is_validated_before_replacing(self):
        self.activate()
        state = self.root/'.codex/harness-state/active-goal.json'
        capsule = self.root/'.codex/harness-state/capsule-test.md'
        before = (state.read_bytes(), capsule.read_bytes())
        candidate = self.root/'tasks/next.md'
        candidate.write_text('Context epoch: 4\n', encoding='utf-8')
        p = self.ps('scripts/goal-state.ps1','-Action','Checkpoint','-CapsulePath','tasks/next.md')
        self.assertNotEqual(p.returncode,0)
        self.assertEqual(before,(state.read_bytes(),capsule.read_bytes()))
        candidate.write_text('Context epoch: 1\nNext action: verify\n',encoding='utf-8')
        p = self.ps('scripts/goal-state.ps1','-Action','Checkpoint','-CapsulePath','tasks/next.md')
        self.assertEqual(p.returncode,0,p.stdout+p.stderr)
        self.assertEqual(self.ps('scripts/goal-state.ps1','-Action','Validate').returncode,0)
        resume = self.hook(event='SessionStart',raw='{"source":"resume"}')
        self.assertIn('epoch 1',resume['hookSpecificOutput']['additionalContext'])

    def test_bad_goal_state_blocks_writes_but_not_diagnosis(self):
        self.activate()
        state = self.root/'.codex/harness-state/active-goal.json'
        good = state.read_text(encoding='utf-8-sig')
        variants = ['{']
        for changes in [{'GoalId':'../../evil'}, {'ContractPath':'../outside.md'}, {'ContextEpoch':-1}, {'ContractHash':'0'*64}, {'Status':'CORRUPT_STATUS'}]:
            data = json.loads(good); data.update(changes); variants.append(json.dumps(data))
        for value in variants:
            with self.subTest(value=value):
                state.write_text(value,encoding='utf-8')
                self.assertDecision('*** Add File: src/a\n+x',True,tool='apply_patch')
                self.assertDecision('Set-Content src/a hi',True)
                self.assertDecision('Clear-Content src/a.txt',True)
                self.assertDecision('Get-Content tasks/goal.md',False)
                self.assertNotEqual(self.ps('scripts/goal-state.ps1','-Action','Validate').returncode,0)

    def test_bad_progress_retains_scope_and_can_recover(self):
        self.activate()
        state = self.root/'.codex/harness-state/active-goal.json'
        capsule = self.root/'.codex/harness-state/capsule-test.md'
        contract_hash = json.loads(state.read_text(encoding='utf-8-sig'))['ContractHash']
        for mode in ['missing', 'stale', 'secret', 'oversized', 'hash', 'epoch', 'missing-fields']:
            with self.subTest(mode=mode):
                data = json.loads(state.read_text(encoding='utf-8-sig'))
                epoch = data['ContextEpoch']
                if mode == 'missing':
                    capsule.unlink()
                elif mode == 'missing-fields':
                    for field in ['CapsuleHash','Milestone','NextAction','UpdatedUtc']:
                        data.pop(field, None)
                    state.write_text(json.dumps(data), encoding='utf-8')
                elif mode == 'epoch':
                    data['ContextEpoch'] = epoch + 8
                    epoch = data['ContextEpoch']
                    state.write_text(json.dumps(data), encoding='utf-8')
                else:
                    value = {'stale': 'Context epoch: 999\n', 'secret': 'token=abcd1234realcredential',
                             'oversized': 'x'*17000, 'hash': 'Context epoch: '+str(epoch)+'\nchanged'}[mode]
                    capsule.write_text(value, encoding='utf-8')
                self.assertDecision('*** Add File: src/a\n+x', False, tool='apply_patch')
                self.assertDecision('*** Add File: outside\n+x', True, tool='apply_patch')
                self.assertNotEqual(self.ps('scripts/goal-state.ps1','-Action','Validate').returncode, 0)
                resume = self.hook(event='SessionStart', raw='{"source":"resume"}')
                self.assertIn('progress capsule is unavailable/unsafe', resume['hookSpecificOutput']['additionalContext'])
                self.assertNotIn('abcd1234realcredential', json.dumps(resume))
                (self.root/'tasks/next.md').write_text('Context epoch: '+str(epoch+1)+'\nNext action: continue verified work\n', encoding='utf-8')
                result = self.ps('scripts/goal-state.ps1','-Action','Checkpoint','-CapsulePath','tasks/next.md')
                self.assertEqual(result.returncode, 0, result.stdout+result.stderr)
                self.assertEqual(self.ps('scripts/goal-state.ps1','-Action','Validate').returncode, 0)
                self.assertEqual(json.loads(state.read_text(encoding='utf-8-sig'))['ContractHash'], contract_hash)

    def runner(self, command, extra=None, execute=False, env=None):
        request = {'command': command, 'cwd': str(self.root)}
        request.update(extra or {})
        (self.root/'request.json').write_text(json.dumps(request, ensure_ascii=False), encoding='utf-8')
        args = ['-RequestPath', str(self.root/'request.json')]
        if execute:
            args.append('-Execute')
        return self.ps('.codex/hooks/invoke-authorized.ps1', *args, env=env)

    def test_signed_runner_validates_without_execution_then_executes_exact_marker(self):
        command = "Set-Content -LiteralPath 'src/marker.txt' -Value 'fixture'"
        result = self.runner(command, self.grant(command))
        self.assertEqual(result.returncode, 0, result.stdout+result.stderr)
        self.assertIn('nothing executed', result.stdout)
        self.assertFalse((self.root/'src/marker.txt').exists())
        result = self.runner(command, self.grant(command), execute=True)
        self.assertEqual(result.returncode, 0, result.stdout+result.stderr)
        self.assertEqual((self.root/'src/marker.txt').read_text().strip(), 'fixture')

    def test_signed_runner_rejects_missing_expired_mismatched_and_untrusted_grants(self):
        command = "Set-Content -LiteralPath 'src/marker.txt' -Value 'fixture'"
        for extra in [None, self.grant(command, {'expires_at':'2020-01-01T00:00:00Z'}),
                      self.grant(command+' '), self.grant(command, {'target':'wrong'})]:
            result = self.runner(command, extra, execute=True)
            self.assertNotEqual(result.returncode, 0, result.stdout+result.stderr)
            self.assertFalse((self.root/'src/marker.txt').exists())
        env = dict(self.env); env.pop('HARNESS_AUTHORITY_PUBLIC_KEY_XML')
        self.assertNotEqual(self.runner(command, self.grant(command), execute=True, env=env).returncode, 0)
        self.assertFalse((self.root/'src/marker.txt').exists())

    def test_signed_runner_does_not_bypass_secret_or_goal_scope(self):
        command = "Set-Content -LiteralPath 'src/marker.txt' -Value 'token=abcd1234realcredential'"
        result = self.runner(command, self.grant(command), execute=True)
        self.assertNotEqual(result.returncode, 0)
        self.assertNotIn('abcd1234realcredential', result.stdout+result.stderr)
        self.assertFalse((self.root/'src/marker.txt').exists())
        self.activate()
        command = 'mkdir outside'
        self.assertNotEqual(self.runner(command, self.grant(command), execute=True).returncode, 0)
        self.assertFalse((self.root/'outside').exists())
        command = 'mkdir src/inside'
        result = self.runner(command, self.grant(command), execute=True)
        self.assertEqual(result.returncode, 0, result.stdout+result.stderr)
        self.assertTrue((self.root/'src/inside').is_dir())

    def test_signed_runner_binds_dotnet_cwd_and_utf8_request(self):
        bound = self.root/'中文目录'
        bound.mkdir()
        command = "[IO.File]::WriteAllText('标记.txt', '中文授权')"
        extra = self.grant(command, {'cwd':str(bound)})
        extra['cwd'] = str(bound)
        result = self.runner(command, extra, execute=True)
        self.assertEqual(result.returncode, 0, result.stdout+result.stderr)
        self.assertEqual((bound/'标记.txt').read_text(encoding='utf-8'), '中文授权')
        self.assertFalse((self.root/'标记.txt').exists())

    @unittest.skipUnless(os.name == 'nt', 'Windows exclusive sharing fixture')
    def test_unreadable_capsule_does_not_revoke_intact_contract(self):
        import ctypes
        from ctypes import wintypes
        self.activate()
        capsule = self.root/'.codex/harness-state/capsule-test.md'
        kernel = ctypes.WinDLL('kernel32', use_last_error=True)
        kernel.CreateFileW.argtypes = [wintypes.LPCWSTR,wintypes.DWORD,wintypes.DWORD,
                                      wintypes.LPVOID,wintypes.DWORD,wintypes.DWORD,wintypes.HANDLE]
        kernel.CreateFileW.restype = wintypes.HANDLE
        kernel.CloseHandle.argtypes = [wintypes.HANDLE]
        handle = kernel.CreateFileW(str(capsule),0x80000000,0,None,3,0,None)
        self.assertNotEqual(handle, ctypes.c_void_p(-1).value)
        try:
            self.assertDecision('*** Add File: src/a\n+x', False, tool='apply_patch')
            self.assertDecision('*** Add File: outside\n+x', True, tool='apply_patch')
            resume = self.hook(event='SessionStart', raw='{"source":"resume"}')
            self.assertIn('progress capsule is unavailable/unsafe', resume['hookSpecificOutput']['additionalContext'])
        finally:
            kernel.CloseHandle(handle)

    def test_initialize_invalid_id_or_contract_does_not_create_active_state(self):
        for goal_id, contract in [('../bad','tasks/goal.md'),('okay','../outside.md')]:
            p = self.ps('scripts/goal-state.ps1','-Action','Initialize','-GoalId',goal_id,'-ContractPath',contract)
            self.assertNotEqual(p.returncode,0)
            self.assertFalse((self.root/'.codex/harness-state/active-goal.json').exists())

    def test_completion_requires_successful_status(self):
        self.activate()
        report = self.root/'tasks/report.md'
        for status in ['NO-GO','partial','failed','passed']:
            text = '\n'.join(['Task ID: test','Status: '+status,'Changed Files: src/a',
                              'Checks Run: offline fixture','Scope Guard: checked',
                              'Residual Risk: none in fixture','Next Recommended Action: close'])
            report.write_text(text,encoding='utf-8')
            p = self.ps('scripts/stop-check.ps1','-ReportPath','tasks/report.md')
            self.assertEqual(p.returncode == 0,status == 'passed',p.stdout+p.stderr)
            p = self.ps('scripts/goal-state.ps1','-Action','Close','-ReportPath','tasks/report.md')
            self.assertEqual(p.returncode == 0,status == 'passed',p.stdout+p.stderr)
        self.assertFalse((self.root/'.codex/harness-state/active-goal.json').exists())

    def test_contradictory_or_wrong_goal_report_cannot_close(self):
        self.activate()
        good = '\n'.join(['Task ID: test','Status: passed','Changed Files: src/a',
                           'Checks Run: PASS offline','Scope Guard: checked','Residual Risk: none',
                           'Next Recommended Action: close'])
        for value in [good+'\nStatus: failed',good.replace('Task ID: test','Task ID: other'),
                      good.replace('PASS offline','PASS unit\npersistence: BLOCKED'),
                      good.replace('PASS offline','10 passed, 10 failed'),
                      good.replace('PASS offline','tenant-isolation: FAIL'),
                      good.replace('PASS offline','persistence: BLOCKED'),good.replace('Changed Files: src/a','Changed Files:')]:
            with self.subTest(value=value):
                (self.root/'tasks/report.md').write_text(value,encoding='utf-8')
                self.assertNotEqual(self.ps('scripts/stop-check.ps1','-ReportPath','tasks/report.md','-ExpectedTaskId','test').returncode,0)
                self.assertNotEqual(self.ps('scripts/goal-state.ps1','-Action','Close','-ReportPath','tasks/report.md').returncode,0)
                self.assertDecision('powershell -File scripts/goal-state.ps1 -Action Close -ReportPath tasks/report.md # harness:goal-close',True)
                self.assertTrue((self.root/'.codex/harness-state/active-goal.json').exists())
        (self.root/'tasks/report.md').write_text(good.replace('PASS offline','10 passed, 0 failed'),encoding='utf-8')
        self.assertEqual(self.ps('scripts/stop-check.ps1','-ReportPath','tasks/report.md').returncode,0)
        self.assertDecision('powershell -File scripts/goal-state.ps1 -Action Close -ReportPath tasks/report.md # harness:goal-close',False)
        self.assertEqual(self.ps('scripts/goal-state.ps1','-Action','Close','-ReportPath','tasks/report.md').returncode,0)


if __name__ == '__main__':
    unittest.main(verbosity=2)
