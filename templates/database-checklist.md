# Database Checklist

Use this for `database_route` or operator-assisted database/schema/migration work.

```text
Task ID:
Route: database_readonly_review | database_change_plan | operator_assisted_database_change | lab_ai_delivery
Layer: review_gated | full_formal_gate
Risk Level: read_only_low | local_policy_medium | data_change_high | production_data_critical

Environment / Database Identity:
- environment:
- sanitized database alias:
- tenant scope:
- owner/operator:
- schema or migration baseline:

Impact Preview:
- SELECT preview or equivalent:
- predicate summary:
- affected tables/columns/indexes:
- expected row count:
- maximum row count:
- lock/downtime risk:

Backup / Rollback:
- backup or snapshot ref:
- rollback owner:
- rollback trigger:
- rollback steps summary:
- rollback verification:

Execution Safety:
- transaction supported:
- dry-run/generated SQL/staging rehearsal:
- idempotency/resume strategy:
- batch/timeout/abort criteria:

Destructive Guard:
- DROP/TRUNCATE/DELETE/broad UPDATE:
- type narrowing/irreversible rewrite:
- permission/auth/tenant data:
- explicit approval:
- reviewer needed:

Privacy / Secret Redaction:
- credentials stored: no
- database URLs stored: no
- raw rows/dumps stored: no
- personal data stored: no
- redacted evidence refs:

Import / Export / Permission Escalation:
- import/export involved:
- data classification:
- retention/deletion plan:
- permission smoke:

Operator Boundary:
- Codex will run SQL/ORM/db commands: no
- operator confirmation required:
- redacted operator evidence:

Post-change Verification:
- query/app smoke/count reconciliation:
- result:
- residual risk:

Completion Status:
passed | partial | blocked | not-verified
```
