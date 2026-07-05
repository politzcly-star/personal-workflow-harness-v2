# Production Harness Starter Instructions

This file is the durable instruction layer for agents working in projects that adopt this harness.

## Authority Order

Use this order when instructions conflict:

```text
Human instruction
> repository AGENTS.md / project rules
> current task brief
> route policy
> verification report / handoff files
> chat memory
```

Chat can explain intent, but durable artifacts are the source of truth.

## Default Operating Rule

Use the smallest safe route that can complete the task with evidence.

Do not turn every task into a formal module. Do not skip verification because a task looks small.

## S0-S4 Task Weight

Before editing, classify both route and task weight.

S-level decides execution weight. The route and four-layer tier decide capabilities and acceptance strictness.

| Level | Meaning | Default Weight |
| --- | --- | --- |
| `S0` | Discussion, prompt help, explanation, no-code analysis. | Direct lightweight response. Full production flow is not required. |
| `S1` | Known file, small fix, single-point change. | Parent direct execution with focused verification. |
| `S2` | Medium but bounded feature/fix with clear scope and verification. | Parent may plan and implement directly; child is recommended, not mandatory. |
| `S3` | Cross-module, hidden acceptance, high-risk boundary, deployment, database, security, permission, public API, production server. | Child/reviewer required or strongly required. |
| `S4` | Long product line, multi-stage delivery, formal module, roadmap-sized work. | Parent splits stages; child executes; reviewer as needed. |

## Route First

Before editing, classify the task and name the route:

- clear small edit -> `lightweight_fix`
- bug, failing test, regression -> `audit_fix`
- unfamiliar cross-file area -> `structural_localization`
- vague feature -> `feature_discovery`
- mid-size feature -> `feature_plan`
- docs/API uncertainty -> `docs_assisted`
- boundary/security/permission -> `review_gated`
- deployment/config -> `deployment_route`
- read-only server inspection via preconfigured access -> `server_inspection`
- database/schema/migration -> `database_route`
- finished implementation, ready to push/PR/merge/cleanup -> `branch_finish`
- formal/high-risk delivery -> `lab_ai_delivery`

Use `docs/route-policy.md` for details.

## Four-Layer Execution Model

Map routes to these production tiers:

```text
lightweight_fix -> lightweight
audit_fix / structural_localization / docs_assisted / feature_plan -> medium
review_gated / deployment_route / database_route high-risk state -> review_gated
lab_ai_delivery / formal module -> full_formal_gate
```

Keep daily work light. Escalate only when uncertainty, blast radius, or hidden acceptance risk justifies it.

S-level and layer are complementary:

- S-level controls how heavy the execution protocol should be.
- Route/layer controls which capabilities, checks, and acceptance evidence are needed.

## Parent-router / Child-executor

Default principle: the parent thread routes, scopes, accepts, and verifies. It is not required to delegate every medium task.

Use this decision table:

```text
child_required:
  S3/S4, high-risk, hidden acceptance, deployment, database,
  security/permission/public API, unfamiliar cross-module work.

child_recommended:
  S2, cross-file but bounded work, medium new features,
  structural localization.

parent_allowed:
  S0/S1, and S2 when boundaries are clear and verification is obvious.
```

If child execution is unavailable:

- S0-S2: state child is unavailable or not worth opening, then continue in-parent.
- S3-S4: stop, explain the risk, and ask the Human to authorize parent-only execution or create/authorize child/reviewer support.

Use `docs/parent-child-execution.md`, `templates/child-task.md`, and `templates/child-report.md`.

## Capability Defaults

- `rg`: default fast local search.
- verification: default before completion.
- scope_guard: default before completion.
- CodeGraph/MCP: use for new project onboarding, medium or higher routes, cross-file work, unfamiliar code, structural localization, callers/callees, route ownership, and impact radius.
- `code-audit-fix`: use for bugs, failing verification, regressions, suspicious behavior, repair loops, and quick local diagnosis.
- `openai-docs`: use for OpenAI / Codex / API / SDK / current docs uncertainty.
- reviewer: use only when risk or hidden acceptance justifies it, especially boundary/security/permission/API/deployment/database/scope risk or formal work.
- actionable browser/UI: use on demand or eval/manual only; do not use personal logged-in browser state by default.
- `lab-ai-delivery`: use only for formal modules, high-risk tasks, or required Task Packet / Evaluator / Gate Report workflows.

Evidence limits:

- CodeGraph improves structural localization; it does not prove correctness.
- `code-audit-fix` improves diagnosis; it does not guarantee automatic repair.
- reviewer is high-risk-only, not decoration for every small task.
- `openai-docs` is for OpenAI/Codex/API uncertainty, not general web research.
- browser/UI should use a dedicated profile or explicit approval; avoid personal logged-in state.

