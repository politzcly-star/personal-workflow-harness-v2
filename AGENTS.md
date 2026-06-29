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

## Parent-router / Child-executor

Default: the parent thread is a router and acceptor, not the main implementer.

Parent direct execution is allowed only when all of these are true:

- the task is tiny or obvious single-file work;
- the target file/area is already known;
- there is no cross-file behavior, new feature, deployment, database, server, auth, permission, or public API risk;
- focused verification is obvious.

For every other task:

- Parent must create a scoped child task before implementation.
- Child executor performs implementation or investigation.
- Child returns `templates/child-report.md`.
- Parent reads the report, inspects diff/scope, runs or verifies checks, and writes the final answer.
- High-risk or hidden acceptance tasks get reviewer after the child report.

If the current Codex surface cannot create a child/subagent/thread, the parent must state that limitation and ask for explicit permission to execute in-parent, or ask the Human to create/authorize a child thread. Do not silently collapse non-trivial work into parent execution.

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

## Verification-Before-Completion

Do not claim completion until verification is done or a narrow not-verified reason is recorded.

Minimum report:

- route selected
- files changed
- commands/checks run
- result
- skipped checks and reason
- residual risk

Use `templates/verification-report.md`.

## Guardrails

Do not read, print, store, or commit secrets.

Do not run production deployment, database writes, destructive commands, credentialed browser actions, paid external actions, or remote server changes unless the Human explicitly approves a fresh objective and the route policy allows it.

For deployment and database work, Codex should normally prepare checklists and consume redacted operator evidence rather than execute live actions.

Read-only server inspection is allowed only through `server_inspection` when the Human gives a fresh objective and access is already configured without exposing raw credentials. Acceptable access patterns include SSH config host aliases, SSH agent, short-lived operator-prepared sessions, or platform CLIs that do not print or embed secrets. Do not read passwords from screenshots, paste passwords into commands, use `sshpass`, or write credentials into terminal history, files, prompts, hooks, or reports.

## New Project Onboarding

On first use in a new project:

1. Create or update `templates/project-profile.md` into the project-specific profile location.
2. Try CodeGraph / structural indexing.
3. If CodeGraph is unavailable, record fallback: `rg` + file tree + test entry points + manual dependency/call relationship notes.
4. Record parent-router / child-executor availability and default to child execution for non-trivial work.
5. Check whether the Human supplied or documented a server SSH alias for the project.
6. If a server alias exists, run `scripts/server-inspection-check.ps1 -HostAlias <alias>` and use `server_inspection` for read-only queries.
7. If no alias exists, ask the Human to configure a Windows SSH config alias once; do not ask for raw passwords.
8. Capture package manager, start/test/build commands, ports, main directories, forbidden areas, database boundary, deployment boundary, server alias status, parent/child availability, CodeGraph status, common verification commands, and risk boundaries.

## Hook-ready Layer

This harness may include repo-local Codex hooks under `.codex/hooks.json` and `.codex/hooks/`. Hooks are a guardrail and memory layer, not a complete sandbox.

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

Before long handoff, compaction, or stopping mid-task, write a handoff snapshot from `templates/handoff.md`.

The next agent should be able to continue from files without relying on chat memory.

## Non-Claims

This production harness does not promise universal productivity gains, pass-rate gains, token savings, deployment safety, database safety, or autonomous repair.

It improves route quality, scope control, verification honesty, high-risk escalation, and lightweight guardrails. Measure broader outcomes separately.
