# Server Alias Onboarding Verification Report

```text
Task ID: server-alias-default-onboarding
Selected Route: feature_plan
Layer: medium
Status: passed

Changed Files:
- AGENTS.md
- README.md
- docs/install-hooks-upgrade.md
- docs/route-policy.md
- docs/server-alias-onboarding-verification-report.md
- docs/verification-and-guardrails.md
- scripts/server-inspection-check.ps1
- templates/project-profile.md
- templates/server-inspection.md

Checks Run:
- Command: powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\health-check.ps1
  Exit Code: 0
  Result Summary: Required files, hook JSON parse, PowerShell syntax, scope-check, stop-check, and CodeGraph fallback passed.
- Command: powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\server-inspection-check.ps1
  Exit Code: 2
  Result Summary: Expected no-alias onboarding state. Script printed the new-project default and one-time Windows SSH config setup instructions without requesting a password.
- Command: powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\server-inspection-check.ps1 -HostAlias test-prod
  Exit Code: 0
  Result Summary: Alias dry-run resolved SSH config shape and reported ready for read-only server_inspection without printing identity files or secrets.
- Command: rg -n "server alias|SSH alias|server-inspection-check|Windows SSH config|raw password|password screenshot" README.md AGENTS.md docs templates scripts
  Exit Code: 0
  Result Summary: New project alias check and no-raw-password boundaries are covered in README, AGENTS, docs, templates, and script output.
- Command: git diff --check
  Exit Code: 0
  Result Summary: No whitespace errors. Git reported LF-to-CRLF normalization warnings only.

Checks Not Run:
- Check: Real server connection
  Allowed Reason: This change defines onboarding behavior and does not require a real server credential.
  Residual Risk: Each real project must verify its own alias.

Scope Guard:
Expected Files: server inspection docs/templates/script and onboarding docs.
Actual Files: Expected files only.
Forbidden Changes Detected: no
Runtime Artifacts Detected: existing .vs remains ignored
Secret Risk Detected: no

Capability Use:
- Capability: rg
  Used: yes
  Reason: Literal coverage scan.
  Result: Required onboarding terms and no-raw-password boundaries are present.
  Evidence Limit: Does not prove real server access.
- Capability: verification
  Used: yes
  Reason: Health, script, scope, and whitespace checks.
  Result: Passed. The no-alias path intentionally exits 2 to signal setup-needed rather than failure.
  Evidence Limit: Alias setup is project/operator-owned.

Reviewer:
Used: no
Decision: not required
Findings: This is a workflow onboarding refinement that keeps the no-raw-secret boundary.

Completion Claim:
What is proven: New project onboarding now defaults to checking for a server alias, using server_inspection if present, and asking for one-time Windows SSH config setup if absent.
What is not proven: Any real server alias.
Residual Risk: Human still must configure the actual SSH alias outside Codex.
Next Recommended Action: In new projects, record the alias in project-profile and run server-inspection-check before server queries.
```
