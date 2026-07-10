# Execution And Review Protocol

The default `gpt-5.6-terra` Medium root owns daily work, acceptance, progress, and final reporting. For Goal mode, the Human may first use Sol to freeze scope and acceptance; the active root then delegates named roles only when they add evidence or isolate implementation work.

## Default

- S0/S1: root works directly.
- Clear S2: root works directly unless a bounded child materially improves throughput, isolation, or risk.
- S3: root freezes scope, spawns `terra_worker`, consumes its compact report, then spawns read-only `luna_verifier`.
- S4: root repeats the S3 loop one milestone at a time.

Do not ask the Human to switch models between phases. Do not create a child merely because a task is long, and do not run parallel writers by default.

## Goal-Mode Loop

```text
root freezes scope and acceptance
> terra_worker implements and verifies locally
> luna_verifier returns GO / CONDITIONAL GO / NO-GO
> root accepts or sends narrow findings back to terra_worker
> root reports final evidence
```

The root continues this loop overnight without routine phase confirmations. It stops only for a real authority, safety, scope, or verification blocker.

## Handoff Contract

A child receives only the goal, non-goals, allowed/forbidden files, acceptance checks, stop conditions, and directly relevant context. It returns changed files, checks, skipped checks, assumptions, residual risk, and next action.

Use `templates/child-task.md` and `templates/child-report.md` only when a child is actually used. `luna_verifier` remains read-only and receives the final diff plus compact evidence, not full transcripts.

## Optional External Executor

ClaudeCode, Qwen, and similar tools remain disabled unless the Human explicitly enables one named low-final-decision phase. External output never owns architecture or final acceptance.
