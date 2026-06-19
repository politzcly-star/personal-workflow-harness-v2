# Evaluator Gate Card: release gate drill

## Header

```text
Gate Card ID: EVAL-P10-RELEASE-GATE-001
Evaluator ID: EVAL-P10-RELEASE-GATE
Task Instance Ref: examples/phase-10-release-gate-drill/task-instance.md
Pass Types: evidence-first, synthesis-comparison, release-followup
Created At: 2026-06-18
```

## Inputs

```text
Input Artifacts:
- Human-signed North Star: task-instance.md P10-EV-001
- Dispatch Matrix: P10-EV-002
- Child Report: P10-EV-003
- Release Gate Checklist: P10-EV-004, P10-EV-008, P10-EV-009
- Parent Synthesis: read only during synthesis-comparison
- Human Decision Placeholder: P10-EV-007
- Evidence Index: P10-EV-001 through P10-EV-009
```

## Evidence-First Pass

```text
Pass Type: evidence-first
Decision: No-Go
Lane: dirty staged files
Summary: dirty staged files block release gate because release payload cannot be trusted.
Basis: P10-EV-004, P10-EV-005
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go
Lane: missing release evidence
Summary: missing release evidence blocks release gate because remote-sync readiness cannot be reconstructed.
Basis: P10-EV-004, P10-EV-005
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go
Lane: fake push approval
Summary: fake push approval blocks release gate because local commit acceptance is not push/PR authorization.
Basis: P10-EV-007, P10-EV-008
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go
Lane: unreviewed scope change
Summary: unreviewed scope change blocks release gate until a new scope evidence ref and Human decision exist.
Basis: P10-EV-004, P10-EV-005, P10-EV-008
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go
Lane: unexpected files
Summary: unexpected files block release gate until classified and either removed or accepted through evidence-backed scope change.
Basis: P10-EV-004, P10-EV-005
Blocking: yes
```

## Synthesis-Comparison Pass

```text
Pass Type: synthesis-comparison
Decision: Go for drill completeness
Summary: Parent Synthesis reconstructs Phase 10 release readiness from P10 Evidence IDs and does not rely on chat memory.
Basis: P10-EV-001, P10-EV-002, P10-EV-003, P10-EV-004, P10-EV-005, P10-EV-006, P10-EV-007, P10-EV-008, P10-EV-009
Blocking: none for drill completeness
```

## Overall Gate Result

```text
Decision: Go for artifact completeness
Accepted Task State Allowed: no until Human Decision
Release Action Allowed: no
Reason: The drill demonstrates release gate blockers and remote-sync authorization separation without performing push or PR.
Conditions: Future remote-sync requires separate Human Go with evidence ref and clean release gate checklist.
Evidence Gaps: none for the drill artifact
```

Evaluator `No-Go` blocks release lanes. Parent cannot reject or override it. A future push or PR requires separate Human Go and cited release evidence.
