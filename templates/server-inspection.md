# Server Inspection

Use this for read-only server inspection through preconfigured access. Do not use it for deploys, writes, restarts, database changes, or raw credential handling.

```text
Task ID:
Selected Route: server_inspection
Layer: review_gated
Status: ready | blocked | not-verified

Fresh Human Objective:
- TODO

Target:
- environment:
- host alias:
- service/app:
- paths allowed:
- paths forbidden:

New Project Alias Check:
- alias supplied by Human/project profile: yes | no
- check command: scripts/server-inspection-check.ps1 -HostAlias <alias>
- if alias exists: proceed with read-only server_inspection
- if alias missing: ask Human to configure Windows SSH config alias once
- raw password requested from Human: no

Access Boundary:
- access method: SSH config alias | SSH agent | operator session | platform CLI
- BatchMode/no-interactive-password: yes | no
- raw password/token/private key exposed to Codex: no
- command contains secrets: no

Allowed Read-only Commands:
- TODO

Forbidden Commands:
- deploy
- restart/reload
- write/edit files
- chmod/chown
- rm/mv/cp destructive changes
- package install
- database write/migration
- reading .env/private keys/database URLs/cookies

Evidence To Capture:
- command:
- exit code:
- redacted summary:
- evidence limit:

Checks Run:
- TODO

Checks Skipped:
- check:
  allowed reason:
  residual risk:

Residual Risk:
- TODO
```
