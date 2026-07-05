# Context And Memory

Agent chat context is useful but fragile. Important state should survive in files, while reloadable detail should stay in the repository instead of being pasted into handoffs.

Use this with `docs/context-compression-policy.md`.

## Reload Order

When a new agent starts, reload:

```text
README.md
> AGENTS.md
> templates/project-profile.md or project profile
> current task brief
> route policy
> verification report
> handoff snapshot
> chat memory
```

If chat conflicts with files, follow the authoritative file or ask the Human when the conflict affects safety.

Within the same thread, do not mechanically re-read unchanged durable files. Confirm they are unchanged or reload only the relevant section when that is enough.

## What To Record

Record only what helps the next agent:

- current goal;
- selected route, S-level, and four-layer tier;
- scope and non-goals;
- user constraints that matter;
- parent/child/reviewer decision;
- decisions already made;
- files changed;
- commands run;
- verification result;
- skipped checks and reason;
- reviewer findings;
- residual risk;
- next action;
- forbidden actions;
- server alias status when relevant.

Do not store raw prompts, full transcripts, secrets, private payloads, large stdout/stderr, raw production logs, private screenshots, database dumps, or long source dumps.

## Parent And Child Memory

Parent should write or preserve:

- task brief when needed;
- child task when used;
- child report when used;
- final verification report when S2+ or risk requires it;
- risk review when applicable;
- handoff snapshot if context is long.

Child should report:

- assigned goal;
- allowed/forbidden files;
- files changed;
- checks run and result;
- checks skipped and reason;
- risks and assumptions;
- next recommended action.

Use `templates/child-task.md` and `templates/child-report.md`.

## Handoff Snapshot

Use `templates/handoff.md` when:

- context is getting long;
- work pauses mid-task;
- a child/reviewer is involved;
- verification is incomplete;
- the next action depends on local state;
- `PreCompact` fires.

The handoff should be short but reloadable. It is the state anchor before compaction, not a transcript dump.

## Evidence References

Prefer references over pasted bulk output:

```text
command:
exit_code:
summary:
artifact_path:
```

For code changes, cite file paths and the verification command. For deployment/database work, cite redacted operator evidence.

## Lightweight Trace

Normal production traces should answer:

```text
What task was this?
What route and S-level were selected?
What layer was used?
What capabilities were considered?
What capabilities were used or skipped?
What changed?
What verification passed?
What risk remains?
```

Keep evaluation-only metrics, heavy traces, and cost fields out of normal production work unless the Human is explicitly running an evaluation in a separate evaluation project.
