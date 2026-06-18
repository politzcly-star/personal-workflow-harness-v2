# Task Instance Template

This template is the fillable Phase 2 task instance derived from `templates/task-state.md`.
It is a paper control-plane artifact, not an automation runner.

## Instance Header

```text
Task ID:
Task Title:
Parent Thread:
North Star Version:
Current State: proposed | signed | dispatch_ready | running | review_ready | blocked | blocked: needs-human-signoff | blocked: needs-human-decision | blocked: authority-conflict | accepted | rejected
Blocked Reason:
Next Action:
Last Updated:
```

## North Star Contract

Human-signed North Star is the highest task authority.

```text
Intent:
Non-goals:
Acceptance Criteria:
Quality Bar:
Forbidden Outcomes:
Allowed Changes:
Forbidden Changes:
Human GO Required For:
```

## Human Signoff

```text
Human Signoff: pending | signed
Confirmation Text:
Confirmed At:
Recorded By:
```

Rules:

- Parent may draft the North Star but cannot mark it signed without explicit Human confirmation.
- Without valid signoff, implementation cannot start.
- Missing signoff means `proposed` or `blocked: needs-human-signoff`.

## Runtime Boundaries

```yaml
ports: []
databases: []
network: []
secrets: []
production: false
browser_state: []
external_paid_actions: false
```

## Control Plane Refs

```text
Dispatch Matrix Ref:
Parent Synthesis Ref:
Evaluator Gate Card Refs:
Context Snapshot Refs:
```

## Children

```text
Active Children:
- Child ID:
  Role: planner | researcher | generator | evaluator
  Goal:
  Dispatch Row Ref:
  Report Expected At:

Completed Children:
- Child ID:
  Status: complete | blocked | exhausted | failed
  Report Ref:
  Evidence Refs:
```

Child test and verification results must be written into the Child Report. Parent must not replace verification evidence with chat memory.

## Evaluator State

```text
Evaluator Assigned:
Current Pass: none | evidence-first | synthesis-comparison | conditional-followup
Decision: PENDING | Go | Conditional Go | No-Go
Decision Ref:
Dispute: NONE | blocked: needs-human-decision
```

Rules:

- Evaluator `No-Go` blocks the task.
- `Conditional Go` requires a second lightweight Evaluator pass.
- Parent cannot reject or override Evaluator findings.

## Conditional Go Conditions

```text
Conditions:
- Condition:
  Required Evidence:
  Follow-up Evaluator Pass:
  Status: open | satisfied | failed
```

The task cannot enter `accepted` until every Conditional Go condition is verified by a follow-up Evaluator pass.

## Open Conflicts

```text
Open Conflicts:
- Conflict ID:
  Sources:
  Summary:
  Evaluator Review:
  Status: open | resolved | blocked
```

If authoritative artifacts disagree, set state to `blocked: authority-conflict`.

## Evidence Index

Evidence Index is append-only. Do not delete or rewrite old entries.

```text
Evidence ID:
Source:
Type: diff | child-report | verification | evaluator-finding | human-decision | conflict | scope-change | parent-synthesis
Status: open | resolved | disputed | accepted-risk
Summary:
Reference:
Created At:
Updated By:
Update Reason:
```

Status changes must be appended as new update records with reason and timestamp.

```text
Evidence Update Record:
Evidence ID:
Previous Status:
New Status:
Reason:
Timestamp:
Updated By:
```
