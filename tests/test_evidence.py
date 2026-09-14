"""Offline CLI regressions using real, isolated Git repositories and local Python.

No checkout under test is changed. All commands, links and synthetic secret-like
fixtures live in TemporaryDirectory; no providers, remotes or shell checks run.
"""
from datetime import datetime, timedelta, timezone
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]
SCRIPT = ROOT / 'scripts/verification-evidence.py'
EVIDENCE = '.codex/harness-state/verification/check.json'
CHECK_ID = 'offline-python-check-v1'
ENVIRONMENT_ID = 'isolated-local-fixture-v1'
CHECK = [sys.executable, '-I', '-B', '-c', (
    'from pathlib import Path; '
    'p=Path(".codex/harness-state/executions.txt"); '
    'p.parent.mkdir(parents=True, exist_ok=True); '
    'p.write_text(p.read_text() + "run\\n" if p.exists() else "run\\n")'
)]


@unittest.skipUnless(shutil.which('git'), 'real Git is required')
class EvidenceTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory(prefix='evidence-tests-')
        self.addCleanup(self.tmp.cleanup)
        self.scratch = Path(self.tmp.name).resolve()
        self.root = self.scratch / 'project'
        self.root.mkdir()
        self.empty_template = self.scratch / 'empty-template'
        self.empty_template.mkdir()
        # Do not inherit a caller's index, repository, hooks, filters or config.
        self.env = {k: v for k, v in os.environ.items()
                    if not k.upper().startswith('GIT_')}
        self.env.update(GIT_CONFIG_NOSYSTEM='1',
                        GIT_CONFIG_GLOBAL=str(self.scratch / 'no-global-config'),
                        GIT_TERMINAL_PROMPT='0', PYTHONDONTWRITEBYTECODE='1')
        self.git('init', '-q', '--template=' + str(self.empty_template))
        self.git('config', 'core.hooksPath', str(self.empty_template))
        self.git('config', 'core.autocrlf', 'false')
        self.source = self.root / 'source.txt'
        self.source.write_text('original\n', encoding='utf-8')
        self.git('add', '--', 'source.txt')
        self.git('-c', 'user.name=Offline Fixture',
                 '-c', 'user.email=fixture@example.invalid',
                 '-c', 'commit.gpgsign=false', 'commit', '-qm', 'fixture')
        self.record_path = self.root / EVIDENCE
        self.marker = self.root / '.codex/harness-state/executions.txt'

    def git(self, *args, stdin=None):
        result = subprocess.run(['git', '-C', str(self.root), *args],
                                capture_output=True, text=True, env=self.env, input=stdin,
                                timeout=20)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        return result

    def cli(self, action, *, evidence=EVIDENCE, check_id=CHECK_ID,
            environment_id=ENVIRONMENT_ID, argv=None, project=None, require_index_match=False):
        command = [sys.executable, '-I', '-B', str(SCRIPT), action,
                   '--project', str(project or self.root),
                   '--evidence', str(evidence), '--check-id', check_id,
                   '--environment-id', environment_id]
        if require_index_match:
            command.append('--require-index-match')
        if argv is not None:
            command.extend(['--', *argv])
        return subprocess.run(command, capture_output=True, text=True,
                              encoding='utf-8', errors='replace', env=self.env,
                              cwd=self.scratch, timeout=20)

    def assert_exit(self, result, code):
        self.assertEqual(result.returncode, code, result.stdout + result.stderr)
        if code:
            self.assertNotIn('[OK]', result.stdout)

    def run_ok(self, argv=None):
        self.assert_exit(self.cli('run', argv=CHECK if argv is None else argv), 0)
        return json.loads(self.record_path.read_text(encoding='utf-8'))

    def write_record(self, data):
        self.record_path.parent.mkdir(parents=True, exist_ok=True)
        self.record_path.write_text(json.dumps(data), encoding='utf-8')

    def make_symlink(self, link, target, *, directory=False):
        try:
            link.symlink_to(target, target_is_directory=directory)
        except (OSError, NotImplementedError) as error:
            if isinstance(error, OSError) and (error.errno in (1, 13, 38, 95)
                                               or getattr(error, 'winerror', None) == 1314):
                self.skipTest('symlink creation unavailable: ' + str(error))
            if isinstance(error, NotImplementedError):
                self.skipTest('symlinks unsupported')
            raise
        # Unlink explicitly before TemporaryDirectory traverses the fixture.
        self.addCleanup(link.unlink)

    def test_success_records_real_execution_and_reuses_without_rerunning(self):
        data = self.run_ok()
        self.assertEqual(data['schema_version'], 1)
        self.assertEqual(data['kind'], 'local_check_freshness')
        self.assertEqual(data['project_root'], str(self.root))
        self.assertEqual(data['check_id'], CHECK_ID)
        self.assertEqual(data['environment_id'], ENVIRONMENT_ID)
        self.assertEqual(data['exit_code'], 0)
        self.assertIs(data['source_unchanged'], True)
        self.assertIs(data['index_unchanged'], True)
        self.assertIs(data['index_matches_worktree'], True)
        self.assertEqual(data['index_sha256'], hashlib.sha256(
            self.git('ls-files', '--stage', '-z').stdout.encode('utf-8')).hexdigest())
        self.assertEqual(data['command_sha256'], hashlib.sha256(
            json.dumps(CHECK, ensure_ascii=False).encode('utf-8')).hexdigest())
        self.assertRegex(data['source_sha256'], r'^[a-f0-9]{64}$')
        self.assertGreaterEqual(data['elapsed_seconds'], 0)
        self.assertLessEqual(datetime.fromisoformat(data['started_utc']),
                             datetime.fromisoformat(data['finished_utc']))
        before = (self.record_path.read_bytes(), self.record_path.stat().st_mtime_ns)
        self.assert_exit(self.cli('verify'), 0)
        self.assert_exit(self.cli('verify'), 0)
        self.assert_exit(self.cli('verify', require_index_match=True), 0)
        self.assertEqual(self.marker.read_text(), 'run\n')
        self.assertEqual(before, (self.record_path.read_bytes(),
                                  self.record_path.stat().st_mtime_ns))

    def test_content_change_with_same_length_and_mtime_invalidates(self):
        self.run_ok()
        stat = self.source.stat()
        self.source.write_text('modified\n', encoding='utf-8')
        os.utime(self.source, ns=(stat.st_atime_ns, stat.st_mtime_ns))
        self.assert_exit(self.cli('verify'), 1)

    def test_untracked_addition_invalidates(self):
        self.run_ok()
        (self.root / 'new source.txt').write_text('new\n', encoding='utf-8')
        self.assert_exit(self.cli('verify'), 1)

    def test_staged_addition_invalidates(self):
        self.run_ok()
        (self.root / 'added.txt').write_text('new\n', encoding='utf-8')
        self.git('add', '--', 'added.txt')
        self.assert_exit(self.cli('verify'), 1)

    def test_tracked_deletion_invalidates(self):
        self.run_ok()
        self.source.unlink()
        self.assert_exit(self.cli('verify'), 1)

    def test_staged_deletion_invalidates(self):
        # Keep a nonempty snapshot so this checks staleness, not empty-root rejection.
        (self.root / 'remaining.txt').write_text('remaining source\n', encoding='utf-8')
        self.run_ok()
        self.source.unlink()
        self.git('add', '-u')
        self.assert_exit(self.cli('verify'), 1)

    def test_untracked_deletion_invalidates(self):
        extra = self.root / 'extra.txt'
        extra.write_text('extra\n', encoding='utf-8')
        self.run_ok()
        extra.unlink()
        self.assert_exit(self.cli('verify'), 1)

    def test_metadata_only_change_does_not_invalidate_content(self):
        self.run_ok()
        stat = self.source.stat()
        os.utime(self.source, ns=(stat.st_atime_ns, stat.st_mtime_ns + 2_000_000_000))
        self.assert_exit(self.cli('verify'), 0)

    def test_environment_or_check_identity_change_invalidates(self):
        self.run_ok()
        for changes in ({'environment_id': 'different-tools'},
                        {'check_id': 'different-acceptance'}):
            with self.subTest(changes=changes):
                self.assert_exit(self.cli('verify', **changes), 1)
        self.assertEqual(self.marker.read_text(), 'run\n')

    def test_index_change_after_pass_cannot_hide_behind_restored_worktree(self):
        self.run_ok()
        original = self.source.read_bytes()
        self.source.write_text('staged but never checked\n', encoding='utf-8')
        self.git('add', '--', 'source.txt')
        self.source.write_bytes(original)
        self.assert_exit(self.cli('verify'), 1)
        self.assertEqual(self.marker.read_text(), 'run\n')

    def test_preexisting_index_worktree_mismatch_is_local_only_not_staged_acceptance(self):
        original = self.source.read_bytes()
        self.source.write_text('SYNTHETIC_STAGED_ONLY_CONTENT_91\n', encoding='utf-8')
        self.git('add', '--', 'source.txt')
        self.source.write_bytes(original)
        for flag in (None, '--assume-unchanged', '--skip-worktree'):
            with self.subTest(flag=flag):
                if flag:
                    self.git('update-index', flag, '--', 'source.txt')
                data = self.run_ok()
                self.assertIs(data['index_matches_worktree'], False)
                self.assert_exit(self.cli('verify'), 0)
                self.assert_exit(self.cli('verify', require_index_match=True), 1)
                self.assertNotIn('SYNTHETIC_STAGED_ONLY_CONTENT_91', self.record_path.read_text())

    def test_staged_content_agrees_and_reuses_without_rerunning(self):
        self.source.write_text('intended staged change\n', encoding='utf-8')
        self.git('add', '--', 'source.txt')
        self.run_ok()
        for _ in range(2):
            # An index stat refresh must not be mistaken for new staged content.
            self.git('update-index', '--refresh')
            self.assert_exit(self.cli('verify'), 0)
            self.assert_exit(self.cli('verify', require_index_match=True), 0)
        self.assertEqual(self.marker.read_text(), 'run\n')

    def test_unstaged_development_result_is_not_staged_acceptance(self):
        self.source.write_text('ordinary unstaged development\n', encoding='utf-8')
        data = self.run_ok()
        self.assertIs(data['index_matches_worktree'], False)
        self.assert_exit(self.cli('verify'), 0)
        self.assert_exit(self.cli('verify'), 0)
        self.assert_exit(self.cli('verify', require_index_match=True), 1)
        self.assertEqual(self.marker.read_text(), 'run\n')
        # Aligning the index changes its identity; check once on the intended tree.
        self.git('add', '--', 'source.txt')
        self.assert_exit(self.cli('verify'), 1)
        self.run_ok()
        self.assert_exit(self.cli('verify'), 0)
        self.assertEqual(self.marker.read_text(), 'run\nrun\n')

    def test_index_mode_change_during_check_invalidates_unchanged_source(self):
        original = self.source.read_bytes()
        result = self.cli('run', argv=['git', 'update-index', '--chmod=+x', 'source.txt'])
        self.assert_exit(result, 1)
        data = json.loads(self.record_path.read_text())
        self.assertEqual(data['exit_code'], 0)
        self.assertIs(data['source_unchanged'], True)
        self.assertIs(data['index_unchanged'], False)
        self.assertEqual(self.source.read_bytes(), original)
        self.assert_exit(self.cli('verify'), 1)

    def test_index_mode_change_after_pass_invalidates(self):
        data = self.run_ok()
        self.git('update-index', '--chmod=+x', 'source.txt')
        current = hashlib.sha256(self.git('ls-files', '--stage', '-z').stdout.encode()).hexdigest()
        self.assertNotEqual(data['index_sha256'], current)
        self.assert_exit(self.cli('verify'), 1)

    def test_unmerged_stage_identity_cannot_reuse_unchanged_blob(self):
        self.run_ok()
        oid = self.git('rev-parse', ':source.txt').stdout.strip()
        self.git('update-index', '-z', '--index-info',
                 stdin=f'0 {"0" * len(oid)}\tsource.txt\0' + f'100644 {oid} 2\tsource.txt\0')
        self.assertIn(' 2\tsource.txt', self.git('ls-files', '--stage').stdout)
        self.assert_exit(self.cli('verify'), 1)
        data = self.run_ok()
        self.assertIs(data['index_matches_worktree'], False)
        self.assert_exit(self.cli('verify', require_index_match=True), 1)

    def test_preexisting_staged_deletion_with_restored_file_is_not_acceptance(self):
        self.git('update-index', '--force-remove', '--', 'source.txt')
        self.assertTrue(self.source.exists())
        data = self.run_ok()
        self.assertIs(data['index_matches_worktree'], False)
        self.assert_exit(self.cli('verify', require_index_match=True), 1)

    def test_declared_crlf_normalization_reuses_staged_evidence(self):
        attrs = self.root / '.gitattributes'
        for autocrlf, declaration in (('true', ''), ('input', ''),
                                      ('false', 'text'), ('false', 'text=auto'),
                                      ('false', 'text eol=crlf'), ('false', 'eol=lf')):
            with self.subTest(autocrlf=autocrlf, declaration=declaration):
                self.git('config', 'core.autocrlf', autocrlf)
                attrs.write_bytes(('source.txt ' + declaration + '\n').encode() if declaration else b'')
                self.source.write_bytes(b'original\r\nsecond line\r\n')
                self.git('add', '--', '.gitattributes')
                self.git('add', '--renormalize', '--', 'source.txt')
                # Compare metadata with a known LF hash; never inspect a staged blob.
                lf = b'original\nsecond line\n'
                self.assertEqual(self.git('rev-parse', ':source.txt').stdout.strip(),
                                 hashlib.sha1(b'blob ' + str(len(lf)).encode() + b'\0' + lf).hexdigest())
                data = self.run_ok()
                self.assertIs(data['index_matches_worktree'], True)
                marker = self.marker.read_bytes()
                for _ in range(2):
                    self.assert_exit(self.cli('verify', require_index_match=True), 0)
                self.assertEqual(self.marker.read_bytes(), marker)
                # A different staged payload must not pass as an EOL conversion.
                self.source.write_bytes(b'UNCHECKED staged payload\r\n')
                self.git('add', '--', 'source.txt')
                self.source.write_bytes(b'original\r\nsecond line\r\n')
                self.assert_exit(self.cli('verify', require_index_match=True), 1)
                self.run_ok()
                self.assert_exit(self.cli('verify'), 0)
                self.assert_exit(self.cli('verify', require_index_match=True), 1)

    def test_undeclared_or_binary_crlf_is_not_silently_normalized(self):
        attrs = self.root / '.gitattributes'
        for autocrlf, declaration, lf in (('false', '', b'original\n'),
                                          ('true', '-text', b'original\n'),
                                          ('true', '', b'original\x00\n')):
            with self.subTest(autocrlf=autocrlf, declaration=declaration, lf=lf):
                self.git('config', 'core.autocrlf', autocrlf)
                attrs.write_bytes(('source.txt ' + declaration + '\n').encode() if declaration else b'')
                self.source.write_bytes(lf)
                self.git('add', '--', '.gitattributes', 'source.txt')
                self.source.write_bytes(lf.replace(b'\n', b'\r\n'))
                data = self.run_ok()
                self.assertIs(data['index_matches_worktree'], False)
                self.assert_exit(self.cli('verify'), 0)
                self.assert_exit(self.cli('verify', require_index_match=True), 1)

    def test_custom_conversions_are_local_only_and_never_executed(self):
        # If mistakenly invoked, this harmless local filter leaves an observable marker.
        filter_marker = self.root / '.codex/harness-state/filter-ran'
        self.git('config', 'filter.fixture.clean',
                 'echo invoked > .codex/harness-state/filter-ran')
        attrs = self.root / '.gitattributes'
        for declaration in ('filter=fixture', 'working-tree-encoding=UTF-16', 'ident', 'crlf'):
            with self.subTest(declaration=declaration):
                attrs.write_bytes(('source.txt ' + declaration + '\n').encode())
                # Stage the declaration only, never execute conversion via git add source.txt.
                self.git('add', '--', '.gitattributes')
                data = self.run_ok()
                self.assertIs(data['index_matches_worktree'], False)
                self.assert_exit(self.cli('verify'), 0)
                self.assert_exit(self.cli('verify', require_index_match=True), 1)
                self.assertFalse(filter_marker.exists())

    def test_failed_check_records_failure_and_cannot_be_reused(self):
        argv = [sys.executable, '-I', '-B', '-c', 'raise SystemExit(7)']
        self.assert_exit(self.cli('run', argv=argv), 1)
        data = json.loads(self.record_path.read_text())
        self.assertEqual(data['exit_code'], 7)
        self.assertIs(data['source_unchanged'], True)
        self.assert_exit(self.cli('verify'), 1)

    def test_failed_rerun_replaces_previous_success(self):
        self.run_ok()
        self.assert_exit(self.cli('run', argv=[sys.executable, '-I', '-B', '-c',
                                              'raise SystemExit(3)']), 1)
        self.assert_exit(self.cli('verify'), 1)
        self.assertEqual(json.loads(self.record_path.read_text())['exit_code'], 3)

    def test_successful_command_mutating_source_is_not_passing_evidence(self):
        argv = [sys.executable, '-I', '-B', '-c',
                'from pathlib import Path; Path("source.txt").write_text("changed")']
        self.assert_exit(self.cli('run', argv=argv), 1)
        self.assertEqual(self.source.read_text(), 'changed')
        data = json.loads(self.record_path.read_text())
        self.assertEqual(data['exit_code'], 0)
        self.assertIs(data['source_unchanged'], False)
        self.assert_exit(self.cli('verify'), 1)

    def test_missing_program_records_no_pass(self):
        self.assert_exit(self.cli('run', argv=[str(self.scratch / 'absent-program')]), 2)
        # A non-PASS in-progress record is permitted, but reusable success is not.
        result = self.cli('verify')
        self.assertNotEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertNotIn('[OK]', result.stdout)
        self.assertFalse(self.marker.exists())

    def test_startup_failure_invalidates_previous_successful_evidence(self):
        self.run_ok()
        self.assert_exit(self.cli('verify'), 0)
        self.assert_exit(self.cli('run', argv=[str(self.scratch / 'absent-program')]), 2)
        result = self.cli('verify')
        self.assertNotEqual(result.returncode, 0,
                            'a failed new run must not leave the old PASS reusable: '
                            + result.stdout + result.stderr)
        self.assertNotIn('[OK]', result.stdout)

    def test_verify_rejects_program_without_executing_it(self):
        self.run_ok()
        self.assert_exit(self.cli('verify', argv=CHECK), 2)
        self.assertEqual(self.marker.read_text(), 'run\n')

    def test_run_requires_nonempty_identities_and_exact_argv(self):
        for changes in ({'check_id': ' '}, {'environment_id': ''}, {'argv': []}):
            with self.subTest(changes=changes):
                options = {'argv': CHECK, **changes}
                self.assert_exit(self.cli('run', **options), 2)
                self.assertFalse(self.marker.exists())
                self.assertFalse(self.record_path.exists())

    def test_template_is_not_evidence(self):
        template = json.loads((ROOT / 'templates/verification-evidence.json').read_text())
        self.write_record(template)
        self.assert_exit(self.cli('verify'), 1)

    def test_missing_malformed_nonobject_and_oversized_evidence_rejected(self):
        self.assert_exit(self.cli('verify'), 2)
        self.record_path.parent.mkdir(parents=True)
        for raw in ('{', '[]', 'null', '"not an object"', ' ' * 16385):
            with self.subTest(raw=raw[:30]):
                self.record_path.write_text(raw, encoding='utf-8')
                self.assert_exit(self.cli('verify'), 2)

    def test_invalid_record_fields_never_establish_pass(self):
        original = self.run_ok()
        future = (datetime.now(timezone.utc) + timedelta(days=2)).isoformat()
        changes = [dict(schema_version=2), dict(kind='template_only_not_evidence'),
                   dict(project_root=str(self.scratch)), dict(exit_code=False),
                   dict(exit_code='0'), dict(source_unchanged=1),
                   dict(command_sha256='not-a-hash'), dict(source_sha256='0' * 64),
                   dict(index_sha256='not-a-hash'), dict(index_sha256='0' * 64),
                   dict(index_unchanged=False), dict(index_unchanged=1),
                   dict(index_matches_worktree=1),
                   dict(started_utc='bad'), dict(started_utc='2020-01-01T00:00:00'),
                   dict(started_utc=future), dict(finished_utc=future),
                   dict(finished_utc='2000-01-01T00:00:00+00:00')]
        for change in changes:
            with self.subTest(change=change):
                self.write_record({**original, **change})
                self.assert_exit(self.cli('verify'), 1)
        for key in ('started_utc', 'finished_utc', 'command_sha256', 'source_sha256',
                    'index_sha256', 'index_unchanged', 'index_matches_worktree'):
            with self.subTest(missing=key):
                record = original.copy()
                del record[key]
                self.write_record(record)
                self.assert_exit(self.cli('verify'), 1)

    def test_outside_traversal_wrong_directory_and_extension_rejected(self):
        outside = self.scratch / 'outside.json'
        outside.write_text('untouched', encoding='utf-8')
        paths = [outside, '../outside.json', self.scratch / 'project-sibling/check.json',
                 '.codex/harness-state/verification/../../escape.json',
                 '.codex/harness-state/verification-other/check.json',
                 'source.txt', '.codex/harness-state/verification/check.txt']
        for path in paths:
            for action in ('run', 'verify'):
                with self.subTest(path=str(path), action=action):
                    self.assert_exit(self.cli(action, evidence=path,
                                              argv=CHECK if action == 'run' else None), 2)
                    self.assertFalse(self.marker.exists())
        self.assertEqual(outside.read_text(), 'untouched')
        self.assertEqual(self.source.read_text(), 'original\n')

    def test_non_git_project_and_nested_git_directory_rejected(self):
        non_git = self.scratch / 'not-a-repository'
        nested = self.root / 'nested'
        non_git.mkdir()
        nested.mkdir()
        for project in (non_git, nested):
            with self.subTest(project=project):
                self.assert_exit(self.cli('run', project=project, argv=CHECK), 2)
                result = self.cli('verify', project=project)
                self.assertNotEqual(result.returncode, 0, result.stdout + result.stderr)
                self.assertNotIn('[OK]', result.stdout)
                self.assertFalse((project / '.codex/harness-state/executions.txt').exists())

    def test_secret_like_sources_fail_closed_without_contents(self):
        sentinel = 'SYNTHETIC_SECRET_DO_NOT_ECHO_51'
        for name in ('.env', '.env.production', 'id_rsa', 'id_ed25519',
                     'private.pem', 'private.key'):
            with self.subTest(name=name):
                path = self.root / name
                path.write_text(sentinel, encoding='utf-8')
                try:
                    result = self.cli('run', argv=CHECK)
                    self.assert_exit(result, 2)
                    self.assertNotIn(sentinel, result.stdout + result.stderr)
                    self.assertFalse(self.marker.exists())
                finally:
                    path.unlink()

    def test_environment_templates_are_safe_fingerprint_inputs(self):
        for name in ('.env.example', '.env.sample', '.env.template'):
            (self.root / name).write_text('VALUE=PLACEHOLDER\n', encoding='utf-8')
        self.run_ok()
        self.assert_exit(self.cli('verify'), 0)

    def test_symlink_source_is_rejected(self):
        outside = self.scratch / 'outside-source.txt'
        outside.write_text('outside fixture', encoding='utf-8')
        self.make_symlink(self.root / 'linked.txt', outside)
        self.assert_exit(self.cli('run', argv=CHECK), 2)
        self.assertFalse(self.marker.exists())

    def test_symlink_evidence_file_is_rejected_for_run_and_verify(self):
        self.run_ok()
        outside = self.scratch / 'outside-record.json'
        original = self.record_path.read_bytes()
        outside.write_bytes(original)
        self.record_path.unlink()
        self.make_symlink(self.record_path, outside)
        self.assert_exit(self.cli('verify'), 2)
        self.assert_exit(self.cli('run', argv=CHECK), 2)
        self.assertEqual(outside.read_bytes(), original)
        self.assertEqual(self.marker.read_text(), 'run\n')

    def test_symlink_evidence_directory_is_rejected(self):
        outside = self.scratch / 'outside-records'
        outside.mkdir()
        parent = self.root / '.codex/harness-state'
        parent.mkdir(parents=True)
        self.make_symlink(parent / 'verification', outside, directory=True)
        self.assert_exit(self.cli('run', argv=CHECK), 2)
        self.assert_exit(self.cli('verify'), 2)
        self.assertFalse(self.marker.exists())
        self.assertEqual(list(outside.iterdir()), [])

    @unittest.skipUnless(os.name == 'nt', 'Windows junction boundary')
    def test_junction_evidence_directory_is_rejected(self):
        outside = self.scratch / 'junction-target'
        outside.mkdir()
        link = self.root / '.codex/harness-state/verification'
        link.parent.mkdir(parents=True)
        result = subprocess.run(['cmd', '/d', '/c', 'mklink', '/J', str(link), str(outside)],
                                capture_output=True, text=True, timeout=20, env=self.env)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.addCleanup(os.rmdir, link)
        self.assert_exit(self.cli('run', argv=CHECK), 2)
        self.assert_exit(self.cli('verify'), 2)
        self.assertFalse(self.marker.exists())
        self.assertEqual(list(outside.iterdir()), [])

    def test_hardlinked_source_is_rejected(self):
        outside = self.scratch / 'hardlink-source.txt'
        outside.write_text('outside fixture', encoding='utf-8')
        os.link(outside, self.root / 'hardlinked.txt')
        self.assert_exit(self.cli('run', argv=CHECK), 2)
        self.assertFalse(self.marker.exists())

    def test_hardlinked_evidence_does_not_overwrite_outside_file(self):
        outside = self.scratch / 'hardlink-record.json'
        outside.write_text('outside fixture must stay unchanged', encoding='utf-8')
        self.record_path.parent.mkdir(parents=True)
        os.link(outside, self.record_path)
        result = self.cli('run', argv=CHECK)
        self.assertEqual(outside.read_text(), 'outside fixture must stay unchanged')
        self.assert_exit(result, 2)
        self.assertFalse(self.marker.exists())


if __name__ == '__main__':
    unittest.main(verbosity=2)
