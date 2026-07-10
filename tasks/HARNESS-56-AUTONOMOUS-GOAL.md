# HARNESS-56-AUTONOMOUS-GOAL Task Packet

Task ID: `HARNESS-56-AUTONOMOUS-GOAL`

Status: `PLAN PROPOSED - HUMAN GO WILL FREEZE THIS PACKET`

## Objective

Upgrade the production Harness so the Human normally performs only three actions:

1. state the requirement;
2. review the route, acceptance contract, and authorization boundary, then give one `GO`;
3. read the final evidence and either accept it or create a new task.

For an overnight Goal, the Human may use Sol before execution to freeze this packet, then switch once to the Terra root. After execution starts, the root must automatically choose the execution topology, implement, test, run bounded repairs, invoke independent review when required, and return final evidence without asking the Human to switch models or confirm routine phases.

## Ownership And Model Route

- Route and acceptance owner: Human-reviewed Sol plan, `high` reasoning as needed.
- Goal owner after `GO`: root `gpt-5.6-terra`, `medium` reasoning.
- Bounded implementation owner: `terra_worker`, `gpt-5.6-terra`, `high` reasoning.
- Independent verifier: `luna_verifier`, `gpt-5.6-luna`, `medium`, read-only.
- Repair owner: the same Terra root/worker that holds the implementation context.
- Sol returns only when the objective, architecture, authorization boundary, or final acceptance contract must materially change.
- The Human does not switch to Luna or confirm implementation, test, repair, or review phases after Goal execution starts.
- Do not use `max`, `ultra`, recursive delegation, or parallel writers automatically.

This packet does not itself change model identifiers or reasoning strengths.

## Classification

- S-Level: `S4`
- Route: `review_gated`
- Risk: high workflow blast radius and security-boundary risk.
- Reason: the change affects durable agent instructions, context recovery, automatic delegation, Hook behavior, authorization boundaries, migration into adopted projects, and unattended Goal execution.
- Delivery shape: one complete module with four internal milestones and one final independent Luna gate. Milestone-local failures are repaired automatically; they do not require a new Human approval while the frozen contract remains valid.

## Human Authorization And Dirty Baseline

- Allow Dirty Worktree after Human `GO`: `YES`.
- The Human's `GO` must explicitly accept the current dirty worktree as the completed prior v5.6 upgrade baseline and authorize only the delta described by this packet.
- Baseline branch: `master`.
- Baseline commit: `0949ed7`.
- Tracked diff SHA-256 captured before this planning artifact: `1234f7a006ed7e3a50664ee18010c398cbcc10505012c2ddbf4913157e62f2f9`.
- Baseline authority artifacts:
  - `tasks/HARNESS-56-UPGRADE.md`
  - `audits/HARNESS-56-UPGRADE-gate-report.md`
  - `audits/HARNESS-56-ACTIVATION-verification-report.md`
  - `audits/HARNESS-56-JINSHA-ONBOARDING-verification-report.md`
- The existing dirty baseline must not be reset, stashed, discarded, reformatted wholesale, or misreported as new work.
- Before implementation, the Terra root records `git status --short --untracked-files=all` and treats every existing path except this packet as inherited baseline state.
- New scope evidence must distinguish inherited baseline paths from files changed by this module. `scope-check.ps1` may be extended with a baseline manifest for this purpose.

## Frozen Human Interaction Contract

### Before GO

The root presents one compact route card containing:

- goal and non-goals;
- S-level and only the routes that change checks or authority;
- allowed and forbidden files/actions;
- acceptance checks;
- automatic repair budget;
- conditions that require a new Human decision.

The Human reviews this information once. The Human's `GO` freezes the exact objective, acceptance checks, and authorization boundary.

### After GO

The root continues through these states without routine Human confirmation:

```text
ACTIVE
> IMPLEMENTING
> VERIFYING
> REPAIRING (only when a check fails inside the contract)
> REVIEWING (only when the route requires independent review)
> COMPLETE or BLOCKED
```

The root may report concise progress updates, but an update is not a request for permission and must not pause safe in-scope work.

### Only Valid Mid-Goal Stops

Stop and request a new Human decision only when:

