# Context Compression Policy

Use Codex's built-in compaction plus parent/child thread isolation. This repository does not replace Codex compaction and does not connect external compression tooling into production v2.

The harness defines what must survive compaction and handoff.

## Preserve

Keep the compact state focused on what a new agent cannot safely infer:

- current goal;
- user's real constraints and non-goals;
- decisions already made;
- selected route, S-level, and layer;
- parent/child/reviewer state;
- files changed;
- verification commands and results;
- skipped checks and reasons;
- unresolved risks;
- next step;
- forbidden actions;
- key commands;
- server alias status;
- database/deployment/secret boundary status.

## Compress Or Discard

Do not preserve noise:

- repeated logs;
- full command output when a summary is enough;
- stale exploration branches;
- failed attempts with no follow-up value;
- source details that can be reloaded from files;
- raw production logs;
- secrets, private payloads, database dumps, private screenshots.

## Reloadable From Files

These can be re-read instead of copied into context:

- file contents;
- `git diff`;
- test logs;
- `README.md`;
- `AGENTS.md`;
- `docs/project-profile.md` or project profile;
- route docs;
- templates.

## Handoff Snapshot

`templates/handoff.md` is the human-readable state anchor before compaction, interruption, or handoff.

Write a handoff when:

- context is getting long;
- `PreCompact` fires;
- work pauses mid-task;
- a child/reviewer is involved;
- verification is incomplete;
- the next step depends on local state.

## PreCompact Hook

The PreCompact hook is a reminder/check, not a normal development blocker.

It may block only when the current payload clearly indicates S3/S4 or high-risk work and no handoff/verification state is present. Otherwise it should warn and let normal work continue.
