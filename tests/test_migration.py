"""Migration contract tests. Every invocation targets an isolated tempfile fixture.

Run: python -B tests/test_migration.py -v
Set MIGRATION_POWERSHELL=powershell to also exercise Windows PowerShell 5.1.
Set MIGRATION_TEST_REPOSITORY_SOURCES=0 for fixtures only while main supplies dependencies.
No production migration, shared test entrypoint, backup, or external service is used.
"""
import hashlib
import json
import os
import re
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import tomllib
import unittest


REPO = Path(__file__).resolve().parents[1]
SCRIPT = REPO / "scripts/migrate-project-harness.ps1"
SHELL = shutil.which(os.environ.get("MIGRATION_POWERSHELL", "pwsh"))
START = "<!-- production-harness-v2:start -->"
END = "<!-- production-harness-v2:end -->"
ROLES = ("luna-qa", "terra-worker", "luna-verifier", "sol-planner")
RUNTIME = (
    ".codex/hooks/harness-hook.ps1", ".codex/hooks/authorize-command.ps1", ".codex/hooks/validate-report.ps1",
    ".codex/hooks/invoke-authorized.ps1",
    "scripts/goal-state.ps1", "scripts/validate-config.py", "templates/goal-contract.md",
    "scripts/runtime-inspect.py", "scripts/verification-evidence.py",
    "scripts/branch-finish-check.ps1", "scripts/scope-check.ps1", "scripts/evaluate-efficiency.py",
    "templates/context-capsule.md", "templates/release-authorization.json", "templates/verification-evidence.json",
    "scripts/stop-check.ps1", "templates/branch-finish.md", "templates/deployment-checklist.md", "templates/database-checklist.md", "templates/server-inspection.md",
) + tuple(f".codex/agents/{role}.toml" for role in ROLES)
POLICIES = (
    "docs/route-policy.md", "docs/model-routing-policy.md", "docs/capability-policy.md",
    "docs/skill-routing-policy.md", "docs/cost-efficiency-policy.md", "docs/autonomous-goal-workflow.md",
    "docs/context-memory.md", "docs/context-compression-policy.md",
    "docs/parent-child-execution.md", "docs/reporting-policy.md",
    "docs/developer-efficiency-mode.md", "docs/verification-and-guardrails.md",
    "docs/hook-tuning.md", "docs/install-hooks-upgrade.md",
    "docs/git-network-policy.md", "docs/runtime-readiness-policy.md",
    "templates/task-brief.md", "templates/verification-report.md",
    "templates/child-task.md", "templates/child-report.md", "templates/handoff.md",
    "templates/project-agents.md", "templates/feature-plan.md", "scripts/health-check.ps1",
)
REQUIRED_SOURCES = RUNTIME + POLICIES + (
    ".codex/config.toml", ".codex/hooks.json", "templates/project-profile.md",
)


def hook(event, script="harness-hook"):
    suffix = f" -Event {event}" if script == "harness-hook" else ""
    return {
        "type": "command",
        "command": f"pwsh -NoProfile -ExecutionPolicy Bypass -File .codex/hooks/{script}.ps1{suffix}",
        "commandWindows": f"powershell -NoProfile -ExecutionPolicy Bypass -File .codex/hooks/{script}.ps1{suffix}",
    }


