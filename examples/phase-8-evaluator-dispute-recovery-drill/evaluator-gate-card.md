# Evaluator Gate Card: evaluator dispute recovery drill

## Header

```text
Gate Card ID: EVAL-P8-EVALUATOR-DISPUTE-001
Evaluator ID: EVAL-P8-EVALUATOR-DISPUTE
Task Instance Ref: examples/phase-8-evaluator-dispute-recovery-drill/task-instance.md
Pass Types: evidence-first, synthesis-comparison, human-decision-followup
Created At: 2026-06-18
```

## Inputs

```text
Input Artifacts:
- Human-signed North Star: task-instance.md P8-EV-001
- Dispatch Matrix: P8-EV-002
- Child Report: P8-EV-003
- Verification Outputs: child-report-evaluator-dispute.md Verification section
- Evaluator Dispute Record: P8-EV-005
- Human Decision Recovery Record: P8-EV-006
- Evidence Index: P8-EV-001 through P8-EV-008
- Parent Synthesis: read only during synthesis-comparison
```

## Evidence-First Pass

```text
Pass Type: evidence-first
Decision: No-Go
Lane: simulated-evaluator-blocker
Summary: Simulated evidence shows Parent disagrees with an Evaluator finding, so acceptance is blocked until the disagreement is recorded as Evaluator Dispute and routed to Human decision.
Basis: P8-EV-004, P8-EV-005
Blocking: yes
Parent Override Allowed: no
Required State: blocked: needs-human-decision
```

```text
Pass Type: evidence-first
Decision: Conditional Go
Lane: recovery-followup
Summary: A future Human recovery decision can unblock only if it appends a new Evidence Index entry and does not rewrite this No-Go finding.
Basis: P8-EV-006
Blocking Until Follow-Up: yes
```

## Synthesis-Comparison Pass

```text
Pass Type: synthesis-comparison
Decision: Go for drill completeness
Summary: Parent Synthesis distinguishes fact, evaluator finding, dispute, and human decision records, and it does not claim the simulated No-Go lane is accepted.
Basis: P8-EV-003, P8-EV-004, P8-EV-005, P8-EV-006, P8-EV-007
Blocking: none for drill completeness
```

## Human Decision Follow-Up Rule

```text
Pass Type: human-decision-followup
Decision Set: Go, Conditional Go, No-Go
Purpose: Verify that a future Human decision is explicit, cited, append-only, and does not overwrite Evaluator findings.
No-Go If: fake Human acceptance; overwritten Evaluator finding; missing dispute evidence; missing accepted-risk reason; unresolved follow-up.
```

## Overall Gate Result

```text
Decision: Go for artifact completeness
Accepted Task State Allowed: no for simulated blocking lane
Reason: The drill demonstrates correct blocking and recovery behavior; it does not accept the simulated No-Go lane.
Conditions: Future Human decision recovery must be recorded before any blocked lane can move out of blocked: needs-human-decision.
Evidence Gaps: none for the drill artifact
```

Evaluator `No-Go` blocks the lane. Parent cannot reject or override it. `Conditional Go` requires follow-up before acceptance. Evidence Index is append-only.

