"""Local evidence -> actual branch-finish integration, never remote operations."""
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
PS = shutil.which(os.environ.get('HARNESS_TEST_POWERSHELL', 'powershell'))


@unittest.skipUnless(PS and shutil.which('git'), 'local PowerShell and Git are required')
class BranchEvidence(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory(prefix='harness-branch-')
        self.root = Path(self.tmp.name)
        self.addCleanup(self.tmp.cleanup)
        self.env = {k: v for k, v in os.environ.items() if not k.upper().startswith('GIT_')}
        self.env.update(GIT_CONFIG_NOSYSTEM='1',
                        GIT_CONFIG_GLOBAL=str(self.root / '.git/no-global-config'),
                        GIT_TERMINAL_PROMPT='0', PYTHONDONTWRITEBYTECODE='1')
        self.env['PATH'] = str(Path(sys.executable).parent)+os.pathsep+self.env.get('PATH','')
        for name in list(self.env):
            if name.lower() == 'psmodulepath':
                del self.env[name]
        (self.root/'scripts').mkdir()
        for name in ['branch-finish-check.ps1','scope-check.ps1','verification-evidence.py']:
            shutil.copy2(ROOT/'scripts'/name, self.root/'scripts'/name)
        (self.root/'source.txt').write_text('original', encoding='utf-8')
        (self.root/'.gitignore').write_text('.codex/harness-state/\n', encoding='utf-8')
        self.git('init', '--template=', '-b', 'custom-base')
        self.git('config', 'core.autocrlf', 'false')
        self.git('add', '.')
        self.git('-c','core.hooksPath=NUL','-c','commit.gpgsign=false',
                 '-c','user.name=Fixture','-c','user.email=fixture@example.invalid','commit','-m','fixture')
        self.base = self.git('rev-parse','HEAD').stdout.strip()
        self.evidence = '.codex/harness-state/verification/unit.json'

    def git(self, *args):
        result = subprocess.run(['git','-C',str(self.root),*args], capture_output=True,
                                text=True, timeout=30, env=self.env)
        self.assertEqual(result.returncode, 0, result.stderr)
        return result

    def record(self):
        # Output inside excluded workflow state, not project source.
        command = "from pathlib import Path; p=Path('.codex/harness-state/count.txt'); p.parent.mkdir(parents=True,exist_ok=True); p.write_text(str(int(p.read_text())+1) if p.exists() else '1')"
        result = subprocess.run([sys.executable,'-B',str(self.root/'scripts/verification-evidence.py'),'run',
                                 '--project',str(self.root),'--evidence',self.evidence,'--check-id','unit',
                                 '--environment-id','fixture-python','--',sys.executable,'-B','-c',command],
                                capture_output=True, text=True, timeout=30, env=self.env)
        self.assertEqual(result.returncode, 0, result.stdout+result.stderr)

    def finish(self, *args):
        return subprocess.run([PS,'-NoProfile','-ExecutionPolicy','Bypass','-File',
                               str(self.root/'scripts/branch-finish-check.ps1'),'-Strict','-BaseRef',self.base,*args],
                              capture_output=True, text=True, encoding='utf-8', errors='replace',
                              env=self.env, timeout=30)

    def evidence_args(self):
        return ['-EvidencePath',self.evidence,'-CheckId','unit','-EnvironmentId','fixture-python']

    def test_current_evidence_reused_without_running_check_twice(self):
        self.record()
        result = self.finish(*self.evidence_args())
        self.assertEqual(result.returncode, 0, result.stdout+result.stderr)
        self.assertIn('reused current local evidence', result.stdout)
        self.assertEqual((self.root/'.codex/harness-state/count.txt').read_text(), '1')

    def test_source_change_blocks_reuse(self):
        self.record()
        (self.root/'source.txt').write_text('changed', encoding='utf-8')
        result = self.finish(*self.evidence_args())
        self.assertNotEqual(result.returncode, 0, result.stdout+result.stderr)
        self.assertEqual((self.root/'.codex/harness-state/count.txt').read_text(), '1')

    def test_staged_change_after_pass_and_restored_worktree_blocks_finish(self):
        self.record()
        source = self.root / 'source.txt'
        original = source.read_bytes()
        source.write_text('staged but unchecked', encoding='utf-8')
        self.git('add', '--', 'source.txt')
        source.write_bytes(original)
        result = self.finish(*self.evidence_args())
        self.assertNotEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertNotIn('reused current local evidence', result.stdout)
        self.assertEqual((self.root/'.codex/harness-state/count.txt').read_text(), '1')

    def test_preexisting_index_worktree_mismatch_blocks_finish(self):
        source = self.root / 'source.txt'
        original = source.read_bytes()
        source.write_text('staged but unchecked', encoding='utf-8')
        self.git('add', '--', 'source.txt')
        source.write_bytes(original)
        self.record()
        result = self.finish(*self.evidence_args())
        self.assertNotEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertNotIn('reused current local evidence', result.stdout)
        self.assertEqual((self.root/'.codex/harness-state/count.txt').read_text(), '1')

    def test_aligned_staged_content_reuses_across_finish_checks(self):
        (self.root / 'source.txt').write_text('intended staged change', encoding='utf-8')
        self.git('add', '--', 'source.txt')
        self.record()
        for _ in range(2):
            result = self.finish(*self.evidence_args())
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
            self.assertIn('reused current local evidence', result.stdout)
        self.assertEqual((self.root/'.codex/harness-state/count.txt').read_text(), '1')

    def test_legacy_evidence_without_index_binding_blocks_finish(self):
        self.record()
        path = self.root / self.evidence
        data = json.loads(path.read_text())
        for field in ('index_sha256', 'index_unchanged', 'index_matches_worktree'):
            del data[field]
        path.write_text(json.dumps(data), encoding='utf-8')
        result = self.finish(*self.evidence_args())
        self.assertNotEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertNotIn('reused current local evidence', result.stdout)

    def test_autocrlf_staged_content_reuses_across_finish_checks(self):
        self.git('config', 'core.autocrlf', 'true')
        (self.root / 'source.txt').write_bytes(b'intended Windows text\r\n')
        self.git('add', '--', 'source.txt')
        self.record()
        for _ in range(2):
            result = self.finish(*self.evidence_args())
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual((self.root / '.codex/harness-state/count.txt').read_text(), '1')

    def test_missing_verification_or_ambiguous_inputs_fail(self):
        self.assertNotEqual(self.finish().returncode, 0)
        self.record()
        self.assertNotEqual(self.finish(*self.evidence_args(), '-TestCommand','Write-Output fixture').returncode, 0)
        self.assertNotEqual(self.finish('-EvidencePath',self.evidence).returncode, 0)

    def test_command_result_is_checked(self):
        result = self.finish('-TestCommand','Write-Output fixture')
        self.assertEqual(result.returncode, 0, result.stdout+result.stderr)
        self.assertNotEqual(self.finish('-TestCommand',"python -c 'import sys; sys.exit(7)'").returncode, 0)


if __name__ == '__main__':
    unittest.main()
