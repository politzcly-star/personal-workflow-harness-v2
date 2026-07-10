# Project Harness Addendum

Merge this managed block into the target project's root `AGENTS.md` after project-specific rules.

```text
Use the smallest safe process that produces evidence. The default `gpt-5.6-terra` Medium root handles daily work and remains the final acceptor. The normal Human loop is requirement, one `GO` for route/acceptance/authorization, and final evidence review. Before Goal mode the Human may use Sol once to freeze the contract; after Goal starts, do not ask for phase-by-phase model switching or confirmation.

Classify S0-S4 before editing:
- S0 discussion/read-only: root answers directly.
- S1 narrow change: root edits and runs a focused check.
- S2 bounded work: root stays direct when exploration/logs/retries are cheap; otherwise it may use `terra_worker` for compact evidence and context isolation. Reuse a bounded worker only for consecutive same-subsystem work.
- S3 hidden acceptance or boundary risk: root freezes scope, delegates implementation to `terra_worker`, then delegates read-only review to `luna_verifier`.
- S4 milestone work: root repeats the S3 loop one milestone at a time.

For Goal mode, continue through implementation, verification, focused repair, and required review without pausing for routine model changes. Stop only for a material contract change, out-of-scope action, protected authority, unsafe verification, or the same blocker after three focused repairs. Store only bounded non-secret incremental Goal state under ignored `.codex/harness-state/`; never parse transcripts as durable state.

Use a named route only when it changes guardrails or evidence. Do not require a separate layer label for routine work. Do not spawn agents for clear S0-S2 tasks, use recursive delegation, or run parallel write agents by default.

Before completion, report changed files, relevant checks, skipped checks with reason, and residual risk. Keep strict boundaries for secrets, destructive actions, database mutation, deployment/restart, and unapproved remote mutation.

Optional external executors require explicit Human activation for one named low-final-decision phase and never own architecture or final acceptance.
```
