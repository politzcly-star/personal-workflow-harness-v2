# TAOLONG-HARNESS-LATEST-ADOPTION Task Packet

Task ID: `TAOLONG-HARNESS-LATEST-ADOPTION`

Status: `FROZEN BY HUMAN GO ON 2026-07-10`

## Objective

Replace the legacy Harness configuration for the ai淘龙 workspace with the latest autonomous Goal Harness while preserving all project-specific rules, existing business changes, feature worktrees, production boundaries, and database boundaries.

The logical project has two active roots:

- management/profile root: `D:\ai淘龙` (not a Git repository);
- canonical local source repository: `D:\taolong-ai-src` (`main`).

## Classification And Ownership

- S-Level: `S3`.
- Route: `review_gated` plus local configuration migration.
- Root owner: Terra Medium goal owner.
- Implementation: `terra_worker` High, bounded to this Packet.
- Verification: `luna_verifier` Medium, read-only after local gates.
- Human interaction: no phase confirmation after this frozen `GO`; stop only for a Packet boundary, unsafe state, or unrecoverable verification contradiction.

## Human Authorization And Dirty Baseline

The Human explicitly accepts the current dirty baseline in `D:\taolong-ai-src` and authorizes:

- repairing the shared Harness migration script for this compatibility case;
- replacing old Harness configuration in `D:\ai淘龙` and `D:\taolong-ai-src`;
- committing and pushing only the approved Harness configuration paths in `D:\taolong-ai-src`.

The Human does not authorize business-code edits, feature-worktree edits, production/server writes, deployment/restart, database access/mutation, secret access, browser credentials, or staging unrelated dirty files.

Before any target edit, capture:

- Harness repository status and head;
- management-root inventory for every allowed target path;
- `D:\taolong-ai-src` `git status --short --untracked-files=all` and a schema-v2 per-file SHA-256 baseline for every pre-existing dirty path.

## Migration Compatibility Repair

Update the shared migration implementation so that:

1. a non-Git management directory does not receive a fake `.git` directory or `.git/info/exclude`;
2. local runtime state is ignored through Git exclude only when the target is a real Git worktree;
3. a legacy root beginning with `# Production Harness Project Addendum` is recognized when `-ReplaceLegacyAgents` is supplied;
4. the legacy Harness prefix is removed while the project-specific content beginning at `# Directory guide` is preserved byte-for-byte except unavoidable newline normalization;
5. dry run reports the exact replacement and preservation behavior;
6. deterministic fixtures cover non-Git targets and legacy Addendum preservation.

Do not change model identifiers or reasoning strengths in the shared Harness.

## Management Root Adoption

Target: `D:\ai淘龙`.

Required result:

- replace only the marked legacy `production-harness-v2` block in `AGENTS.md`;
- preserve `docs/project-profile.md` project, server, deployment, database, and source/worktree facts;
- update only the execution/model/context notes in the project profile when required for consistency;
- install the latest `.codex/config.toml`;
- install `terra-worker.toml` and `luna-verifier.toml`;
- install latest Hook JSON and PowerShell;
- install `scripts/goal-state.ps1`;
- install `templates/goal-contract.md` and `templates/context-capsule.md`;
- do not create `.git`, read secret-like files, or alter source/test/runtime artifacts.

## Canonical Source Adoption

Target: `D:\taolong-ai-src`.

Required result:

- replace the old Harness prefix in root `AGENTS.md` using the repaired legacy-Addendum migration path;
- preserve the entire project-specific `# Directory guide` and all following repository rules;
- preserve nested `AGENTS.md` files unchanged;
- install the same latest `.codex` model/agent/Hook configuration;
- install `scripts/goal-state.ps1` and the two Goal templates;
- update only workflow/model/context fields in `docs/project-profile.md` when needed;
- add local `.codex/harness-state/` Git exclude without changing tracked `.gitignore` unless direct evidence requires it;
- do not modify any `apps/**`, `packages/**`, `tools/**`, `e2e/**`, `deploy/**`, asset, product documentation, or business implementation path.

Feature worktrees under `D:\taolong-ai-worktrees\**` are read-only in this task. They inherit the new tracked configuration only after their normal merge/rebase lifecycle.

## Allowed Changes

Harness repository `D:\个人工作流-v2`:

- `scripts/migrate-project-harness.ps1`
- `scripts/harness-self-test.ps1`
- `docs/install-hooks-upgrade.md` only if compatibility documentation needs updating
- `tasks/TAOLONG-HARNESS-LATEST-ADOPTION.md`
- `audits/TAOLONG-HARNESS-LATEST-ADOPTION-gate-report.md`

Management root `D:\ai淘龙`:

