# Evaluator Gate Card: gate hardening drill

## Header

```text
Gate Card ID: EVAL-P5-GATE-HARDENING-001
Evaluator ID: EVAL-P5-GATE-HARDENING
Task Instance Ref: examples/phase-5-gate-hardening-drill/task-instance.md
Pass Types: evidence-first, conditional-followup, synthesis-comparison
Created At: 2026-06-18
```

## Evidence-First Pass

```text
Pass Type: evidence-first
Decision: Conditional Go
Lane: conditional-followup
Summary: Conditional lane has enough evidence to proceed only after reload path follow-up.
Basis: P5-EV-003
Blocking Until Follow-Up: yes
```

```text
Pass Type: evidence-first
Decision: No-Go
Lane: no-go
Summary: No-Go lane lacks raw verification evidence and reload path for its claim.
Basis: P5-EV-004
Blocking: yes
Parent Override Allowed: no
```

```text
Pass Type: evidence-first
Decision: No-Go
Lane: authority-conflict
Summary: Signed scope and hypothetical dispatch scope disagree.
Basis: P5-EV-005
Required State: blocked: authority-conflict
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: Conditional Go
Lane: exhausted
Summary: Exhausted child report is valid evidence, but acceptance is conditional on parent not re-dispatching unchanged.
Basis: P5-EV-006
Blocking Until Parent Response Recorded: yes
```

## Conditional Follow-Up Pass

```text
Pass Type: conditional-followup
Decision: Go
Lane: conditional-followup
Summary: Reload path condition is satisfied by the child report.
Basis: P5-EV-003
Remaining Conditions: none for this lane
```

## Synthesis-Comparison Pass

```text
Pass Type: synthesis-comparison
Decision: Go
Summary: Parent Synthesis accurately represents resolved and blocked lanes and does not claim acceptance for No-Go, unresolved Conditional Go, authority conflict, or exhausted-child paths.
Basis: P5-EV-003, P5-EV-004, P5-EV-005, P5-EV-006, P5-EV-008
```

## Overall Gate Result

```text
Decision: Go for drill completeness
Accepted Task State Allowed: no for simulated blocking lanes
Reason: The drill demonstrates correct blocking behavior; it does not accept the negative lanes.
Conditions: none for the drill artifact; lane-level blockers remain documented.
Evidence Gaps: none for the drill artifact
```

Evaluator `No-Go` blocks the lane. Parent cannot reject or override it. `Conditional Go` requires a second lightweight Evaluator pass before acceptance. Evidence Index is append-only.
