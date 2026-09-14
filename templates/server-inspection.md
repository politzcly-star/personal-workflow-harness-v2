# Server inspection — bounded read-only evidence

Use already-authorized inspection scope and preconfigured access. Not deployment, restart, data mutation or credential handling. No extra phase approval or mandatory formal report for a routine status query.

```text
Task / existing objective:
Target environment / configured SSH alias / service:
Allowed read-only command and purpose:
Access availability / noninteractive connection policy:
Output bound / redaction plan:
Actual command / exit code / observed result:
Unverified checks / blocker / next action:
```

Resolve access from the project profile and supported client tools, without reading private keys or dumping SSH configuration. If no usable access exists, ask once for the smallest operator setup; never ask for raw passwords.
The Hook recognizes only narrowly bounded simple remote inspection forms, e.g. `ssh alias 'systemctl is-active service' # harness:server-inspection`. The comment is not authority. Other syntax needs its applicable reviewed transport; do not weaken checks or use a wrapper to evade them. Connection options/timeouts must use a genuinely configured approved client/runner, not a promise made by this template.
Capture only necessary redacted output. No deploy/restart, writes, package installs, data mutation or secret-file reads. A local template or helper being present does not prove network reachability or production health.
