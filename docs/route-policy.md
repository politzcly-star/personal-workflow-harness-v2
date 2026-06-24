# Route Policy

Choose the route before editing. The route decides how much thinking, tooling, verification, review, and handoff the task needs.

## Four-Layer Model

| Layer | Use When | Default Behavior |
| --- | --- | --- |
| `lightweight` | Small known task, obvious single-file edit, docs literal update. | Parent may execute directly, use `rg`, edit narrowly, run focused verification, report residual risk. |
| `medium` | Bug, cross-file work, unfamiliar area, docs/API uncertainty, feature planning. | Parent routes and may delegate; use CodeGraph/MCP when structure matters; verify before completion. |
| `review_gated` | Boundary, security, permissions, public API, deployment/database high-risk state, hidden acceptance risk. | Use medium steps plus read-only reviewer or stronger checklist before acceptance. |
| `full_formal_gate` | Formal module, governed delivery, high-risk work requiring audit trail. | Use `lab-ai-delivery`: Task Packet, child, parent gates, evaluator, Gate Report. |

Route mapping:

```text
lightweight_fix -> lightweight
audit_fix / structural_localization / docs_assisted / feature_plan -> medium
review_gated / deployment_route / database_route high-risk state -> review_gated
lab_ai_delivery / formal module -> full_formal_gate
```

## Route Table

| Route | Use When | Default Work | Escalate When |
| --- | --- | --- | --- |
| `lightweight_fix` | Small, clear, low-risk edit. | Make scoped change and run focused verification. | Target area becomes unclear or touches shared behavior. |
| `audit_fix` | Bug, failing test, regression, runtime error, suspicious behavior. | Reproduce or inspect failure, localize, fix, verify. | Root cause crosses auth, data, deployment, or security boundaries. |
| `structural_localization` | Unfamiliar cross-file code path. | Use `rg` then CodeGraph/MCP to find owner, callers, tests, and impact radius. | Impact radius is broad or risky. |
| `feature_discovery` | Feature request is vague or alternatives matter. | Short brainstorm, assumptions/questions, acceptance criteria, route decision. | Feature becomes multi-step, cross-boundary, or high-risk. |
| `feature_plan` | Mid-size feature with sequencing or multiple areas. | Short implementation plan, scope, steps, verification, risks. | Requires formal module delivery. |
| `docs_assisted` | Current API, SDK, Codex/OpenAI, or platform docs matter. | Check official docs before deciding, then implement narrowly. | Docs conflict with repo facts or live behavior. |
| `review_gated` | Boundary, security, permissions, exports, public API, hidden acceptance risk. | Independent read-only reviewer before acceptance. | Reviewer returns No-Go or risk requires formal delivery. |
| `deployment_route` | Production config, environment, nginx, certs, reload/restart, CI/CD, Docker/compose. | Pre-change evidence, rollback, dry-run/config-test, operator boundary, smoke plan. | Live blast radius, missing rollback, credentials, restart risk, or production uncertainty. |
| `database_route` | Schema, migration, SQL, ORM, data repair, import/export, permission data. | Environment/database identity, impact preview, backup/rollback, transaction/dry-run, row-count/destructive guards. | Production, privacy, destructive, broad row-count, permission, export/import, or rollback uncertainty. |
| `lab_ai_delivery` | Formal module, high-risk delivery, required evaluator/Gate Report. | Task Packet, child/generator, parent gates, evaluator, Gate Report. | Human decides to stop or change scope. |

## Daily Route Rules

Use the lightest route that still gives trustworthy completion evidence.

Prefer:

```text
lightweight_fix
> audit_fix / structural_localization
> feature_discovery / feature_plan / docs_assisted
> review_gated
> deployment_route / database_route
> lab_ai_delivery
```

Do not use the highest route by default. Do not use the lowest route when risk is obvious.

## Parent-router / Child-executor

Use direct parent execution only for tiny or obvious single-file work.

Use parent-router + child-executor when:

- work is non trivial;
- multiple files or concepts are involved;
- the task may exceed context comfort;
- a new feature needs decomposition;
- high-risk boundaries need a separate report;
- hidden acceptance risk suggests review after implementation.

Parent responsibilities:

- understand the user request;
- select route and capabilities;
- write a scoped child task when delegation is useful;
- define allowed and forbidden files;
- accept or reject child output;
- run final scope and verification checks;
- produce final completion evidence.

Child responsibilities:

- follow `templates/child-task.md`;
- stay within allowed scope;
- report changed files, checks run, skipped checks, risks, and next steps using `templates/child-report.md`.

## Feature Work

Use `feature_discovery` when the request is vague:

- user value or exact behavior is unclear;
- there are competing designs;
- acceptance criteria are missing;
- UI/API/data shape is undecided;
- the feature touches unfamiliar code where CodeGraph/MCP may change the approach.

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

Use CodeGraph/MCP when the bug crosses file boundaries or ownership is unclear. Use `code-audit-fix` for failing verification, repair loops, regressions, or suspicious code paths.

## Deployment Work

Use `deployment_route` for production-adjacent work. The agent should usually prepare a checklist, not run live commands.

Required before a live operator action:

- target environment and owner;
- current state summary;
- backup or previous artifact reference;
- rollback plan;
- dry-run/config-test when available;
- reload/restart risk and expected user impact;
- smoke check;
- secret redaction;
- operator confirmation.

Blocked by default:

- printing secrets or `.env` values;
- editing server config directly;
- running remote reload/restart/deploy commands;
- claiming production success without smoke evidence.

Use `templates/deployment-checklist.md`.

## Database Work

Use `database_route` for persistent data risk.

Required before data-affecting work:

- target environment and database identity;
- current schema or migration reference;
- `SELECT preview` or equivalent impact preview;
- expected and maximum row count;
- backup and rollback plan;
- transaction/dry-run/staging/idempotency status;
- destructive guard disposition;
- privacy/secret redaction;
- permission/export/import escalation state;
- redacted operator evidence.

Blocked by default:

- running SQL, migrations, backup/restore, import/export, or remote commands;
- storing dumps, private rows, connection strings, or credentials;
- proceeding without rollback or row-count bounds.

Use `templates/database-checklist.md`.

## Formal Delivery

Use `lab_ai_delivery` for formal modules and high-risk governed work.

It is retained, not removed. It should not be the daily default.

Use it when:

- the Human requests formal module delivery;
- a Task Packet and Gate Report are required;
- evaluator review is mandatory;
- risk is high enough that lightweight routing is not sufficient;
- production/data/security impact cannot be safely bounded.
