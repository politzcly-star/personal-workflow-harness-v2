# HARNESS-56-UPGRADE Task Packet

Task ID: `HARNESS-56-UPGRADE`

Status: `PLAN FROZEN - WAITING FOR TERRA HIGH`

## Ownership And Model Route

- Plan and acceptance owner: Sol, `high` reasoning.
- Implementation owner: Terra, `high` reasoning, one continuous implementation task.
- Independent verifier: Luna, `medium` reasoning, once after the milestone implementation is complete.
- Repair loop: Terra performs narrow repairs; Luna reruns only affected acceptance checks.
- Sol returns only if implementation evidence conflicts with this packet or the acceptance contract must change.
- `max` and `ultra` are not part of the normal route.

This packet does not activate model routing. Project model configuration and custom agent definitions remain forbidden until the repository upgrade passes independent verification and the Human gives a separate GO.

## Classification

- S-Level: `S3`
- Route: `review_gated`
- Risk: medium implementation risk with high workflow blast radius.
- Reason: the repository contains no production application code, but its durable instructions, templates, hooks, and verification scripts affect every adopted project and have hidden acceptance risk.
- Formal-flow adaptation: use this Task Packet, exact scope, local evidence, and Luna review. Do not invoke Claude/Qwen; `external_child_executor_mode` remains disabled.

## Human Authorization And Dirty Baseline

- Allow Dirty Worktree: `YES`
- Human authorization: on 2026-07-10 the Human approved using the current 14 uncommitted paths as the upgrade baseline and proceeding to solution design.
- Baseline branch: `master`
- Baseline commit: `0949ed7`
- Baseline state: 11 modified tracked files, 3 untracked files, nothing staged.

Baseline paths:

- `AGENTS.md`
- `docs/capability-policy.md`
- `docs/context-compression-policy.md`
- `docs/context-memory.md`
- `docs/parent-child-execution.md`
- `docs/reporting-policy.md`
- `docs/route-policy.md`
- `templates/handoff.md`
- `templates/project-agents.md`
- `templates/project-profile.md`
- `templates/verification-report.md`
- `docs/external-executor-workflow.md` (untracked)
- `templates/external-child-task.md` (untracked)
- `templates/external-child-report.md` (untracked)

Do not reset, stash, discard, or overwrite this baseline wholesale. Terra must review and reshape it according to the disposition rules below.

Baseline checks on 2026-07-10:

- `scripts/health-check.ps1`: exit `0`; required files, JSON parsing, and current PowerShell syntax pass; CodeGraph is unavailable and the documented fallback applies.
- `scripts/scope-check.ps1`: exit `0`; it reports the dirty paths but does not yet distinguish a task baseline from new scope drift.
- `scripts/stop-check.ps1`: exit `0` without a concrete report and checks only template availability. This is a confirmed weak check that Phase C must fix.
- `.vs` and `tmp` exist as local/runtime directories and must remain untracked and untouched.

## Priority Order

1. Improve daily development speed and reduce Human routing work.
2. Preserve or improve complex-task acceptance quality.
3. Reduce unnecessary model calls, context loading, reports, and hook traffic.
4. Keep strict safety boundaries for secrets, destructive actions, database writes, deployment, and production mutation.

When process completeness conflicts with routine efficiency without a real safety benefit, routine efficiency wins.

## Target Operating Model

### One Primary Weight, Conditional Routes

- Keep `S0-S4` as the primary execution-weight decision.
- Stop requiring a separate four-layer classification in daily task briefs, handoffs, and reports; layer is derivable and adds no independent decision value.
- Use a named route only when it changes execution behavior, tools, or guardrails. S0 discussion and obvious S1 edits do not need route ceremony.
- Keep specialized routes for bugs, structural localization, docs uncertainty, review risk, deployment, server inspection, database work, branch finish, and explicitly formal delivery.

### Daily Delegation

- S0/S1: one Terra thread, no child and no reviewer by default.
- S2: Terra direct execution is the default when scope and verification are clear. Delegate only when a bounded parallel task materially saves time or isolates context.
- S3: Terra implements; use one independent Luna review or a risk-specific checklist. Do not require both child implementation and reviewer when one provides sufficient evidence.
- S4: Sol freezes roadmap and milestone acceptance; Terra delivers one milestone at a time; Luna reviews milestone boundaries rather than every small module.
- No automatic subagent spawning because a task is merely long or token-heavy.

### Model Roles After Later Configuration

