# Phase 7 Context Handoff Guide

Phase 7 keeps v2 as a markdown control plane. It does not add runner, CI, Docker, browser automation, source code, production access, secrets, paid actions, push, PR, or v1 repository changes.

## Purpose

This guide rehearses context compression and handoff recovery so a parent thread can resume from artifacts instead of chat memory.

## Mandatory Snapshot Triggers

Create a Context Compression Snapshot before handoff or resume when any of these exist:

- active child reports
- Evaluator findings
- unresolved P0/P1 findings
- conflicts or scope changes
- Conditional Go conditions
- child-report: exhausted
- parent uncertainty about remaining context

If there is doubt, compression is mandatory. Parent cannot skip a Context Compression Snapshot by claiming current chat context is enough.

## Snapshot Requirements

The snapshot must preserve the authoritative state or provide a full reload path for every omitted detail.

Required retained or reloadable details:

- Human-signed North Star
- Task Instance state
- Dispatch Matrix
- Child Reports and verification outputs
- Evaluator findings
- Conditional Go conditions
- conflicts, scope changes, and unresolved P0/P1
- child-report: exhausted
- Parent Synthesis draft or path
- Human Decision state

Missing reload path or a dropped unresolved finding blocks acceptance. The blocking state is `No-Go` when the evidence gap is reviewable, or `blocked: authority-conflict` when authoritative artifacts disagree.

## Handoff Recovery

The resumed parent reloads artifacts in this order:

```text
Human-signed North Star
> Task Instance
> Evaluator Decision
> Context Compression Snapshot
> Child Reports / Evidence Refs
> Handoff Recovery Record
> Parent Synthesis
> Chat Context
```

Chat context can help locate artifacts, but never overrides them.

## Evaluator Review

Evaluator must perform `evidence-first` using raw artifacts, snapshot, recovery record, child reports, verification outputs, and Evidence Index before reading Parent Synthesis.

Evaluator then performs `synthesis-comparison` to compare post-resume Parent Synthesis against pre-handoff evidence.

Evaluator outputs `Go`, `Conditional Go`, or `No-Go`. Parent cannot reject `No-Go` or accept unresolved `Conditional Go`.

Parent cannot assign itself.

