# Production Harness Starter Instructions

This file is the default instruction layer for agents working in projects that adopt this harness.

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

Before editing, classify the task:

- clear small edit -> `lightweight_fix`
- bug, failing test, regression -> `audit_fix`
- unfamiliar cross-file area -> `structural_localization`
- vague feature -> `feature_discovery`
- mid-size feature -> `feature_plan`
- docs/API uncertainty -> `docs_assisted`
- boundary/security/permission -> `review_gated`
- deployment/config -> `deployment_route`
- database/schema/migration -> `database_route`
- formal/high-risk delivery -> `lab_ai_delivery`

Use `docs/route-policy.md` for details.

## Capability Defaults

- Prefer `rg` for fast literal search.
- Use CodeGraph/MCP for cross-file relationships, callers/callees, route ownership, and impact radius.
- Use `code-audit-fix` for bugs, failing verification, regressions, suspicious behavior, and quick local repair.
- Use official docs for current API/platform uncertainty.
- Use reviewer only when risk or hidden acceptance justifies it.
- Use `lab-ai-delivery` only for formal modules, high-risk tasks, or required evaluator/Gate Report workflows.

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

## Context Survival

Before long handoff, compaction, or stopping mid-task, write a handoff snapshot from `templates/handoff.md`.

The next agent should be able to continue from files without relying on chat memory.

## Non-Claims

This production harness does not promise universal productivity gains, pass-rate gains, token savings, or autonomous repair.

It improves route quality, scope control, verification honesty, and high-risk escalation. Measure broader outcomes separately.
