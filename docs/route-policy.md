# Route Policy

Choose the route before editing. The route decides how much thinking, tooling, verification, and review the task needs.

## Route Table

| Route | Use When | Default Work | Escalate When |
| --- | --- | --- | --- |
| `lightweight_fix` | Small, clear, low-risk edit. | Make scoped change and run focused verification. | Target area becomes unclear or touches shared behavior. |
| `audit_fix` | Bug, failing test, regression, runtime error, suspicious behavior. | Reproduce or inspect failure, localize, fix, verify. | Root cause crosses auth, data, deployment, or security boundaries. |
| `structural_localization` | Unfamiliar cross-file code path. | Use `rg` then CodeGraph/MCP to find owner, callers, tests. | Impact radius is broad or risky. |
| `feature_discovery` | Feature request is vague or alternatives matter. | Brief brainstorming, assumptions/questions, acceptance criteria. | Feature becomes multi-step or high-risk. |
| `feature_plan` | Mid-size feature with sequencing or multiple areas. | Short implementation plan, scope, steps, verification. | Requires formal module delivery. |
| `docs_assisted` | Current API, SDK, Codex/OpenAI, or platform docs matter. | Check official docs before deciding. | Docs conflict with repo facts or live behavior. |
| `review_gated` | Boundary, security, permissions, exports, public API, hidden acceptance risk. | Independent read-only reviewer before acceptance. | Evaluator returns No-Go or risk requires formal delivery. |
| `deployment_route` | Production config, environment, nginx, certs, reload/restart, CI/CD, Docker/compose. | Pre-change evidence, rollback, dry-run/config-test, operator boundary, smoke plan. | Live blast radius, missing rollback, credentials, or production uncertainty. |
| `database_route` | Schema, migration, SQL, ORM, data repair, import/export, permission data. | Environment identity, impact preview, backup/rollback, transaction/dry-run, row-count/destructive guards. | Production, privacy, destructive, broad row-count, permission, or rollback uncertainty. |
| `lab_ai_delivery` | Formal module, high-risk delivery, required evaluator/Gate Report. | Task Packet, child/generator, parent gates, evaluator, Gate Report. | Human decides to stop or change scope. |

## Daily Route Rules

Use the lightest route that still gives trustworthy completion evidence.

Prefer:

```text
lightweight_fix
> audit_fix / structural_localization
> feature_discovery / feature_plan
> review_gated
> deployment_route / database_route
> lab_ai_delivery
```

Do not use the highest route by default. Do not use the lowest route when risk is obvious.

## Feature Work

Use `feature_discovery` when the request is vague:

- user value or exact behavior is unclear
- there are competing designs
- acceptance criteria are missing
- UI/API/data shape is undecided

Discovery output should be short:

```text
Problem:
Options:
Recommendation:
Assumptions:
Acceptance checks:
```

Use `feature_plan` when the feature has multiple steps, files, states, migrations, or verification commands.

Skip discovery when the behavior, target, and verification are already clear.

## Bugfix Work

Use `audit_fix` for failures and regressions.

Expected loop:

```text
observe failure
> localize root cause
> make smallest repair
> verify
> report residual risk
```

Use CodeGraph/MCP when the bug crosses file boundaries or ownership is unclear.

## Deployment Work

Use `deployment_route` for production-adjacent work. The agent should usually prepare a checklist, not run live commands.

Required before a live operator action:

- target environment and owner
- current state summary
- backup or previous artifact reference
- rollback plan
- dry-run/config-test when available
- smoke check
- operator confirmation

Blocked by default:

- printing secrets or `.env` values
- editing server config directly
- running remote reload/restart/deploy commands
- claiming production success without smoke evidence

## Database Work

Use `database_route` for persistent data risk.

Required before data-affecting work:

- target environment and database identity
- current schema or migration reference
- `SELECT preview` or equivalent impact preview
- expected and maximum row count
- backup and rollback plan
- transaction/dry-run/staging/idempotency status
- destructive guard disposition
- redacted operator evidence

Blocked by default:

- running SQL, migrations, backup/restore, import/export, or remote commands
- storing dumps, private rows, connection strings, or credentials
- proceeding without rollback or row-count bounds

## Formal Delivery

Use `lab_ai_delivery` for formal modules and high-risk governed work.

It is retained, not removed. It should not be the daily default.

Use it when:

- the Human requests formal module delivery
- a Task Packet and Gate Report are required
- evaluator review is mandatory
- risk is high enough that lightweight routing is not sufficient
- production/data/security impact cannot be safely bounded
