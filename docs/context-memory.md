# Context And Memory

Agent chat context is useful but fragile. Important state should survive in files.

## Reload Order

When a new agent starts, reload:

```text
README.md
> AGENTS.md
> current task brief
> route policy
> verification report
> handoff snapshot
> chat memory
```

If chat conflicts with files, ask the Human or follow the authoritative file.

## What To Record

Record only what helps the next agent:

- selected route
- scope and non-goals
- files changed
- commands run
- verification result
- skipped checks
- reviewer findings
- residual risk
- next action

Do not store raw prompts, full transcripts, secrets, private payloads, or long command logs.

## Handoff Snapshot

Use `templates/handoff.md` when:

- context is getting long
- work pauses mid-task
- a child/reviewer is involved
- verification is incomplete
- the next action depends on local state

The handoff should be short but reloadable.

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
What route was selected?
What tools/capabilities were used?
What changed?
What verification passed?
What risk remains?
```

Keep eval-only metrics out of normal work unless the Human is explicitly running an evaluation.