- the objective or an acceptance criterion must materially change;
- a required file/action is outside the frozen authorization boundary;
- credentials, secrets, private browser state, a paid external action, production deployment/restart, database mutation, destructive action, or unapproved remote mutation is required;
- a security boundary or Harness policy must be weakened;
- verification cannot continue safely;
- the same blocking condition persists through three focused repair attempts;
- independent review finds a material contradiction that cannot be repaired without changing the contract.

A failed test, lint error, build failure, Luna finding, or ordinary implementation defect is not by itself a reason to ask the Human to switch models or restart the task.

## Target Execution Topology

### S0 And S1

- S0 remains direct discussion/read-only work.
- A known narrow S1 change may remain in the Terra root and run one focused check.
- No child, Luna review, Task Packet, or runtime Goal state is required by default.

### S2 Throughput Mode

- The root owns the route, frozen acceptance, authorization boundary, and final evidence.
- Root-direct execution is preferred only when the location is known, exploration is minimal, logs are small, and the task is unlikely to need repair loops.
- Use `terra_worker` when exploration, cross-file reads, builds, test logs, retries, or context isolation would materially preserve root-thread capacity.
- Delegated S2 does not become a formal parent/child/evaluator ceremony. The worker receives a compact contract and returns compact evidence.
- Reuse the existing Terra worker for consecutive work in the same subsystem or milestone when its retained context is still relevant and its scope remains bounded.
- Start a fresh worker for unrelated tasks or when the previous worker's assumptions no longer match the active contract.
- Luna is not used for routine S2 work unless a listed safety/boundary trigger or hidden acceptance risk appears.

### S3 And S4

- S3 uses one bounded Terra implementation owner and one read-only Luna verification after local checks pass.
- S4 keeps the root as roadmap/goal owner and executes milestones without Human phase approvals.
- Luna reviews meaningful acceptance boundaries, not every small edit. For this packet, one final Luna review is required after all four milestones and local gates pass.
- A Luna `NO-GO` returns only severity-ranked findings to the same Terra implementation owner. Terra performs a narrow repair and Luna reruns only affected acceptance checks plus any necessary regression check.

## Goal Contract And Context Capsule

### Runtime State Location

Introduce an ignored project-local runtime directory:

```text
.codex/harness-state/
```

It may contain only bounded, non-secret runtime state such as:

- active goal id and status;
- pointer to the frozen contract and its content hash;
- context epoch and previous capsule hash;
- current milestone and next action;
- allowed/forbidden scope references;
- changed-path summary and verification status;
- unresolved risks and stop reason.

The runtime directory must be ignored by Git, excluded from migration backups and reports unless referenced as redacted runtime evidence, and must never contain raw prompts, full transcripts, source dumps, complete command output, secrets, credentials, private payloads, database dumps, or browser state.

### Frozen Contract

- Goal mode uses a concise contract generated from `templates/goal-contract.md`.
- Human `GO` freezes the contract hash before implementation.
- The active state points to the frozen contract and records its hash.
- Terra and Luna may read the contract but may not edit it.
- A requested contract change stops execution and returns to Sol/Human.
- A generic Goal `GO` does not authorize deployment, database mutation, destructive action, credentials, private browser state, paid actions, or production remote mutation. Those require an explicit fresh objective and route-specific fields.

### Context Capsule

Introduce `templates/context-capsule.md` with only:

- goal id, context epoch, contract reference/hash;
- current objective and milestone;
- durable decisions and non-goals;
- hot files/symbols and `changed_since` summary;
- checks run/current verification state;
- unresolved risks, forbidden actions, and next action;
- relevant evidence references.

The capsule must be incremental. It references unchanged facts instead of copying repository documents. Raw logs and full diffs remain outside the capsule.

### Compaction And Resume

- Continue to rely on Codex built-in compaction; the Harness must not replace the platform compactor.
- The agent checkpoints the capsule at decision boundaries, before long verification, after a repair changes the diagnosis, before independent review, and before pausing.
- `PreCompact` may validate state freshness and emit a concise warning, but must never block compaction or attempt to summarize the transcript.
- A compact/resume `SessionStart` reloads only the bounded capsule or a pointer plus the minimum frozen contract context.
- Do not parse `transcript_path` as a durable schema or source of truth.
- Missing, stale, oversized, malformed, or secret-like state must fail safely: do not inject it; report a concise warning and fall back to repository authority files.
- Closing a task archives or removes active runtime state without deleting committed project artifacts or evidence.

