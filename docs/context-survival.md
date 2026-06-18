# Context Survival

v2 assumes that long chat context is unreliable. Parent Agent must preserve task direction through artifacts, not memory.

## Recovery Sources

When resuming a task, reload in this order:

```text
Human-signed North Star
> Task State
> Evaluator Decision
> Parent Synthesis
> Child Reports / Evidence Refs
> Chat Context
```

Practical reload path:

1. Human-signed North Star in the task's Task State instance.
2. Full Task State.
3. Dispatch Matrix.
4. Child Reports and verification outputs through Evidence Index refs.
5. Evaluator Gate Card records.
6. Parent Synthesis.

Chat context can explain intent, but never overrides artifacts. Chat context is never an authority source.

## Context Compression Triggers

Create a Context Compression Snapshot when any condition is met:

- active child reports >= 3
- child conflict appears
- Parent is about to handoff or resume
- Parent thinks context may be insufficient; if there is doubt, compression is required
- tool or model context exceeds the environment's recommended threshold

Parent cannot skip compression by claiming the context is still enough after doubt appears, and cannot skip it for "评估后足够" or similar reasoning.

## Snapshot Required Content

```text
Snapshot ID:
Task ID:
North Star Version:
Task State:
Human Signoff:
Active Children:
Completed Children:
Evaluator State:
Child Findings:
Conflicts:
Conditional Go Conditions:
Evidence Index Summary:
Omitted Details:
Reload Paths:
Next Action:
Created At:
Created By:
```

## What Cannot Be Dropped

A snapshot must not drop:

- unresolved P0/P1
- conflict
- scope change
- Evaluator finding
- Conditional Go condition
- child-report: exhausted
- Human decision
- authority conflict

If Evaluator has not completed the current review, the snapshot must preserve all child reports in full or provide exact reload paths.

Omitted details must always include reload paths. If there is no reload path, the detail must remain in the snapshot.

## Reload Path Format

Omitted details must include a concrete reload path:

- child report full text: original report file path
- diff content: commit hash or exact diff command
- evidence refs: artifact path plus Evidence ID
- synthesis draft: version number or file path
- verification output: command and output file/path if externalized
- child test result: Child Report path plus Evidence ID

## Handoff

Handoff is a recovery entry point, not an authority source.

Handoff must point to:

- Task State
- Dispatch Matrix
- Child Reports with verification evidence
- latest Context Compression Snapshot
- Parent Synthesis
- Evaluator Decision
- Gate or verification evidence

If handoff conflicts with Task State or Evaluator Decision, use the authoritative artifact and mark `blocked: authority-conflict`.

## Conflict Handling

When child reports conflict:

1. Record conflict in Evidence Index.
2. Ask Evaluator to review both sides.
3. If Evaluator resolves it, Parent records the resolution with evidence refs.
4. If conflict remains, task becomes `blocked: needs-human-decision`.

Parent cannot skip Evaluator and cannot silently pick one child report.

## Phase 2 Control Plane Survival

Phase 2 survives context loss through the paper artifact chain:

```text
Human-signed North Star
> Dispatch Matrix
> Child Report
> Evaluator Gate Card
> Parent Synthesis
> Human Decision
```

Parent Synthesis must be rebuildable from evidence refs. Child verification and test results must be preserved in Child Reports, and Evidence Index remains append-only across compression, handoff, and resume.
