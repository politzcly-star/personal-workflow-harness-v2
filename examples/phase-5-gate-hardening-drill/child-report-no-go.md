# Child Report: No-Go Lane

## Header

```text
Child ID: C-P5-NOGO
Role: generator
Status: complete
Task Instance Ref: examples/phase-5-gate-hardening-drill/task-instance.md
Evidence Refs: P5-EV-004
```

## No-Go Evidence

```text
Finding: Required verification evidence is missing for this simulated lane.
Missing Evidence: no raw verification output or reload path for the claimed check.
Evaluator Expected Decision: No-Go
Parent Allowed Response: block the lane or record Evaluator Dispute for Human decision.
Parent Forbidden Response: reject Evaluator No-Go, mark accepted, or rewrite evidence to hide the gap.
```

## Blocking State

```text
Lane State: blocked
Acceptance Allowed: no
Reason: No-Go blocks until new evidence is created under signed scope and reviewed again.
```
