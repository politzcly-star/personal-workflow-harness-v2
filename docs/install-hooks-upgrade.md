# Install, Hooks, And Upgrade

Use `scripts/migrate-project-harness.ps1` for adoption and in-place upgrades. The current Human/platform-selected root owns autonomous execution within the actual authorization boundary. S-levels describe risk and evidence, not a mandatory model or role route.

## Requirements And Preview

Run from the Harness checkout with PowerShell and **Python 3.11+ available as `python` on PATH**. Python's standard-library TOML parser validates configuration before any write; nothing is downloaded. Git history is optional ownership evidence for older copies. Without it, ambiguous legacy files block instead of being guessed.

Dry Run is the default; replacement switches alone never write:

```powershell
.\scripts\migrate-project-harness.ps1 -ProjectPath "D:\path\to\project"
# Optional explicit spelling:
.\scripts\migrate-project-harness.ps1 -ProjectPath "D:\path\to\project" -DryRun
```

Inspect the plan, then explicitly apply:

```powershell
.\scripts\migrate-project-harness.ps1 -ProjectPath "D:\path\to\project" -Apply
```

`-Apply -DryRun` is an error. The source checkout and target must be separate, non-nested directories.

Fresh installation and upgrades both install every missing file in the finite `RUNTIME` and `POLICIES` lists. Missing policies are required installation inputs, not optional legacy files. No replacement switch is needed to install a missing file. The source checkout must contain the complete `REQUIRED_SOURCES` set before even a preview can succeed, including the profile template when the project already has its own profile.

## Managed Merge, Not Whole-File Replacement

After reviewing the conflicts, authorize only the relevant replacements:

```powershell
.\scripts\migrate-project-harness.ps1 -ProjectPath "D:\path\to\project" -Apply -ReplaceConfig -ReplaceHooks -ReplaceLegacyAgents -ArchiveLegacyHarness
```

- **`-ReplaceConfig`** permits changes only to `agents.max_threads=4`, `agents.max_depth=1`, and the `description`/`config_file` registrations actually present in the source config for the four known roles below. It never copies the source root model or effort. Existing root model/effort, provider, auth settings, selected profile, profile tables, MCP servers, custom roles, unrelated fields, and comments are retained. Missing managed fields can be added without this switch. Role files themselves come from the current source; migration does not rewrite their role policies.
- **`-ReplaceHooks`** replaces recognized Harness hook entries and verified owned hook scripts, not the entire hook configuration. Non-Harness commands, their relative order, custom events, mixed matcher's non-Harness children, and unrelated top-level metadata survive. Old recognized Harness entries are replaced, not appended as an additional active version. Absolute paths, compound commands, mismatching platform commands, or custom metadata on Harness entries block for review rather than silently discarding project behavior.
- **`-ReplaceLegacyAgents`** authorizes removal of a recognized unmarked legacy prefix. Its content must match a current/historical source `AGENTS.md` or project-agents template, not just a familiar heading. A matching prefix before `# Directory guide` or `# Project Conventions for ...` is removed while the entire project tail survives, including rules after a managed block. If ownership cannot be proven, review and explicitly mark only the owned legacy span with the markers below before retrying. An arbitrary “Production Harness” heading never authorizes deleting project conventions.
- **`-ArchiveLegacyHarness`** is retained only as a compatibility name: explicitly **overwrite with the current source**, without archiving, moving, or deleting. It applies only to the script's finite `POLICIES` list of copied Harness policies/templates and `scripts/health-check.ps1`. A target is owned only when its content matches a source revision at that exact path (allowing BOM/CRLF differences), or an installed ownership hash matches. Unknown/customized same-name files block the entire preflight **with or without this switch** and remain untouched; a successful install must not silently substitute project-specific content for a required policy. Recognized outdated owned policies block until this switch is supplied. Current byte-identical files and missing files need no replacement permission.

Ordinary managed AGENTS updates replace exactly one complete block and preserve text on both sides:

```html
<!-- production-harness-v2:start -->
Harness-owned instructions only
<!-- production-harness-v2:end -->
```

Duplicate, reversed, unknown, or incomplete markers block. AGENTS/config are decoded as strict UTF-8; rewritten text is BOM-less UTF-8. Non-ASCII project rules and outside-block line endings are preserved. Existing `docs/project-profile.md` is preserved byte-for-byte and is created from the current template only when missing.

## Preflight And Ownership

All intended content is built and validated in memory before creating directories or writing files. Every required source is checked for existence, safe file type and UTF-8, regardless of target state. Config/hooks/ownership documents are parsed before merge; runtime file behavior and template schemas still require their own checks. Malformed merged UTF-8/TOML/JSON, duplicate JSON keys, ambiguous ownership, missing required sources, unsafe links/junctions/hardlinks, incompatible target types, and unsupported managed config syntax are blockers. Managed TOML fields must use explicit tables and single-line scalar assignments; ambiguous inline/dotted managed tables are not rewritten. Unmanaged multi-line values remain unchanged.

The script rechecks observed source/target bytes and destination paths immediately before writes. A preflight blocker returns exit code `2` with **zero project writes**, even with `-Apply`. Do not run concurrent writers against the same migration target. This is not a cross-file filesystem transaction: an OS/disk failure after Apply begins may leave partial writes (exit `3`); inspect the target and rerun after repairing the failure. No rollback backup is made.

The target `.codex/harness-owned.json` stores only relative paths and SHA-256 hashes of installed owned files, **not old file content, credentials, or release authority**. Local edits that no longer match the recorded hash block overwriting. Unknown manifest paths never authorize arbitrary writes or cleanup.

