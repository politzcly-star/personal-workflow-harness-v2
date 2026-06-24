# Install, Hooks, And Upgrade

This harness works as plain Markdown. Hook integration is optional.

## Install Into A New Project

Copy these files:

```text
README.md
AGENTS.md
docs/
templates/
```

Then ask the agent:

```text
Read README.md and AGENTS.md. Use this production harness for the next task.
Route first, verify before completion, and escalate only when risk requires it.
```

## Adapt Into An Existing Project

1. Keep the project's existing `AGENTS.md` or rules as highest local authority.
2. Merge this harness into a section called "Production Harness".
3. Keep project-specific commands, tests, ports, and deployment rules in the project repo.
4. Remove eval-only examples that do not help daily work.
5. Add one task brief and one verification report for the first real task.

## Optional Hook Lifecycle

If your environment supports hooks, these are useful lifecycle points:

```text
SessionStart
  Load README, AGENTS.md, route policy, current task brief.

PreToolUse
  Block secret reads, unsafe production/db commands, destructive actions,
  and unapproved browser/profile access.

PostToolUse
  Record changed files, command result summary, warnings, and evidence refs.

PreCompact
  Write a handoff snapshot so the next agent can continue from files.

Stop
  Require verification report or allowed not-verified reason.
```

Hooks should enforce safety and memory. They should not make every task heavy.

## Health Check

Run this quick check after install:

```text
README exists
AGENTS.md exists
docs/route-policy.md exists
docs/capability-policy.md exists
docs/verification-and-guardrails.md exists
templates/task-brief.md exists
templates/verification-report.md exists
no secrets committed
```

## Upgrade Policy

Keep upgrades boring:

1. Read the current README and AGENTS.md.
2. Compare route policy changes.
3. Preserve project-specific commands and safety rules.
4. Do not overwrite local secrets or profiles.
5. Run the health check.
6. Commit with a clear message.

## Versioning Suggestion

Use simple versions:

```text
v0.1 route policy
v0.2 verification reports
v0.3 optional hooks
v0.4 project-specific profiles
```

Avoid mixing eval experiments into production harness versions.