@unittest.skipUnless(SHELL, "PowerShell executable is required")
class MigrationTests(unittest.TestCase):
    def setUp(self):
        self.fixture = Path(tempfile.mkdtemp(prefix="harness-migration-isolated-")).resolve()
        self.source = self.fixture / "source"
        self.project = self.fixture / "项目 with spaces"
        self.source.mkdir()
        self.project.mkdir()
        self.put(self.source, "scripts/migrate-project-harness.ps1", SCRIPT.read_bytes())
        self.put(self.source, ".codex/config.toml", '# Never import this root model\nmodel = "source-only"\n[agents]\nmax_threads = 4\nmax_depth = 1\n')
        self.new_hooks = {"version": "1", "hooks": {
            event: [hook(event)] for event in ("SessionStart", "PreToolUse", "PreCompact", "PostCompact")
        }}
        self.put_json(self.source, ".codex/hooks.json", self.new_hooks)
        self.put(self.source, "templates/project-agents.md", "# Managed template\n\n```text\nCurrent root owns delivery. No fixed role route. 中文。\n```\n")
        self.put(self.source, "templates/project-profile.md", "# Profile\nProject:\nRepository Root:\nCommands:\n")
        for relative in RUNTIME + POLICIES:
            if not (self.source / relative).exists():
                self.put(self.source, relative, f"# Current owned fixture: {relative}\n")
        self.env = dict(os.environ)
        self.env["PATH"] = str(Path(sys.executable).parent) + os.pathsep + self.env.get("PATH", "")

    def inside(self, path):
        absolute = Path(path).resolve()
        if absolute == self.fixture or not absolute.is_relative_to(self.fixture):
            raise AssertionError(f"refusing operation outside fixture children: {absolute}")
        return absolute

    def tearDown(self):
        # Resolve and check each deletion root. Never rmtree a computed production path.
        for child in self.fixture.iterdir():
            self.inside(child)
            for path in child.rglob("*") if child.is_dir() and not child.is_symlink() else ():
                self.inside(path)
            if child.is_symlink():
                child.unlink()
            elif child.is_dir():
                shutil.rmtree(child, onerror=self.remove_readonly)
            else:
                child.unlink()
        self.fixture.rmdir()  # Non-recursive, only after verified children are gone.

    def remove_readonly(self, function, path, error):
        self.inside(path)
        os.chmod(path, 0o700)
        function(path)

    def put(self, base, relative, content):
        path = self.inside(base / relative)
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(content.encode("utf-8") if isinstance(content, str) else content)
        return path

    def put_json(self, base, relative, content):
        return self.put(base, relative, json.dumps(content, ensure_ascii=False, indent=2) + "\n")

    def snapshot(self, base=None):
        base = base or self.project
        return {str(path.relative_to(base)): ("dir" if path.is_dir() else path.read_bytes())
                for path in base.rglob("*")}

    def run_migration(self, *flags, expected=0, project=None):
        destination = self.inside(project or self.project)
        script = self.inside(self.source / "scripts/migrate-project-harness.ps1")
        self.assertNotEqual(destination, REPO)
        proc = subprocess.run([SHELL, "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", str(script),
                               "-ProjectPath", str(destination), *flags],
                              cwd=self.source, env=self.env, capture_output=True, timeout=60)
        output = (proc.stdout + proc.stderr).decode("utf-8", errors="replace")
        self.assertEqual(proc.returncode, expected, output)
        return output

    def blocked(self, *flags):
        before = self.snapshot()
        output = self.run_migration("-Apply", *flags, expected=2)
        self.assertIn("BLOCKED", output)
        self.assertEqual(before, self.snapshot(), "preflight blocker wrote project data")
        return output

    def git(self, base, *args):
        self.inside(base)
        empty_hooks = self.fixture / "empty-hooks"
        empty_hooks.mkdir(exist_ok=True)
        proc = subprocess.run(["git", "-c", f"core.hooksPath={empty_hooks}", "-c", "core.autocrlf=false",
                               "-c", "commit.gpgsign=false", "-c", "user.name=Fixture",
                               "-c", "user.email=fixture@example.invalid", "-C", str(base), *args],
                              capture_output=True, timeout=30)
        self.assertEqual(proc.returncode, 0, proc.stderr.decode(errors="replace"))
        return proc.stdout

    def history(self, relative, old, new):
        self.git(self.source, "init", "--template=")
        self.put(self.source, relative, old)
        self.git(self.source, "add", "--", relative)
        self.git(self.source, "commit", "-m", "Known owned fixture revision")
        self.put(self.source, relative, new)

    def test_default_and_explicit_dry_run_are_zero_write(self):
        before = self.snapshot()
        source_before = self.snapshot(self.source)
        self.assertIn("DRY RUN", self.run_migration())
        self.run_migration("-DryRun", "-ReplaceConfig", "-ReplaceHooks", "-ArchiveLegacyHarness")
        self.assertEqual(before, self.snapshot())
        self.assertEqual(source_before, self.snapshot(self.source))
        self.blocked("-DryRun")

    def test_fresh_apply_has_no_root_model_installs_all_and_is_idempotent(self):
        self.run_migration("-Apply")
        config = tomllib.loads((self.project / ".codex/config.toml").read_text("utf-8"))
        self.assertEqual(config, {"agents": {"max_threads": 4, "max_depth": 1}})
        for relative in RUNTIME + POLICIES:
            self.assertEqual((self.project / relative).read_bytes(), (self.source / relative).read_bytes())
        manifest = json.loads((self.project / ".codex/harness-owned.json").read_bytes())
        self.assertEqual(manifest, {"version": 1, "files": {
            relative: hashlib.sha256((self.source / relative).read_bytes()).hexdigest()
            for relative in RUNTIME + POLICIES}})
        self.assertFalse((self.project / ".git").exists())
        self.assertFalse(any("backup" in str(path).lower() for path in self.project.rglob("*")))
        first = self.snapshot()
        mtimes = {p: p.stat().st_mtime_ns for p in self.project.rglob("*")}
        self.run_migration("-Apply")
        self.assertEqual(first, self.snapshot())
        self.assertEqual(mtimes, {p: p.stat().st_mtime_ns for p in self.project.rglob("*")})

    def test_only_install_closure_is_copied_and_unknown_content_is_preserved(self):
        unknown = ("docs/historical-verification-report.md", "tests/test_old_workflow.py",
                   "scripts/retired-adapter.ps1", ".codex/auth.json", ".codex/private-settings.toml")
        for relative in unknown:
            self.put(self.source, relative, "source-only fixture; never distribute\n")
        self.put(self.project, "docs/project-architecture.md", "project-owned\n")
        self.put(self.project, "tasks/history.md", "historical evidence\n")
        self.run_migration("-Apply")
        for relative in unknown:
            self.assertFalse((self.project / relative).exists(), relative)
        self.assertEqual((self.project / "docs/project-architecture.md").read_text(), "project-owned\n")
        self.assertEqual((self.project / "tasks/history.md").read_text(), "historical evidence\n")

    def test_upgrade_backfills_missing_policies_and_runtime_without_backups(self):
        self.run_migration("-Apply")
        # Simulate the old installer: no policies and no newly introduced runtime.
        absent = POLICIES + (".codex/hooks/invoke-authorized.ps1", "scripts/runtime-inspect.py",
                             "scripts/verification-evidence.py", "templates/verification-evidence.json")
        manifest = json.loads((self.project / ".codex/harness-owned.json").read_bytes())
        for relative in absent:
            self.inside(self.project / relative).unlink()
            manifest["files"].pop(relative)
        self.put_json(self.project, ".codex/harness-owned.json", manifest)
        before = self.snapshot()
        self.run_migration("-DryRun")
        self.assertEqual(before, self.snapshot())
        self.run_migration("-Apply")
        for relative in RUNTIME + POLICIES:
            self.assertEqual((self.project / relative).read_bytes(), (self.source / relative).read_bytes())
        self.assertFalse(any("backup" in str(path).lower() for path in self.project.rglob("*")))

    def test_policy_upgrade_requires_permission_preserves_custom_edits_and_is_idempotent(self):
        relative = "docs/git-network-policy.md"
        self.run_migration("-Apply")
        self.put(self.source, relative, "# New network policy fixture\n")
        self.blocked()
        before = self.snapshot()
        self.run_migration("-DryRun", "-ArchiveLegacyHarness")
        self.assertEqual(before, self.snapshot())
        self.run_migration("-Apply", "-ArchiveLegacyHarness")
        first = self.snapshot()
        self.run_migration("-Apply")
        self.assertEqual(first, self.snapshot())
        self.put(self.project, relative, "# Customized project network policy\n")
        self.blocked()
        self.blocked("-ArchiveLegacyHarness")

    def test_config_preserves_model_provider_profiles_auth_mcp_and_unknown_values(self):
        text = '''# 项目配置\r
model = "human-model" # Human owns this\r
model_reasoning_effort = "medium"\r
model_provider = "company"\r
profile = "daily"\r
auth_mode = "custom"\r
odd = { nested = ["a", "b"] }\r
instructions = """\r
[agents]\r
max_threads = 999\r
"""\r
[model_providers.company]\r
base_url = "https://example.invalid/v1"\r
env_key = "FIXTURE_ONLY"\r
[profiles.daily]\r
model = "profile-model"\r
[mcp_servers.local]\r
command = "fixture-server"\r
args = ["中文", "--local"]\r
[agents]\r
max_threads = 2 # preserve thread comment\r
max_depth = 3\r
custom = "keep"\r
[agents.project_reviewer]\r
config_file = "agents/project.toml"\r
'''
        self.put(self.project, ".codex/config.toml", text.encode("utf-8-sig"))
        self.put(self.project, ".codex/auth.json", '{"fixture":"untouched-not-a-secret"}')
        self.blocked()
        self.run_migration("-Apply", "-ReplaceConfig")
        updated = (self.project / ".codex/config.toml").read_bytes()
        expected = tomllib.loads(text)
        expected["agents"].update(max_threads=4, max_depth=1)
        self.assertEqual(tomllib.loads(updated.decode("utf-8")), expected)
        self.assertIn(b'# preserve thread comment\r\n', updated)
        self.assertIn(b'max_threads = 999\r\n', updated)
        self.assertFalse(updated.startswith(b"\xef\xbb\xbf"))
        self.assertEqual((self.project / ".codex/auth.json").read_text(), '{"fixture":"untouched-not-a-secret"}')

    def test_missing_managed_config_fields_are_added_without_replace(self):
        self.put(self.project, ".codex/config.toml", '# preserve\nmodel="human"\n[agents.custom]\ndescription="mine"\n')
        self.run_migration("-Apply")
        result = tomllib.loads((self.project / ".codex/config.toml").read_text())
        self.assertEqual(result["model"], "human")
        self.assertEqual(result["agents"], {"max_threads": 4, "max_depth": 1, "custom": {"description": "mine"}})

    def test_source_role_registrations_merge_only_known_fields(self):
        self.put(self.source, ".codex/config.toml", '[agents]\nmax_threads=4\nmax_depth=1\n[agents.sol_planner]\ndescription="current"\nconfig_file="agents/sol-planner.toml"\n')
        self.put(self.project, ".codex/config.toml", 'model="human"\n[agents.sol_planner]\ndescription="old"\nproject_setting="keep"\n')
        self.blocked()
        self.run_migration("-Apply", "-ReplaceConfig")
        role = tomllib.loads((self.project / ".codex/config.toml").read_text())["agents"]["sol_planner"]
        self.assertEqual(role, {"description": "current", "config_file": "agents/sol-planner.toml", "project_setting": "keep"})

    def test_ambiguous_or_invalid_config_blocks_without_printing_values(self):
        for text in ('[agents]\nmax_threads=2\nmax_threads=3\n',
                     'agents = { max_threads=2, max_depth=1 }\n',
                     'agents.max_threads = 2\n',
                     'model = "FIXTURE_PRIVATE_SENTINEL\n',
                     '[agents]\nmax_threads=true\n'):
            with self.subTest(text=text):
                self.put(self.project, ".codex/config.toml", text)
                output = self.blocked("-ReplaceConfig")
                self.assertNotIn("FIXTURE_PRIVATE_SENTINEL", output)

    def test_unknown_multiline_arrays_and_quoted_tables_are_preserved(self):
        text = '''model = 'human'
extra = [
  {text = "a#b"}, # comment
  {text = '[agents]'},
]
["agents"] # header comment
"max_threads" = 2 # retain
max_depth = 1
[[unrelated]]
value = "one"
[[unrelated]]
value = "two"
'''
        self.put(self.project, ".codex/config.toml", text)
        self.run_migration("-Apply", "-ReplaceConfig")
        expected = tomllib.loads(text)
        expected["agents"]["max_threads"] = 4
        actual = (self.project / ".codex/config.toml").read_text()
        self.assertEqual(tomllib.loads(actual), expected)
        self.assertIn('"max_threads" = 4 # retain', actual)

    def test_hooks_preserve_custom_entries_metadata_nested_and_unknown_events(self):
        custom = {"type": "command", "command": "echo project-only", "timeout": 12}
        original = {"version": "1", "project_meta": {"keep": True}, "hooks": {
            "PreToolUse": [{"matcher": "Shell", "hooks": [hook("PreToolUse"), custom]}],
            "Stop": [custom], "OldEvent": [hook("OldEvent")],
        }}
        self.put_json(self.project, ".codex/hooks.json", original)
        self.blocked()
        self.run_migration("-Apply", "-ReplaceHooks")
        merged = json.loads((self.project / ".codex/hooks.json").read_bytes())
        self.assertEqual(merged["project_meta"], original["project_meta"])
        self.assertEqual(merged["hooks"]["Stop"], [custom])
        self.assertNotIn("OldEvent", merged["hooks"])
        self.assertEqual(merged["hooks"]["PreToolUse"][0], {"matcher": "Shell", "hooks": [custom]})
        self.assertEqual(merged["hooks"]["PreToolUse"][1:], self.new_hooks["hooks"]["PreToolUse"])
        self.run_migration("-Apply")

    def test_custom_only_hooks_do_not_need_replace(self):
        custom = {"type": "command", "command": "echo mine"}
        self.put_json(self.project, ".codex/hooks.json", {"version": "1", "hooks": {"PreToolUse": [custom]}})
        self.run_migration("-Apply")
        merged = json.loads((self.project / ".codex/hooks.json").read_bytes())
        self.assertEqual(merged["hooks"]["PreToolUse"][0], custom)

    def test_hooks_ambiguous_commands_duplicate_keys_or_versions_block(self):
        for command in (
            hook("PreToolUse")["command"] + "; echo project-action",
            'pwsh -File D:/other/.codex/hooks/harness-hook.ps1 -Event PreToolUse',
            'echo .codex/hooks/authorize-command.ps1',
        ):
            with self.subTest(command=command):
                self.put_json(self.project, ".codex/hooks.json", {"version": "1", "hooks": {
                    "PreToolUse": [{"type": "command", "command": command}]}})
                self.blocked("-ReplaceHooks")
        for value in ('{"version":"1","hooks":{},"hooks":{}}', '{"version":"2","hooks":{}}'):
            self.put(self.project, ".codex/hooks.json", value)
            self.blocked("-ReplaceHooks")

    def test_managed_markers_preserve_both_convention_sides_and_utf8(self):
        before = "# Project rules\r\n中文 → — preserve.\r\n\r\n"
        after = "\r\n# Final project rules\r\nKeep tail exactly.  \r\n"
        self.put(self.project, "AGENTS.md", (before + START + "\nobsolete rules\n" + END + after).encode("utf-8-sig"))
        profile = b"\xef\xbb\xbf# existing profile\r\nunchanged  \r\n"
        self.put(self.project, "docs/project-profile.md", profile)
        self.run_migration("-Apply")
        result = (self.project / "AGENTS.md").read_bytes()
        self.assertTrue(result.startswith(before.encode("utf-8")))
        self.assertTrue(result.endswith(after.encode("utf-8")))
        self.assertNotIn(b"obsolete rules", result)
        self.assertEqual((self.project / "docs/project-profile.md").read_bytes(), profile)

    def test_malformed_and_duplicate_markers_block(self):
        for text in (START, END + START, START + END + START + END, '<!-- production-harness-v9:start -->'):
            self.put(self.project, "AGENTS.md", text)
            self.blocked("-ReplaceLegacyAgents")

    def test_known_addendum_preserves_entire_directory_tail(self):
        prefix = "# Production Harness Project Addendum\n\nKnown old workflow.\n\n"
        tail = "# Directory guide\r\n中文 conventions.\r\n\r\n## Commands\r\nKeep exact tail.  \r\n"
        self.history("AGENTS.md", prefix, "# New source root\n")
        self.put(self.project, "AGENTS.md", prefix + tail)
        self.blocked()
        self.run_migration("-Apply", "-ReplaceLegacyAgents")
        result = (self.project / "AGENTS.md").read_bytes()
        self.assertTrue(result.endswith(tail.encode("utf-8")))
        self.assertNotIn(b"Known old workflow", result)

    def test_known_v21_prefix_preserves_conventions_and_tail_after_block(self):
        prefix = "# AGENTS.md - legacy workflow and project rules\n\n## AI Workflow Operating System\nOld route.\n\n## Production Harness v2.1\nOld packet.\n\n"
        self.history("AGENTS.md", prefix, "# Current root\n")
        conventions = "# Project Conventions for fixture\nKeep 中文 convention.\n\n"
        tail = "\n# Tail project rule\nDo not lose this.\n"
        self.put(self.project, "AGENTS.md", prefix + conventions + START + "\nold managed\n" + END + tail)
        self.run_migration("-Apply", "-ReplaceLegacyAgents")
        result = (self.project / "AGENTS.md").read_text("utf-8")
        self.assertTrue(result.startswith(conventions))
        self.assertTrue(result.endswith(tail))
        self.assertNotIn("Old route", result)
        self.assertNotIn("old managed", result)

    def test_unrecognized_legacy_heading_never_discards_project_rules(self):
        self.put(self.project, "AGENTS.md", "# Production Harness Starter Instructions\nPrivate project conventions, not proven owned.\n")
        self.blocked("-ReplaceLegacyAgents")

    def test_owned_legacy_policy_requires_switch_and_overwrites_without_backup(self):
        relative = "docs/route-policy.md"
        old, new = "# Known owned policy\nold active rule\n", "# Current policy\nroot owns delivery\n"
        self.history(relative, old, new)
        self.put(self.project, relative, old)
        self.put(self.project, ".codex/legacy-harness-backup/historical/file.txt", "user history")
        self.put(self.project, "docs/project-architecture.md", "project architecture")
        self.blocked()
        self.run_migration("-Apply", "-ArchiveLegacyHarness")
        self.assertEqual((self.project / relative).read_text(), new)
        self.assertEqual((self.project / ".codex/legacy-harness-backup/historical/file.txt").read_text(), "user history")
        self.assertEqual((self.project / "docs/project-architecture.md").read_text(), "project architecture")
        self.assertEqual(len(list((self.project / ".codex/legacy-harness-backup").rglob("*"))), 2)

    def test_same_name_project_policy_blocks_without_overwriting_with_or_without_switch(self):
        self.put(self.source, "docs/route-policy.md", "# Source owned route\n")
        self.put(self.project, "docs/route-policy.md", "# Project business route policy\n")
        self.blocked("-ArchiveLegacyHarness")
        self.blocked()
        self.assertEqual((self.project / "docs/route-policy.md").read_text(), "# Project business route policy\n")

    def test_unknown_runtime_collision_blocks_even_with_all_switches(self):
        self.put(self.project, "scripts/goal-state.ps1", "# user unrelated same-name script\n")
        self.blocked("-ReplaceConfig", "-ReplaceHooks", "-ReplaceLegacyAgents", "-ArchiveLegacyHarness")

    def test_manifest_allows_upgrade_but_blocks_locally_modified_owned_file(self):
        self.run_migration("-Apply")
        self.put(self.source, ".codex/hooks/harness-hook.ps1", "# next trusted source hook\n")
        self.blocked()
        self.run_migration("-Apply", "-ReplaceHooks")
        self.put(self.project, ".codex/hooks/harness-hook.ps1", "# user custom hook\n")
        self.blocked("-ReplaceHooks")

    def test_every_required_source_blocks_before_any_write_when_missing(self):
        for relative in REQUIRED_SOURCES:
            with self.subTest(relative=relative):
                path = self.inside(self.source / relative)
                data = path.read_bytes()
                path.unlink()
                try:
                    self.assertIn("required source is missing", self.blocked())
                finally:
                    self.put(self.source, relative, data)

    def test_existing_installation_does_not_mask_missing_source_dependencies(self):
        self.run_migration("-Apply")
        for relative in ("docs/runtime-readiness-policy.md", "templates/project-profile.md",
                         "scripts/scope-check.ps1", "scripts/evaluate-efficiency.py"):
            with self.subTest(relative=relative):
                path = self.inside(self.source / relative)
                data = path.read_bytes()
                path.unlink()
                try:
                    self.assertIn("required source is missing", self.blocked("-ArchiveLegacyHarness"))
                    before = self.snapshot()
                    self.run_migration("-DryRun", expected=2)
                    self.assertEqual(before, self.snapshot())
                finally:
                    self.put(self.source, relative, data)

    def test_invalid_policy_source_and_policy_directory_block_with_zero_writes(self):
        relative = "docs/runtime-readiness-policy.md"
        original = (self.source / relative).read_bytes()
        self.put(self.source, relative, b"\xffinvalid")
        self.blocked()
        self.put(self.source, relative, original)
        (self.project / relative).mkdir(parents=True)
        self.blocked()

    def test_invalid_utf8_and_directory_collisions_block(self):
        self.put(self.project, "AGENTS.md", b"\xff\xfeinvalid")
        self.blocked()
        self.put(self.project, "AGENTS.md", "# Project\n")
        (self.project / ".codex/config.toml").mkdir(parents=True)
        self.blocked("-ReplaceConfig")

    def test_git_exclude_is_preflighted_preserved_and_no_backup_entry_added(self):
        self.git(self.project, "init", "--template=")
        self.put(self.project, ".git/info/exclude", "# 我的规则\r\nproject-cache/\r\n")
        before = self.snapshot()
        self.run_migration()
        self.assertEqual(before, self.snapshot())
        self.run_migration("-Apply")
        exclude = (self.project / ".git/info/exclude").read_bytes()
        self.assertTrue(exclude.startswith("# 我的规则\r\nproject-cache/\r\n".encode("utf-8")))
        self.assertIn(b".codex/harness-state/", exclude)
        self.assertNotIn(b"backup", exclude)

    def test_invalid_git_exclude_blocks_all_other_writes(self):
        self.git(self.project, "init", "--template=")
        self.put(self.project, ".git/info/exclude", b"\xff")
        self.blocked()

    def test_git_worktree_uses_verified_common_metadata(self):
        repo = self.fixture / "git-owner"
        repo.mkdir()
        self.git(repo, "init", "--template=")
        self.put(repo, "README.md", "fixture")
        self.git(repo, "add", "README.md")
        self.git(repo, "commit", "-m", "fixture")
        worktree = self.fixture / "worktree"
        self.git(repo, "worktree", "add", "-b", "fixture-worktree", str(worktree))
        self.run_migration("-Apply", project=worktree)
        self.assertTrue((worktree / ".git").is_file())
        self.assertIn(b".codex/harness-state/", (repo / ".git/info/exclude").read_bytes())

    def test_reparse_or_symlink_destination_never_writes_sibling(self):
        sibling = self.fixture / "sibling"
        sibling.mkdir()
        link = self.project / ".codex"
        try:
            link.symlink_to(sibling, target_is_directory=True)
        except OSError:
            if os.name != "nt":
                self.skipTest("symlink creation unavailable")
            # Native PowerShell creates only this fixture junction; no cross-shell deletion.
            command = f"New-Item -ItemType Junction -Path '{link}' -Target '{sibling}' | Out-Null"
            proc = subprocess.run([SHELL, "-NoProfile", "-Command", command], capture_output=True)
            self.assertEqual(proc.returncode, 0, proc.stderr)
        try:
            self.blocked()
            self.assertEqual(list(sibling.iterdir()), [])
        finally:
            self.inside(link)
            if link.is_symlink():
                link.unlink()
            else:
                link.rmdir()  # Remove only the verified fixture junction, not its target.

    def test_hardlinked_target_blocks(self):
        sibling = self.put(self.fixture, "sibling-file", "# Project rules\n")
        os.link(sibling, self.project / "AGENTS.md")
        self.blocked()
        self.assertEqual(sibling.read_text(), "# Project rules\n")

    def test_unknown_manifest_path_cannot_authorize_history_cleanup(self):
        self.put_json(self.project, ".codex/harness-owned.json", {"version": 1, "files": {
            "../outside": hashlib.sha256(b"fixture").hexdigest()}})
        self.blocked("-ArchiveLegacyHarness")

    def test_boolean_manifest_version_is_not_an_integer_version(self):
        self.put_json(self.project, ".codex/harness-owned.json", {"version": True, "files": {}})
        self.blocked()

    @unittest.skipUnless(os.environ.get("MIGRATION_TEST_REPOSITORY_SOURCES", "1") == "1",
                         "repository-source integration explicitly disabled; rerun without the override when main dependencies are ready")
    def test_current_repository_sources_can_be_installed_in_fixture_only(self):
        missing = [relative for relative in REQUIRED_SOURCES if not (REPO / relative).is_file()]
        self.assertFalse(missing, f"main-thread sources not ready: {missing}")
        for relative in REQUIRED_SOURCES:
            path = REPO / relative
            self.assertTrue(path.is_file(), f"main-thread source not ready: {relative}")
            self.put(self.source, relative, path.read_bytes())
        self.run_migration("-Apply")
        config = tomllib.loads((self.project / ".codex/config.toml").read_text())
        self.assertNotIn("model", config)
        self.assertEqual(config["agents"]["max_threads"], 4)
        self.assertEqual(config["agents"]["max_depth"], 1)
        self.assertTrue((self.project / ".codex/agents/sol-planner.toml").is_file())
        self.assertTrue((self.project / "templates/release-authorization.json").is_file())
        for relative in RUNTIME + POLICIES:
            self.assertEqual((self.project / relative).read_bytes(), (REPO / relative).read_bytes())
            if relative.startswith('templates/'):
                references = re.findall(r'scripts/[A-Za-z0-9._-]+\.(?:ps1|py)', (self.project/relative).read_text(encoding='utf-8-sig'))
                for dependency in references:
                    self.assertTrue((self.project/dependency).is_file(), f'{relative} references missing installed dependency {dependency}')
        installed = self.snapshot()
        self.run_migration("-Apply")
        self.assertEqual(installed, self.snapshot())
        # Exercise installed real dependencies, not just copied filenames.
        env = {k:v for k,v in os.environ.items() if k.lower() != 'psmodulepath'}
        for script, args in [('scripts/health-check.ps1', []),
                             ('.codex/hooks/harness-hook.ps1', ['-Event','SessionStart'])]:
            result = subprocess.run([SHELL,'-NoProfile','-ExecutionPolicy','Bypass','-File',str(self.project/script),*args],
                                    input='{}',capture_output=True,text=True,encoding='utf-8',errors='replace',
                                    env=env,cwd=self.project,timeout=30)
            self.assertEqual(result.returncode,0,result.stdout+result.stderr)
            self.assertTrue(result.stdout.strip())
        for invalid in ['{', '{}', '{"version":1,"files":{}}', '{"version":true,"files":{"../outside":"bad"}}']:
            self.put(self.project, '.codex/harness-owned.json', invalid)
            result = subprocess.run([SHELL,'-NoProfile','-ExecutionPolicy','Bypass','-File',str(self.project/'scripts/health-check.ps1')],
                                    capture_output=True,text=True,encoding='utf-8',errors='replace',env=env,cwd=self.project,timeout=30)
            self.assertNotEqual(result.returncode,0,result.stdout+result.stderr)


if __name__ == "__main__":
    unittest.main()
