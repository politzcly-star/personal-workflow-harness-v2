# Evaluator Gate Card: context handoff rehearsal

## Header

```text
Gate Card ID: EVAL-P7-CONTEXT-HANDOFF-001
Evaluator ID: EVAL-P7-CONTEXT-HANDOFF
Task Instance Ref: examples/phase-7-context-handoff-rehearsal/task-instance.md
Pass Types: evidence-first, synthesis-comparison
Created At: 2026-06-18
```

## Inputs

```text
Input Artifacts:
- Human-signed North Star: task-instance.md P7-EV-001
- Dispatch Matrix: P7-EV-002
- Child Report: P7-EV-003
- Context Compression Snapshot: P7-EV-004
- Handoff Recovery Record: P7-EV-005
- Verification Outputs: child-report-context-handoff.md Verification section and final command outputs
- Evidence Index: P7-EV-001 through P7-EV-008
- Parent Synthesis: read only during synthesis-comparison
```

## Evidence-First Pass

```text
Pass Type: evidence-first
Decision: Go
Summary: Source artifacts show Context Compression Snapshot is mandatory, reload paths are present, child report and Evaluator finding are preserved, and chat memory is non-authority.
Basis: P7-EV-001, P7-EV-002, P7-EV-003, P7-EV-004, P7-EV-005
Blocking: none
```

## Synthesis-Comparison Pass

```text
Pass Type: synthesis-comparison
Decision: Go
Summary: Post-resume Parent Synthesis matches pre-handoff child report, snapshot, recovery record, and Evidence Index; it does not rely on chat memory.
Basis: P7-EV-003, P7-EV-004, P7-EV-005, P7-EV-006, P7-EV-007
Blocking: none
```

## Decision Rules

```text
No-Go:
- Missing reload path for omitted required detail.
- Dropped unresolved P0/P1, conflict, scope change, Evaluator finding, Conditional Go condition, or child-report: exhausted.
- Parent Synthesis uses chat memory instead of evidence.
- Parent assigns itself as generator or evaluator.
- Forbidden files or v1 repository are touched.

Conditional Go:
- Narrow missing reload path or citation can be added without scope expansion.
- Follow-up evaluator pass is required before acceptance.

Go:
- Snapshot, recovery record, child report, evaluator passes, and evidence-cited synthesis are complete.
```

## Overall Decision

```text
Decision: Go
Conditions: none
Evidence Gaps: none
Missing Reload Path Handling: No-Go
Dropped Unresolved Finding Handling: blocked: authority-conflict or No-Go
```

Evidence Index is append-only. Evaluator `No-Go` blocks the task. Parent cannot reject or override it. `Conditional Go` requires follow-up before acceptance.

