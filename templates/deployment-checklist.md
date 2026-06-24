# Deployment Checklist

Use this for `deployment_route` or operator-assisted production config work.

```text
Task ID:
Route: production_config_review | deployment_route | operator_assisted_change | lab_ai_delivery
Layer: review_gated | full_formal_gate
Risk Level: read_only_low | local_policy_medium | operator_assisted_high | live_system_critical

Target Environment:
Owner / Operator:

Pre-change Evidence:
- current artifact/config version:
- current process/health summary:
- current nginx/reverse proxy/cert/env/config summary:
- expected user-visible behavior:
- impacted services:
- maintenance window:

Secret Redaction:
- `.env` values printed: no
- private keys printed: no
- tokens/cookies printed: no
- redacted evidence refs:

Backup / Rollback:
- backup or previous artifact ref:
- rollback owner:
- rollback trigger:
- rollback steps summary:
- rollback verification:

Dry-run / Config-test:
- command or operator evidence:
- result:
- unavailable reason:

Reload / Restart Risk:
- reload or restart:
- expected impact:
- dependency order:
- timeout:
- rollback signal:

Operator Boundary:
- Codex will run live commands: no
- operator confirmation required:
- approved command placeholders:

Smoke Verification:
- expected smoke:
- command or operator evidence:
- result:
- residual risk:

Reviewer:
- needed:
- decision:

Completion Status:
passed | partial | blocked | not-verified
```