## Authorization-Aware Safety Boundary

### Permanent Hard Blocks

Retain deterministic blocks for:

- secret-like file access and private-key material;
- embedded credentials or tokens;
- destructive filesystem and Git operations;
- database writes, migrations, and destructive queries;
- deployment, restart, production mutation, and unapproved remote writes;
- credentialed/private browser actions when no fresh objective authorizes them.

These boundaries cannot be weakened by a generic Goal contract.

### Contract-Aware Scope

- Safe operations inside the frozen allowed scope proceed without repeated Human permission.
- Apply-patch targets outside the exact allowed files/areas are denied while a Goal contract is active.
- Known shell-based mutation forms must respect the active allowed scope where the target can be determined safely.
- Unknown or ambiguous mutation forms must not be treated as proven safe merely because a contract exists.
- Post-change scope verification remains mandatory because Hooks are guardrails, not a complete sandbox.
- Attempts to modify the active frozen contract, its recorded hash, Harness safety policy, hooks, model/agent configuration, or authorization state are denied unless those exact files and the policy-change intent are explicitly included in the Human-approved packet.
- Safety telemetry or state-write failures must not silently broaden permissions.

### Repair Authority

Within the frozen contract, Terra may automatically:

- edit allowed files;
- run approved local tests, lint, build, packaging, and read-only inspection;
- perform focused repair loops;
- send compact findings between Terra and Luna;
- rerun affected and required regression checks.

Repair authority does not include expanding allowed paths, changing architecture/acceptance, weakening a test, deleting evidence, or activating a high-risk route.

## Implementation Milestones

Terra executes the milestones continuously after Human `GO`. A local milestone failure triggers an in-scope repair; it does not return to Sol unless a frozen decision must change.

### Milestone 1 - Durable Three-Action Protocol

- Make the Human three-action contract authoritative in root and project instructions.
- Update S0-S4 behavior around S2 Throughput Mode, context-affinity worker reuse, and conditional Luna review.
- Define the Goal state machine, automatic repair behavior, valid stop conditions, and non-blocking progress updates.
- Keep the normal small-task path lightweight.

### Milestone 2 - Goal State And Context Recovery

- Add the goal-contract and context-capsule templates.
- Add a bounded PowerShell helper for initialize/activate, checkpoint, show/resume, validate, and close operations.
- Add ignored runtime-state handling and health checks.
- Connect non-blocking compaction/resume lifecycle handling without transcript parsing.
- Prove state hash, epoch, size, malformed-state, redaction, stale-state, and close behavior with temporary fixtures.

### Milestone 3 - Authorization-Aware Guardrails

- Preserve all current hard-block fixtures.
- Add active-contract immutability and exact apply-patch scope fixtures.
- Add safe in-scope command/edit fixtures and out-of-scope/ambiguous mutation fixtures.
- Ensure Harness self-modification requires explicit Packet scope.
- Keep Hook output quiet for safe routine work and non-blocking for compaction.

### Milestone 4 - Adoption, Consistency, And Final Gate

- Update migration/install logic so adopted projects receive the same instructions, templates, scripts, Hook definitions, ignore rules, and self-tests.
- Preserve existing project conventions and profiles during migration.
- Update README and concise operator guidance.
- Run the full local validation matrix.
- Produce one Gate Report and dispatch one final read-only Luna review.
- Repair Luna findings automatically when they remain inside this packet; otherwise stop with the exact contract contradiction.

## Allowed Changes

Existing files:

- `AGENTS.md`
- `README.md`
- `.gitignore`
- `.codex/hooks.json`
- `.codex/hooks/harness-hook.ps1`
- `.codex/agents/terra-worker.toml`
- `.codex/agents/luna-verifier.toml`
- `docs/capability-policy.md`
- `docs/context-compression-policy.md`
- `docs/context-memory.md`
- `docs/developer-efficiency-mode.md`
- `docs/hook-tuning.md`
- `docs/install-hooks-upgrade.md`
- `docs/model-routing-policy.md`
- `docs/parent-child-execution.md`
- `docs/reporting-policy.md`
- `docs/route-policy.md`
- `docs/verification-and-guardrails.md`
- `scripts/harness-self-test.ps1`
- `scripts/health-check.ps1`
- `scripts/migrate-project-harness.ps1`
- `scripts/scope-check.ps1`
- `scripts/stop-check.ps1`
- `templates/child-task.md`
- `templates/child-report.md`
- `templates/handoff.md`
- `templates/project-agents.md`
- `templates/project-profile.md`
- `templates/task-brief.md`
- `templates/verification-report.md`

