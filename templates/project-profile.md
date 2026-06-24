# Project Profile

Create one profile per real project during first onboarding. Keep it redacted and practical.

```text
Project Name:
Project Path:
Owner:
Last Updated:

Package Manager:
Primary Language / Framework:

Start Commands:
- Command:
  Notes:

Test Commands:
- Command:
  Scope:

Build Commands:
- Command:
  Scope:

Ports:
- Port:
  Service:

Main Directories:
- Path:
  Purpose:

Forbidden Modification Areas:
- secrets and `.env`
- generated/runtime artifacts
- vendor/dependency directories
- production config:
- database dumps:
- browser profiles:
- other:

Database Boundary:
- Has database: yes | no | unknown
- Local only:
- Staging/prod:
- Migration command:
- Prohibited actions:

Deployment Boundary:
- Has deployment: yes | no | unknown
- Environments:
- Operator-owned actions:
- Prohibited actions:

CodeGraph Status:
- Available: yes | no | unknown
- Checked by:
- Fallback if unavailable: rg + file tree + test entry points + manual dependency/call notes

Common Verification Commands:
- Command:
  When to use:

Risk Boundaries:
- security/auth:
- public API:
- permissions:
- data export/import:
- billing/paid actions:
- browser/login state:

Notes:
- TODO
```
