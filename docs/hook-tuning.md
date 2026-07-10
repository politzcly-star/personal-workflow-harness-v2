# Hook Tuning

Hooks are guardrails, not a general workflow engine.

Keep hard blocks for secret-file access, embedded credentials, destructive filesystem/git commands, database mutation, deployment/restart, and unapproved remote mutation.

Prefer no output for safe documentation edits and read-only work. Do not use hooks to inject repeated git status, enforce prose-shaped reports, or block compaction because a phrase is missing.

When a real task shows friction, record: date, event, safe/unsafe classification, false-positive status, decision, and a minimal reproduction fixture. Update `scripts/harness-self-test.ps1` when the behavior changes.
# Hook Tuning

Hooks are quiet for safe read-only work and ordinary allowed patches. With an active frozen Goal contract, exact patch targets inside its allowed list proceed; out-of-scope, contract, Hook, agent, and policy modifications are denied. Ambiguous shell mutation is denied instead of being inferred safe.

`PreCompact` and `PostCompact` are deliberately non-blocking and do not inspect transcripts. A compact/resume SessionStart may expose only a validated goal id, epoch, contract pointer, and capsule pointer. Invalid, stale, oversized, malformed, or secret-like state is ignored.

Hard blocks remain independent of any Goal contract: secrets, embedded credentials, destructive filesystem/Git operations, database mutation, deployment/restart, and unapproved remote mutation. Hooks are guardrails, not a sandbox; scope verification remains required.