New files:

- `docs/autonomous-goal-workflow.md`
- `templates/goal-contract.md`
- `templates/context-capsule.md`
- `scripts/goal-state.ps1`
- `audits/HARNESS-56-AUTONOMOUS-GOAL-gate-report.md`

Planning artifact, read-only after Human `GO`:

- `tasks/HARNESS-56-AUTONOMOUS-GOAL.md`

Terra may leave an allowed file unchanged when direct inspection proves no change is needed. It must report that decision rather than editing for symmetry.

## Forbidden Changes

- `tasks/HARNESS-56-UPGRADE.md`
- prior audit/verification reports, including `audits/HARNESS-56-UPGRADE-gate-report.md`
- `.codex/config.toml`
- model identifiers, model reasoning strengths, `agents.max_threads`, or `agents.max_depth`
- global Codex configuration, global skills, installed plugins, or user profile state
- `D:\jinsha\jinshaxinxi` or any adopted project during this Harness implementation
- `D:\Agent 效率测试平台项目`
- deployment, database, remote server, credentials, secrets, or personal browser state
- external Claude/Qwen executor activation
- new framework dependencies, services, dashboards, or observability platform work
- git reset, stash, discard, branch deletion, commit, push, PR, merge, or cleanup
- broad rewrite of the inherited dirty baseline unrelated to this packet

## Acceptance Matrix

### Human Load

- Durable instructions describe exactly three normal Human actions: requirement, one route/acceptance/authorization `GO`, and final evidence review.
- After `GO`, no rule asks the Human to confirm implementation start, test start, repair start, Luna invocation, or affected-check reruns.
- The only normal manual model change is the optional pre-Goal Sol planning selection followed by one switch to the Terra root before execution.
- Progress updates do not pause execution.
- Every mid-Goal stop maps to an explicit stop condition in this packet.

### Daily Throughput

- S1 remains cheap and root-direct.
- S2 chooses root-direct versus `terra_worker` using context cost and throughput, not task length alone.
- Same-subsystem work may reuse a Terra worker; unrelated work does not inherit stale worker context.
- Delegated S2 requires no formal evaluator or Gate Report by default.
- Root receives compact evidence without raw logs/full transcripts and can continue handling later tasks in the same window.

### Goal Continuity And Context Recovery

- A frozen Goal contract has an id, status, content hash, authorization boundary, acceptance checks, and stop conditions.
- Active state records a context epoch and capsule hash and detects stale or modified state.
- Checkpoint/resume loads incremental state and references unchanged artifacts rather than rereading every phase file.
- Compact/resume behavior is bounded, non-blocking, and does not parse transcripts.
- Missing, malformed, oversized, or secret-like state is not injected.
- Goal close removes active runtime state safely and preserves committed evidence.

### Autonomous Verification And Repair

- Terra runs focused checks during implementation, then required broader checks before completion.
- Ordinary failures remain inside an automatic focused repair loop.
- The same blocker stops only after three focused attempts or when a frozen boundary must change.
- Luna is invoked automatically only for S3/S4 or an explicit hidden-risk trigger.
- A Luna `NO-GO` generates a narrow Terra repair and affected-check re-review without a Human model switch.

### Safety

- Every current hard-block self-test remains passing.
- Safe in-scope edits and local verification do not generate approval friction.
- Active-contract and out-of-scope patch modification attempts are denied.
- Generic Goal approval cannot authorize secrets, destructive actions, database writes, deployment/restart, private browser state, paid actions, or production remote mutation.
- Contract, Hook, agent, and policy self-modification requires exact Human-approved scope.
- Scope verification still detects post-action drift; documentation does not claim Hooks are a sandbox.

### Adoption And Consistency

