# Human Decision Recovery Record: evaluator dispute recovery drill

## Header

```text
Recovery Record ID: P8-HUMAN-RECOVERY-001
Task Instance Ref: examples/phase-8-evaluator-dispute-recovery-drill/task-instance.md
Evaluator Dispute Ref: examples/phase-8-evaluator-dispute-recovery-drill/evaluator-dispute-record.md
Human Decision Ref: examples/phase-8-evaluator-dispute-recovery-drill/human-decision.md
Created At: 2026-06-18
```

## Recovery Options

```text
Decision: Go
Meaning: Human decides the disputed blocker has been resolved or is acceptable.
Required Evidence: append a new human-decision Evidence ID; keep P8-EV-004 Evaluator finding intact.
```

```text
Decision: Reject
Meaning: Human rejects the task outcome or declines to proceed.
Required Evidence: append a new human-decision Evidence ID; task remains blocked or closes rejected.
```

```text
Decision: accepted-risk
Meaning: Human explicitly accepts a named unresolved risk.
Required Evidence: append a new human-decision Evidence ID with the risk name, reason, and timestamp.
```

```text
Decision: follow-up
Meaning: Human requests more child or evaluator work.
Required Evidence: append a new scope-change or human-decision Evidence ID; Parent must dispatch within new signed scope.
```

## Recovery Guardrails

```text
Evaluator Finding Rewrite Allowed: no
Evidence Index Rewrite Allowed: no
append-only Required: yes
Parent Override Allowed: no
fake Human acceptance Allowed: no
Chat Memory As Decision: invalid
```

## Blocking Conditions

```text
No-Go If:
- Human decision text is missing.
- Human decision is inferred from chat memory without explicit approval.
- accepted-risk does not name the risk.
- Evaluator finding is deleted or rewritten.
- Evaluator Dispute evidence is missing.
- Parent Synthesis claims acceptance without a Human decision Evidence ID.
```