- `AGENTS.md`
- `docs/project-profile.md`
- `.codex/config.toml`
- `.codex/agents/terra-worker.toml`
- `.codex/agents/luna-verifier.toml`
- `.codex/hooks.json`
- `.codex/hooks/harness-hook.ps1`
- `scripts/goal-state.ps1`
- `templates/goal-contract.md`
- `templates/context-capsule.md`
- local migration backup/runtime state created by the approved migration script

Canonical source `D:\taolong-ai-src`:

- `AGENTS.md`
- `docs/project-profile.md`
- `.codex/config.toml`
- `.codex/agents/terra-worker.toml`
- `.codex/agents/luna-verifier.toml`
- `.codex/hooks.json`
- `.codex/hooks/harness-hook.ps1`
- `scripts/goal-state.ps1`
- `templates/goal-contract.md`
- `templates/context-capsule.md`
- `.git/info/exclude` local-only entry for `.codex/harness-state/`
- local migration backup/runtime state created by the approved migration script

## Forbidden Changes

- `D:\taolong-ai-src\apps\**`
- `D:\taolong-ai-src\packages\**`
- `D:\taolong-ai-src\tools\**`
- `D:\taolong-ai-src\e2e\**`
- `D:\taolong-ai-src\deploy\**`
- nested project `AGENTS.md` files
- `D:\taolong-ai-worktrees\**`
- `D:\ai淘龙` screenshots, environment/config files, payment files, archives, browser profiles, remote copies, work directories, or runtime evidence
- secrets, `.env*`, payment config, tokens, credentials, cookies, private keys, database files, dumps, or raw production logs
- production server, SSH writes, deployment, restart, container rebuild, database read/write/migration
- global Codex configuration or installed plugins
- model identifiers, model reasoning strengths, or thread limits other than installing the already-frozen latest Harness files unchanged
- staging, committing, or pushing any pre-existing business change

## Commit And Push Boundary

After Luna acceptance, stage in `D:\taolong-ai-src` only:

- root `AGENTS.md`;
- `docs/project-profile.md` if changed by this task;
- `.codex/config.toml`;
- `.codex/agents/**`;
- `.codex/hooks.json`;
- `.codex/hooks/harness-hook.ps1`;
- `scripts/goal-state.ps1`;
- `templates/goal-contract.md`;
- `templates/context-capsule.md`.

Inspect the staged diff and prove no business path is staged before commit. Commit and push to `origin/main`. Do not stage or commit `.git/info/exclude`, local backup state, or unrelated dirty files.

Do not commit or push the shared Harness migration repair in this task; leave it for a separate Harness branch-finish decision.

## Acceptance Matrix

### Migration Safety

- Dry run is non-mutating for both roots.
- Non-Git management root remains without `.git`.
- Legacy Addendum replacement preserves `# Directory guide` and all following project rules.
- Marked management-root block is replaced once; no duplicate old/new Harness remains.
- Migration backups and runtime state remain local-only.

### Configuration Consistency

- Both roots receive byte-identical latest model, agent, Hook, Goal helper, and Goal templates.
- Root model remains Terra Medium, worker Terra High, verifier Luna Medium.
- Hooks include `SessionStart`, `PreToolUse`, `PreCompact`, and `PostCompact`.
- Three-action Goal workflow, bounded repair, Context Capsule, and safety boundary are present.
- Project-specific server/deployment/database restrictions remain intact.

### Scope

- No pre-existing business file content changes.
- No feature worktree changes.
- No nested `AGENTS.md` changes.
- Target schema-v2 baseline proves module changes against the accepted dirty worktree.
- Staged and committed paths are an exact subset of the commit boundary.

### Verification

- Shared Harness `harness-self-test.ps1` and strict health pass after migration repair.
- Both migration dry runs report no blocker after repair.
- Installed JSON/TOML parse; installed PowerShell parses.
- Installed asset hashes match the Harness source.
- `rg` confirms no duplicate legacy workflow prefix and confirms preserved directory rules.
- Target `git diff --check` passes for approved configuration paths.
- Luna returns GO or an accepted Conditional GO.

## Gate Report

Write `D:\个人工作流-v2\audits\TAOLONG-HARNESS-LATEST-ADOPTION-gate-report.md` with:

- three baseline records;
- migration repair and fixture evidence;
- management/source installed paths;
- preservation checks;
- target scope and staged-diff proof;
- local checks, Luna decision, residual risk, commit and push result.

## Stop Conditions

Stop only if:

- preserving the project-specific AGENTS tail requires changing its meaning;
- a target business or feature-worktree file must be modified;
- secrets, production access, deployment, database action, or remote write is required;
- target Git state prevents a configuration-only commit/push without including unrelated changes;
- the same local verification blocker persists after three focused repair attempts.