No backup directory, archive copy, historical cleanup, broad directory scan for deletion, or global config edit is performed. Existing backup/history directories, tasks, audits, facts, architecture, unrelated scripts, and unknown paths stay untouched. An already-current installation is idempotent.

### Explicit legacy cleanup outside the migrator

If the Human separately requests removal of old workflows, inventory exact legacy adapters, route documents, template/script dependencies and backup paths first. Confirm ownership, preserve project facts/conventions and explicit Git/production contracts, check resolved paths and reject reparse points. Remove only the reviewed files after current installation checks pass; never use a broad Git clean or treat historical task/audit evidence as an old active workflow. Record removed paths and hashes, not old file contents. The migration switches themselves do not authorize this cleanup.

The existing project profile is intentionally preserved by migration. When it contains old model routes or points at a legacy source directory, update only those workflow/authority sections under explicit project-maintenance authority. Verify new-session root AGENTS.md and any alternate tool entries lead to the same current workflow. Existing running threads must receive a handoff and reread; files alone do not refresh already-loaded context.

## Installed Runtime

- `.codex/config.toml`: managed concurrency ceiling of four threads, depth one; root model/effort remain Human/platform-selected.
- `.codex/agents/luna-qa.toml`, `terra-worker.toml`, `luna-verifier.toml`, and `sol-planner.toml`: source role files. Only known registrations actually present in source config are merged. Copying these files does not register a runtime role or prove that a provider supports its model.
- `.codex/hooks.json`, `.codex/hooks/harness-hook.ps1`, `.codex/hooks/authorize-command.ps1`, `.codex/hooks/invoke-authorized.ps1`, and `.codex/hooks/validate-report.ps1`: source wiring and authorization/report helpers. Hook commands use project-relative paths, not the source checkout's absolute path. Installing the invocation helper does not invent hook wiring or authorization transport.
- `scripts/goal-state.ps1`, `scripts/validate-config.py`, `scripts/runtime-inspect.py`, and `scripts/verification-evidence.py`.
- `scripts/branch-finish-check.ps1` and its `scripts/scope-check.ps1` dependency for branch/evidence checks; `scripts/stop-check.ps1` for completion reports; `scripts/evaluate-efficiency.py` referenced by the cost policy; `scripts/health-check.ps1` for installed-target checks.
- `templates/goal-contract.md`, `templates/context-capsule.md`, `templates/release-authorization.json`, `templates/verification-evidence.json`, and the finite `POLICIES` templates for task briefs, verification reports, child tasks/reports, handoffs, project AGENTS and feature plans, plus branch-finish, deployment, database and server-inspection checklists.
- All active policies in `POLICIES`, including `docs/git-network-policy.md`, `docs/runtime-readiness-policy.md`, routing/capability/Skill/cost policies, autonomy/context/parent-child/reporting/verification guidance, hook tuning and this installation guide.
- One managed root `AGENTS.md` block, the missing-only project profile, and the ownership hash manifest.

These lists are the reviewed install closure, not a recursive copy. Source-checkout maintenance commands in this guide refer to the original Harness checkout: migration tests, the migrator itself, historical reports, retired adapters, all other tests, and unrelated docs are not distributed just because they exist or are mentioned. Unknown target content outside the managed paths is never changed. Future active runtime/policy dependencies must be added to the finite lists and fixture contract together.

No trusted authority, private key, live grant, authentication material, or provider configuration is copied from the Harness source. The release authorization template is a draft, **not an approval**. Without a trusted authority or the required authorization fields transported by the tool adapter, protected commands **fail closed**. Installing these files does not establish fully autonomous production execution. Hooks are guardrails, not a sandbox.

For a real Git checkout or linked worktree, only `.codex/harness-state/` is added to the verified real Git local exclude when needed; existing entries are retained. No backup exclusion is added. A non-Git target never receives a fabricated `.git` directory, and an enclosing repository's metadata is not changed for a nested non-root target.

## Verification

The migration-only tests create isolated `tempfile` source/target directories, copy only the tested script and fixture sources, and check resolved deletion paths remain inside the fixture root. They never migrate a production project or execute protected commands. The default suite includes repository-source integration and fails with concrete missing dependency paths rather than substituting fixture content. During parallel development, explicitly disable that one case to run only self-contained fixtures until all main-owned dependencies are supplied; record the skip, not a complete integration PASS.

```powershell
# While dependencies are being supplied, run fixtures only:
$env:MIGRATION_TEST_REPOSITORY_SOURCES = "0"
python -B tests/test_migration.py -v
# Optional Windows PowerShell compatibility run:
$env:MIGRATION_POWERSHELL = "powershell"
python -B tests/test_migration.py -v
Remove-Item Env:\MIGRATION_POWERSHELL
# Only after the complete source dependency set is ready:
Remove-Item Env:\MIGRATION_TEST_REPOSITORY_SOURCES
python -B tests/test_migration.py -v
git diff --check -- scripts/migrate-project-harness.ps1 tests/test_migration.py docs/install-hooks-upgrade.md
```

The fixture checks cover complete fresh install, upgrade/backfill, required-source preflight, ownership collisions, settings/history preservation, dry-run zero writes and idempotence. Repository-source integration copies the complete real dependency set, verifies every installed file, reruns Apply, then exercises the installed health check and SessionStart hook without manually filling installation gaps. It does not execute the authorization wrapper, branch checks, or evidence/runtime helpers; their behavioral suites remain separate integration requirements.

After an authorized real migration, inspect the project diff and run its own tests. These isolated tests prove migration behavior, not runtime signature verification, adapter transport, reviewer independence, or production readiness. Other test entrypoints are intentionally outside this migration change. An explicit integration skip is unverified acceptance, not a runtime PASS.