## Developer Efficiency Mode

Use `docs/developer-efficiency-mode.md` as a default operating style:

- establish local or isolated fast feedback first;
- run the smallest relevant test before broad regression;
- broaden checks only when risk, shared behavior, or acceptance requires it;
- avoid refactors that do not reduce real complexity or risk;
- batch model calls, builds, and browser checks when possible;
- for remote/deployment work, prefer read-only inspection and dry-run/config-test before operator action.

## Verification-Before-Completion

Do not claim completion until verification is done or a narrow not-verified reason is recorded.

Reporting weight follows S-level:

- S0: direct answer; no route/report required unless useful.
- S1: lightweight report: changed files and verification.
- S2: standard report: route, files changed, checks, skipped checks, residual risk.
- S3-S4: formal report with child/reviewer/checklist evidence where needed.

Use `docs/reporting-policy.md` and `templates/verification-report.md`.

For product artifacts, also use `templates/product-acceptance.md` when visual/output quality matters.

## Guardrails

Do not read, print, store, or commit secrets.

Do not run production deployment, database writes, destructive commands, credentialed browser actions, paid external actions, or remote server changes unless the Human explicitly approves a fresh objective and the route policy allows it.

For deployment and database work, Codex should normally prepare checklists and consume redacted operator evidence rather than execute live actions.

Read-only server inspection is allowed only through `server_inspection` when the Human gives a fresh objective and access is already configured without exposing raw credentials. Acceptable access patterns include SSH config host aliases, SSH agent, short-lived operator-prepared sessions, or platform CLIs that do not print or embed secrets. Do not read passwords from screenshots, paste passwords into commands, use `sshpass`, or write credentials into terminal history, files, prompts, hooks, or reports.

## New Project Onboarding

On first use in a new project:

1. Install or merge `templates/project-agents.md` into the target project root `AGENTS.md`. A chat-only reference to this harness is not durable.
2. Create or update `templates/project-profile.md` into the project-specific profile location.
3. Try CodeGraph / structural indexing.
4. If CodeGraph is unavailable, record fallback: `rg` + file tree + test entry points + manual dependency/call relationship notes.
5. Record parent-router / child-executor availability and the S0-S4 delegation rule.
6. Check whether the Human supplied or documented a server SSH alias for the project.
7. If a server alias exists, run `scripts/server-inspection-check.ps1 -HostAlias <alias>` and use `server_inspection` for read-only queries.
8. If no alias exists, ask the Human to configure a Windows SSH config alias once; do not ask for raw passwords.
9. Capture package manager, start/test/build commands, ports, main directories, forbidden areas, database boundary, deployment boundary, server alias status, parent/child availability, CodeGraph status, common verification commands, and risk boundaries.

## Hook-ready Layer

This harness may include repo-local Codex hooks under `.codex/hooks.json` and `.codex/hooks/`. Hooks are a guardrail and memory layer, not a complete sandbox.

Hook results are classified as `info`, `warn`, or `block`. Keep strict blocks for secrets, private keys, raw credentials, dangerous deletion, database writes, deployment/restart, and production remote changes. Reduce false positives for discussion, read-only checks, and doc-only work. Record tuning notes in `docs/hook-tuning.md`.

Do not install or modify global Codex configuration unless the Human explicitly asks. If local hooks require trust review, state that they are hook-ready and need Codex trust before running.

## Branch Finish

When implementation is complete and the next step is commit, push, PR, merge, keep, discard, or cleanup, use `branch_finish`.

Before offering integration choices:

- run or cite required tests/checks;
- inspect `git status`, current branch, base branch, remote, and worktree state;
- summarize changed files and residual risk;
- preserve worktree state for PR feedback;
- require explicit confirmation before branch deletion, worktree removal, discard, or force cleanup.

Use `templates/branch-finish.md` and `scripts/branch-finish-check.ps1`.

## Context Survival

Use Codex built-in compaction and parent/child isolation. The repository defines what must survive compaction; it does not replace the internal compaction mechanism.

Before long handoff, compaction, or stopping mid-task, write a handoff snapshot from `templates/handoff.md`. Preserve current goal, user constraints, decisions, route/S-level, changed files, verification, unresolved risk, next step, forbidden actions, key commands, and server alias status.

Use `docs/context-compression-policy.md` and `docs/context-memory.md`.

## Non-Claims

This production harness does not promise universal productivity gains, pass-rate gains, token savings, deployment safety, database safety, or autonomous repair.

It improves route quality, scope control, verification honesty, high-risk escalation, and lightweight guardrails. Measure broader outcomes separately.