- Default daily model: Terra `medium`.
- Cross-file, unfamiliar, or S3 implementation: Terra `high`.
- Architecture, roadmap, competing approaches, or acceptance-contract ambiguity: Sol `high`.
- Milestone and high-risk independent verification: Luna `medium`; Luna `high` only for security, permission, deployment, database, or similarly high-consequence evidence.
- `max` is exception-only after conflicting evidence or repeated failed repair.
- `ultra` is Human-only and must never be selected automatically.

### Context And Token Rules

- A child or verifier receives the current Task Packet plus only directly relevant files; do not require a fixed seven-document reread.
- Prefer links and delta reports over copied repository text, full transcripts, or repeated command output.
- Terra runs focused checks during implementation. Luna receives the final packet, diff, and compact evidence once.
- A failed Luna check returns a narrow defect list, not a request to restart the whole workflow.

## Existing-Change Disposition

| Current change | Decision | Required treatment |
| --- | --- | --- |
| External executor guardrails in `AGENTS.md` and `templates/project-agents.md` | Keep, compress | Retain a short Human-only activation rule and pointer. Remove long duplicated policy text. |
| `docs/external-executor-workflow.md` | Keep as optional adapter | Make it clearly separate from native Sol/Terra/Luna routing and daily work. |
| `templates/external-child-task.md` and `templates/external-child-report.md` | Keep as optional adapter | Simplify them and remove the redundant layer field. They are loaded only when explicitly activated. |
| External-executor sections in route, capability, and parent/child docs | Compress | Keep one concise reference per relevant document; the adapter document is authoritative for details. |
| External-executor fields in normal verification, profile, context, and handoff templates | Remove from default path | Rare optional state must not tax every task. The optional adapter report owns those fields. |
| Current S-level + route + layer model | Rewrite | S-level becomes primary; route is conditional; daily layer fields are removed. |
| S2 `child_recommended` default | Rewrite | Terra direct is normal. Delegation requires a concrete throughput, isolation, or risk reason. |
| High-frequency PostToolUse, SubagentStop, PreCompact, and Stop enforcement | Remove or downgrade | Keep hard blocks only where unsafe actions justify them. Avoid context injection and false completion blocks. |
| Scope and stop scripts | Rewrite for evidence value | Scope checking must support an exact allowlist and report real violations. Stop checking must not pass merely because an empty template exists. |

## Implementation Phases

Terra executes all phases in one continuous task. Do not switch models between phases.

### Phase A - Durable Policy

- Rewrite the root instructions and project addendum around the target operating model.
- Add one authoritative model-role policy document.
- Simplify route, capability, parent/child, efficiency, reporting, context, and guardrail documents.
- Remove four-layer fields from active daily workflow documents while leaving historical reports untouched.

### Phase B - Minimal Artifacts

- Reduce task, child, report, handoff, and project-profile templates to information that changes decisions.
- Keep optional external-executor artifacts isolated from the default path.
- Preserve deployment, database, server, product-acceptance, and branch-finish checklists unless a compatibility edit is required.

### Phase C - Guardrails And Verification

- Reduce hook events to the smallest set that protects real boundaries.
- Keep strict PreToolUse blocks for secret-file access, embedded credentials, destructive filesystem/git commands, database mutation, deployment/restart, and unapproved remote mutation.
- Remove routine changed-file snapshots and natural-language completion blocking.
- Make `scope-check.ps1` enforce exact allowed paths without treating safe repository prose as a secret.
- Turn `stop-check.ps1` into a useful explicit report check or a compatibility wrapper; it must not claim meaningful verification when no report is supplied.
- Add a deterministic self-test covering allowed and blocked hook examples, JSON parsing, PowerShell syntax, scope behavior, and health-check behavior.

### Phase D - Product Documentation

- Update README and hook installation/upgrade guidance to match actual behavior.
- Record the new version and migration notes without rewriting historical verification reports.
- Do not claim measured token savings or pass-rate gains without evaluation evidence.

## Allowed Changes

Existing files:

- `AGENTS.md`
- `README.md`
- `docs/capability-policy.md`
- `docs/context-compression-policy.md`
- `docs/context-memory.md`
- `docs/developer-efficiency-mode.md`
- `docs/external-executor-workflow.md`
- `docs/hook-tuning.md`
- `docs/install-hooks-upgrade.md`
- `docs/parent-child-execution.md`
- `docs/reporting-policy.md`
- `docs/route-policy.md`
- `docs/verification-and-guardrails.md`
- `templates/child-report.md`
- `templates/child-task.md`
- `templates/external-child-report.md`
- `templates/external-child-task.md`
- `templates/handoff.md`
- `templates/project-agents.md`
- `templates/project-profile.md`
- `templates/task-brief.md`
- `templates/verification-report.md`
- `.codex/hooks.json`
- `.codex/hooks/harness-hook.ps1`
- `scripts/health-check.ps1`
- `scripts/scope-check.ps1`
- `scripts/stop-check.ps1`

