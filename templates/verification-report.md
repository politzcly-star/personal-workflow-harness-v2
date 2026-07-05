# Verification Report

Use the section that matches task weight.

## S0 Direct Answer

```text
discussion / no code changes
```

## S1 Lightweight Report

```text
Task ID:
Route / S-Level:
Status: passed | partial | failed | not-verified

Changed:
- TODO

Verified:
- Command/check:
- Result:

Residual Risk:
- TODO
```

## S2 Standard Report

```text
Task ID:
Selected Route:
S-Level:
Layer: lightweight | medium | review_gated | full_formal_gate
Status: passed | partial | failed | not-verified

Changed Files:
- TODO

Checks Run:
- Command:
  Exit Code:
  Result Summary:

Checks Not Run:
- Check:
  Allowed Reason:
  Residual Risk:

Scope Guard:
Expected Files:
Actual Files:
Forbidden Changes Detected: yes | no
Runtime Artifacts Detected: yes | no
Secret Risk Detected: yes | no

Parent / Child:
Parent Direct Execution: yes | no
Child Executor Used: yes | no
Child Report:
Reviewer Used: yes | no
Reviewer Decision:

Completion Claim:
What is proven:
What is not proven:
Residual Risk:
Next Recommended Action:
```

## S3-S4 Formal Report

```text
Task ID:
Selected Route:
S-Level:
Layer: review_gated | full_formal_gate
Status: passed | partial | failed | not-verified

Risk Boundary:
- Security/Auth/Permission/Public API:
- Deployment/Server:
- Database/Data:
- Secrets/Privacy:
- Hidden Acceptance:

Child / Reviewer:
- Child required: yes | no
- Child report:
- Reviewer required: yes | no
- Reviewer decision:
- Checklist used:

Changed Files:
- TODO

Checks Run:
- Command:
  Exit Code:
  Result Summary:

Checks Not Run:
- Check:
  Allowed Reason:
  Residual Risk:

Operator / Rollback Evidence:
- Dry-run/config-test:
- Backup/rollback:
- Redacted operator evidence:

Scope Guard:
Expected Files:
Actual Files:
Forbidden Changes Detected: yes | no
Runtime Artifacts Detected: yes | no
Secret Risk Detected: yes | no

Completion Claim:
What is proven:
What is not proven:
Residual Risk:
Next Recommended Action:
```
