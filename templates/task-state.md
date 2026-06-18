# Task State Template

```text
Task ID:
Current State: proposed | signed | running | blocked | blocked: needs-human-signoff | blocked: needs-human-decision | blocked: authority-conflict | review_ready | accepted | rejected | committed
Blocked Reason:
Next Action:
```

## North Star Contract

Human-signed North Star is the highest task authority.

Parent may draft this contract, but it becomes effective only after Human signoff. Chat context is never an authority source.

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

- Parent drafts this section but cannot mark it signed without explicit Human confirmation.
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

## Children

```text
Active Children:
- <child-id>: <role> - <goal>

Completed Children:
- <child-id>: complete | blocked | exhausted | failed - <report ref>
```

## Evaluator State

```text
Evaluator Assigned:
Current Pass: none | evidence-first | synthesis-comparison | conditional-followup
Decision: PENDING | Go | Conditional Go | No-Go
Decision Ref:
Dispute: NONE | blocked: needs-human-decision
```

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

## Last Context Snapshot

```text
Snapshot ID:
Path:
Created At:
Reason:
Reload Paths:
```

## Evidence Index

Evidence Index is append-only. Do not delete or rewrite old entries.

```text
Evidence ID:
Source:
Type: diff | child-report | verification | evaluator-finding | human-decision | conflict | scope-change
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
