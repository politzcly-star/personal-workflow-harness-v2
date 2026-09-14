# Optional External Executor Adapter

ClaudeCode, Qwen, or another external executor is disabled by default. It may be used only when the Human explicitly enables one named phase that is high-token and low-final-decision, such as a bounded inventory, draft, or mechanical preparation task.

It is an optional adapter, not a mandatory route or model relay. The selected root remains accountable; use the current bounded scheduling policy rather than requiring named worker/verifier models.

```text
root goal owner defines scope and acceptance
> external executor completes one named packet
> native owner reviews scope, diff, evidence, and risk
> an authorized non-author reviewer verifies the final boundary when S3/S4 requires independent review
```

The external executor may not decide architecture, final acceptance, merge readiness, production readiness, deployment, database, security/auth/permission, billing/quota, or stakeholder-facing conclusions. It must not receive secrets, credentials, private browser state, raw private data, or production logs.

Use `templates/external-child-task.md` and `templates/external-child-report.md` only after explicit Human activation. Record activation, allowed scope, checks, skipped checks, risks, and native acceptance in that optional report; do not burden normal task templates with these fields.
