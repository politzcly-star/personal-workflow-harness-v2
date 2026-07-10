# Context Compression Policy

Use built-in compaction and concise handoff state; this harness does not replace the platform compactor. For an active Goal, checkpoint a bounded incremental Context Capsule at decision boundaries, before long verification, after a changed repair diagnosis, before independent review, and before pausing.

Before pausing a long or risky task, preserve:

- goal and constraints;
- S-level/route when relevant;
- decisions and allowed/forbidden scope;
- changed files and verification evidence;
- open risks, key commands, and next action.

Link repository artifacts instead of pasting them. Store the frozen contract hash, context epoch, changed-since summary, hot files/symbols, checks, risks, and next action in ignored `.codex/harness-state/`. On compact/resume, inject only a safe capsule pointer and minimum contract context. Missing, malformed, stale, oversized, or secret-like state is ignored with a concise warning; do not parse `transcript_path`.

Use a long-lived worker only while its same-subsystem context remains relevant. Search, builds, test logs, and retry noise belong in a bounded worker; durable architecture decisions remain with the root.
