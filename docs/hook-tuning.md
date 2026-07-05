# Hook Tuning

Hooks are guardrails and memory prompts. They are not a complete sandbox and should not make normal safe development feel hostile.

## Result Levels

| Level | Meaning | Typical Action |
| --- | --- | --- |
| `info` | Helpful context or reminder. | Continue. |
| `warn` | Possible risk or missing evidence. | Continue, but record or check it. |
| `block` | Unsafe or policy-violating action. | Stop unless the Human gives a fresh objective and the route permits it. |

## Keep Strict Blocks

Do not weaken guards for:

- `.env` or secret files;
- private keys;
- raw passwords, tokens, connection strings, cookies;
- dangerous deletion or destructive git reset/checkout/clean;
- database writes, migrations, import/export, destructive SQL;
- deployment, reload/restart, production remote mutation;
- commands that would expose secrets in terminal history, files, prompts, hooks, or reports.

## Reduce False Positives

Prefer `info` or `warn` for:

- discussion and planning;
- read-only inspection;
- docs-only edits;
- local checks that do not mutate remote systems;
- route-aware dry-runs and previews.

Allowed route-aware exceptions:

- `server_inspection`: read-only SSH alias command marked with `# harness:server-inspection`.
- `deployment_route`: dry-run/config-test/plan without live mutation.
- `database_route`: `SELECT preview`, explain plan, or migration plan without writes.

## Tuning Log

Record hook tuning here when a real task shows useful friction or false positives.

```text
Date:
Project / task:
Hook event:
Result level: info | warn | block
Useful: yes | no
False positive: yes | no
Reason:
Suggested action: keep | downgrade | upgrade | delete | rewrite
Decision:
```

## Non-Goal

Do not add heavy evaluation telemetry or cost fields to production hook records. Keep this file about practical tuning.
