# Risk Review

Use this for deployment, database, permission, security, auth, billing, export/import, browser profile, or destructive work.

```text
Task ID:
Risk Route: review_gated | deployment_route | database_route | lab_ai_delivery
Layer: review_gated | full_formal_gate
Risk Level: low | medium | high | critical

Risk Triggers:
- production:
- database:
- secrets:
- permissions/auth:
- destructive write:
- broad refactor:
- external paid action:
- browser/profile state:
- public API contract:
- hidden acceptance:

Required Evidence:
- pre-change state:
- impact preview:
- backup/rollback:
- dry-run/config-test:
- verification/smoke:
- operator confirmation:
- secret redaction:

Blocked Actions:
- TODO

Reviewer Needed: yes | no
lab-ai-delivery Needed: yes | no
Human Approval Needed: yes | no

Decision:
Proceed | proceed-with-conditions | block

Conditions:
- TODO

Residual Risk:
- TODO
```