New files:

- `docs/model-routing-policy.md`
- `scripts/harness-self-test.ps1`
- `audits/HARNESS-56-UPGRADE-gate-report.md`

Planning artifact owned by Sol and read-only to Terra unless a blocking contradiction is found:

- `tasks/HARNESS-56-UPGRADE.md`

## Forbidden Changes

- `.codex/config.toml`
- `.codex/agents/**`
- global Codex configuration, global skills, or installed plugins
- historical verification reports under `docs/*verification-report.md`
- deployment, database, remote server, credentials, secrets, or personal browser state
- git reset, stash, discard, branch deletion, commit, push, PR, or merge
- unrelated refactors or new framework dependencies

The repo-local `.codex/hooks.json` is allowed because it is an existing harness behavior file. Model/agent configuration remains forbidden.

## Acceptance Matrix

### Daily Efficiency

- An S0/S1 task can start after reading root instructions and the task itself; it is not required to create a Task Packet, choose a layer, spawn a child, or produce a formal report.
- A bounded S2 task defaults to one Terra thread and focused verification.
- Default templates contain no mandatory external-executor fields.
- The standard child packet no longer mandates reading seven fixed harness documents.
- Routine tool calls do not inject a full `git status` snapshot after every action.
- Normal completion is not blocked by natural-language pattern matching.

### Complex-Task Quality

- S3/S4 work still has explicit scope, stop conditions, verification evidence, and independent review where risk justifies it.
- Sol owns architecture and acceptance changes; Terra cannot silently rewrite the contract.
- Luna reviews the completed milestone once and returns actionable, severity-ranked findings.
- Secrets, destructive operations, database writes, deployment/restart, and unapproved remote mutation remain blocked.

### Routing And Human Load

- The repository documents Terra `medium` as the future daily default and clear escalation triggers for Terra `high`, Sol `high`, and Luna verification.
- No rule requires the Human to switch to Luna after each small module.
- No rule automatically selects `max` or `ultra`.
- The future automatic-routing mechanism is documented but not activated by this task.

### Compatibility And Honesty

- Existing project-adoption instructions remain usable.
- External Claude/Qwen execution remains available only through explicit Human activation and is not confused with native model routing.
- Historical reports remain unchanged.
- Documentation makes no universal productivity, token-saving, or pass-rate claim.

## Minimum Verification

Terra must run and record:

```powershell
.\scripts\harness-self-test.ps1
.\scripts\health-check.ps1 -Strict
.\scripts\scope-check.ps1 -Strict -AllowedPath <all allowed paths from this packet>
git diff --check
```

Also record:

- `.codex/hooks.json` parses as JSON;
- every changed PowerShell file parses without syntax errors;
- safe read-only/docs commands are allowed by hook fixtures;
- secret-file reads, credential embedding, destructive git/filesystem commands, database mutation, deployment/restart, and unapproved remote mutation are denied by hook fixtures;
- `rg` assertions prove removed default fields and retained safety terms;
- actual changed paths are a subset of this packet's allowed paths;
- skipped checks and residual risk.

CodeGraph is not required: this repository is a Markdown/PowerShell harness with no application call graph. Compensate with file tree, `rg`, script call-site search, hook fixture tests, and direct syntax/behavior checks.

## Luna Review Gate

After Terra reports all local checks passing, provide Luna with only:

- this Task Packet;
- the final diff;
- the gate report;
- relevant failed/passed self-test summaries.

Luna must review read-only for:

1. acceptance-matrix coverage;
2. hidden daily friction or unnecessary mandatory fields;
3. weakened safety boundaries;
4. contradictions between root instructions, templates, scripts, and hooks;
5. scope drift and unsupported claims.

Decision values: `GO`, `CONDITIONAL GO`, or `NO-GO` with severity-ranked, file-specific findings.

## Stop Conditions

Terra stops and returns to Sol/Human if:

- model/agent configuration must change to complete this task;
- an allowed file outside this packet is required;
- the acceptance contract needs architectural revision;
- strict safety guards cannot be preserved while meeting daily-efficiency acceptance;
- verification requires credentials, remote mutation, database action, deployment, or destructive git/filesystem action;
- existing baseline changes cannot be reconciled without discarding user work.

## Rollback

No destructive rollback command is authorized. Before commit, rollback means reviewing the diff and using narrow, explicitly approved patches only. Preserve the original 14-path baseline until the Human separately chooses a branch/commit/cleanup action.
