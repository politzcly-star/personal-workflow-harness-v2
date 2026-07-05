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

Parent / Child Execution:
- Child/subagent/thread available: yes | no | unknown
- S0/S1 parent direct allowed: yes
- S2 parent direct allowed when bounded and verification is clear: yes | no | unknown
- S2 child recommended for cross-file bounded work: yes
- S3/S4 child/reviewer required or strongly required: yes
- Fallback if child unavailable: S0-S2 continue with note; S3-S4 ask Human to authorize parent-only execution or create/authorize child/reviewer

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

Server Inspection:
- Server alias configured: yes | no | unknown
- SSH alias:
- Alias check command:
- Read-only paths allowed:
- Paths forbidden:
- Fallback if no alias: ask Human to configure Windows SSH config alias once; do not request raw password

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
