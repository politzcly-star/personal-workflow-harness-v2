# Evaluator Gate Card: evidence integrity drill

## Header

```text
Gate Card ID: EVAL-P9-EVIDENCE-INTEGRITY-001
Evaluator ID: EVAL-P9-EVIDENCE-INTEGRITY
Task Instance Ref: examples/phase-9-evidence-integrity-drill/task-instance.md
Pass Types: evidence-first, synthesis-comparison, evidence-recovery-followup
Created At: 2026-06-18
```

## Inputs

```text
Input Artifacts:
- Human-signed North Star: task-instance.md P9-EV-001
- Dispatch Matrix: P9-EV-002
- Child Report: P9-EV-003
- Evidence Audit Record: P9-EV-004, P9-EV-009
- Scope Change Record: P9-EV-005
- Parent Synthesis: read only during synthesis-comparison
- Human Decision Placeholder: P9-EV-008, P9-EV-010
- Evidence Index: P9-EV-001 through P9-EV-010
```

## Evidence-First Pass

```text
Pass Type: evidence-first
Decision: No-Go
Lane: duplicate Evidence ID
Summary: duplicate Evidence ID blocks acceptance because artifact history cannot be reconstructed reliably.
Basis: P9-EV-004, P9-EV-006
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go
Lane: missing evidence refs
Summary: missing evidence refs blocks acceptance because Parent Synthesis cannot be audited from artifacts.
Basis: P9-EV-004, P9-EV-006
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go
Lane: overwritten evaluator finding
Summary: overwritten evaluator finding blocks acceptance because Parent cannot rewrite or weaken Evaluator findings.
Basis: P9-EV-004, P9-EV-006, P9-EV-009
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go
Lane: uncited scope-change
Summary: uncited scope-change blocks acceptance and must route to blocked: needs-human-decision if boundaries change.
Basis: P9-EV-005, P9-EV-006
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: Conditional Go
Lane: evidence-recovery-followup
Summary: Recovery can proceed only by appending new correction evidence, new scope-change evidence, new evaluator-finding evidence, or explicit Human decision evidence.
Basis: P9-EV-004, P9-EV-005, P9-EV-009, P9-EV-010
Blocking Until Follow-Up: yes
```

## Synthesis-Comparison Pass

```text
Pass Type: synthesis-comparison
Decision: Go for drill completeness
Summary: Parent Synthesis reconstructs Phase 9 task history from P9 Evidence IDs and does not rely on chat memory.
Basis: P9-EV-001, P9-EV-002, P9-EV-003, P9-EV-004, P9-EV-005, P9-EV-006, P9-EV-007, P9-EV-008, P9-EV-009, P9-EV-010
Blocking: none for drill completeness
```

## Overall Gate Result

```text
Decision: Go for artifact completeness
Accepted Task State Allowed: no until Human Decision
Reason: The drill demonstrates append-only audit, scope-change evidence, and audit blocker recovery without accepting any simulated No-Go lane.
Conditions: Future Human Go must be explicit and appended to the Evidence Index before local commit.
Evidence Gaps: none for the drill artifact
```

Evaluator `No-Go` blocks the lane. Parent cannot reject or override it. Evidence Index is append-only. A future accepted-risk must be explicitly named by Human and cited by Evidence ID.

