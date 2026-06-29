# Context And Memory

Agent chat context is useful but fragile. Important state should survive in files.

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

## What To Record

Record only what helps the next agent:

- selected route and four-layer tier;
- scope and non-goals;
- parent/child decision, including direct-execution exception if used;
- files changed;
- commands run;
- verification result;
- skipped checks;
- reviewer findings;
- residual risk;
- next action.

Do not store raw prompts, full transcripts, secrets, private payloads, large stdout/stderr, raw production logs, private screenshots, database dumps, or long source dumps.

## Parent And Child Memory

Parent should write or preserve:

- task brief;
- child task;
- child report;
- final verification report;
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
What layer was used?
What capabilities were considered?
What capabilities were used or skipped?
What changed?
What verification passed?
What risk remains?
```

Keep eval-only metrics out of normal work unless the Human is explicitly running an evaluation.

## One-Week Pilot Memory

During v2.1 freeze, use `docs/production-pilot.md` for weekly learning. Do not turn pilot notes into immediate harness churn unless a hook blocks safe work or a safety issue appears.
