# Evaluator Gate Card: dispatch discipline rehearsal

## Header

```text
Gate Card ID: EVAL-P6-DISPATCH-DISCIPLINE-001
Evaluator ID: EVAL-P6-DISPATCH-DISCIPLINE
Task Instance Ref: examples/phase-6-dispatch-discipline-rehearsal/task-instance.md
Pass Types: evidence-first, synthesis-comparison
Created At: 2026-06-18
```

## Inputs

```text
Input Artifacts:
- Human-signed North Star: task-instance.md P6-EV-001
- Dispatch Matrix: P6-EV-002
- Child Report: P6-EV-003
- Verification Outputs: child-report-dispatch-discipline.md Verification section and final command outputs
- Evidence Index: P6-EV-001 through P6-EV-006
- Parent Synthesis: read only during synthesis-comparison
```

## Evidence-First Pass

```text
Pass Type: evidence-first
Decision: Go
Summary: Source artifacts show Parent did not assign itself, one child generator owns docs-only implementation, evaluator role is separate, and the Child Report records verification and evidence refs.
Basis: P6-EV-001, P6-EV-002, P6-EV-003
Blocking: none
```

## Synthesis-Comparison Pass

```text
Pass Type: synthesis-comparison
Decision: Go
Summary: Parent Synthesis claims match the Child Report and Evidence Index, and it does not rely on chat memory.
Basis: P6-EV-003, P6-EV-004, P6-EV-005
Blocking: none
```

## Decision Rules

```text
No-Go:
- Parent assigns itself as generator or evaluator.
- Child Report is missing verification or evidence refs.
- Parent Synthesis uses chat memory instead of evidence.
- Forbidden files or v1 repository are touched.

Conditional Go:
- Narrow missing evidence can be added without scope expansion.
- Follow-up evaluator pass is required before acceptance.

Go:
- Child report, evaluator passes, scope boundaries, and evidence-cited synthesis are complete.
```

## Overall Decision

```text
Decision: Go
Conditions: none
Evidence Gaps: none
Parent-Direct Attempt Handling: blocked: authority-conflict unless explicit Human accepted-risk exists
```

Evidence Index is append-only. Evaluator `No-Go` blocks the task. Parent cannot reject or override it. `Conditional Go` requires follow-up before acceptance.