- Migration dry run remains non-mutating.
- Apply migration preserves project conventions/profile and installs the new managed runtime assets only when authorized.
- Root instructions, managed project block, model policy, execution protocol, templates, scripts, hooks, and README describe the same state machine and stop conditions.
- Existing Jinsha files are not changed by this module.
- No universal token-saving, productivity, pass-rate, or safety guarantee is claimed.

## Minimum Verification

Terra must run and record:

```powershell
.\scripts\harness-self-test.ps1
.\scripts\health-check.ps1 -Strict
.\scripts\scope-check.ps1 -Strict -AllowedPath <all packet-allowed paths> -BaselineManifest <captured inherited baseline>
.\scripts\stop-check.ps1 -Strict -ReportPath audits/HARNESS-56-AUTONOMOUS-GOAL-gate-report.md
git diff --check
```

The self-test must additionally prove with temporary fixtures:

1. Goal state initialize, Human-approved activation, checkpoint, resume/show, validation, and close.
2. Contract hash mismatch, malformed JSON/Markdown, stale epoch, oversized capsule, and secret-like capsule fail safely.
3. Normal `SessionStart` stays concise; compact/resume startup injects only bounded safe state.
4. `PreCompact` never blocks compaction and never parses a transcript.
5. Safe in-scope patch and local verification are allowed.
6. Out-of-scope patch, active-contract edit, unauthorized Hook/agent-policy edit, and ambiguous unsafe mutation are denied.
7. Existing secret, credential, destructive Git/filesystem, database, deployment/restart, and remote-write fixtures remain denied.
8. A simulated S2 delegated run returns compact evidence without requiring Luna.
9. A simulated Luna `NO-GO` routes findings back to Terra and does not require a Human phase confirmation.
10. Migration dry-run/apply/conflict fixtures install the new assets, preserve project facts, and ignore `.codex/harness-state/`.
11. Every changed JSON/TOML file parses and every changed PowerShell file passes parser validation.
12. Actual module delta is within this packet after subtracting the inherited dirty baseline.

CodeGraph is not required for this Markdown/PowerShell Harness. Compensate with `rg`, direct call-site inspection, fixture coverage, syntax parsing, and migration tests.

## Gate Report

Terra writes:

```text
audits/HARNESS-56-AUTONOMOUS-GOAL-gate-report.md
```

The report must include:

- inherited dirty baseline and module-only changed paths;
- milestone completion;
- Human-interaction acceptance evidence;
- context-state and compaction fixture evidence;
- permanent and contract-aware safety fixture evidence;
- migration compatibility evidence;
- checks run/skipped, scope guard, residual risk, and unsupported claims avoided.

## Final Luna Gate

After every local check passes, the root automatically sends Luna only:

- this frozen packet;
- the final module diff relative to the inherited baseline;
- the Gate Report;
- compact self-test, health, scope, and migration summaries.

Luna reviews read-only for:

1. any hidden Human phase confirmation or manual model-switch requirement after `GO`;
2. root-context pollution, repeated full-file reloads, stale worker reuse, or heavy S1/S2 ceremony;
3. unsafe authorization broadening, mutable contract state, Hook bypasses, or misleading sandbox claims;
4. compaction/resume data loss, transcript dependence, secret retention, or unbounded context injection;
5. contradictions across root/project instructions, templates, scripts, Hook events, migration logic, and tests;
6. scope drift and unsupported efficiency/safety claims.

Decision values: `GO`, `CONDITIONAL GO`, or `NO-GO` with severity-ranked, file-specific findings.

If Luna returns `NO-GO`, the root sends the narrow findings to Terra, Terra repairs only packet-allowed files, local affected checks run, and Luna rereviews affected acceptance plus necessary regression coverage. Human intervention is required only if the repair would change this packet.

## Final Stop And Handoff

After a final Luna `GO` or resolved `CONDITIONAL GO`, the Terra root stops and returns one compact final report containing:

- outcome and Luna decision;
- module-only changed files;
- checks and evidence;
- skipped checks and residual risk;
- whether the inherited dirty baseline remains uncommitted;
- the exact next Human choice: accept, request a new task, or separately authorize branch finish.

Do not commit, migrate Jinsha, start observability/AEL work, or begin another Harness module in this Goal.
