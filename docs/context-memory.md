# Context Memory

Reload durable state in this order when needed:

```text
AGENTS.md
> project profile
> current task packet or brief
> relevant route or model policy
> latest evidence and handoff
```

Within one task, reload only sections that changed or affect the next decision.

Preserve: goal, S-level/route when relevant, decisions, scope, changed files, verification, skipped checks, residual risk, forbidden actions, and next step.

Do not preserve transcripts, repeated logs, source dumps, secrets, private payloads, database dumps, or browser/private data. Optional external-executor state belongs in its own adapter report unless that mode is active.
