# Route Policy

Choose the route before editing. Also choose an S-level so the task does not receive more process than it deserves.

## S-Level Overlay

S-level decides execution weight. Route and four-layer tier decide capabilities and acceptance strictness.

| Level | Use When | Execution Weight |
| --- | --- | --- |
| `S0` | Discussion, prompt writing, explanation, no-code analysis. | Direct answer. No full route/report unless useful. |
| `S1` | Known file or small single-point change. | Parent may execute directly. Focused verification. |
| `S2` | Medium but bounded feature/fix; clear scope and checks. | Parent may plan and implement directly. Child recommended, not mandatory. |
| `S3` | Cross-module, hidden acceptance, security, permission, public API, deployment, database, production server, unfamiliar risky area. | Child/reviewer required or strongly required. Review-gated evidence. |
| `S4` | Long product line, multi-stage delivery, formal module. | Parent decomposes stages; child executes; reviewer as needed. |

S-level is not a replacement for route. Example: a small docs typo can be `S1/lightweight_fix`; a bounded multi-file docs upgrade can be `S2/feature_plan`; a database migration is `S3/database_route` even if the diff looks small.

## Four-Layer Model

| Layer | Use When | Default Behavior |
| --- | --- | --- |
| `lightweight` | Small known task, obvious single-file edit, docs literal update. | Parent may execute directly, use `rg`, edit narrowly, run focused verification, report residual risk. |
| `medium` | Bug, bounded cross-file work, unfamiliar area, docs/API uncertainty, feature planning. | Parent routes and may implement if S2-bounded; use CodeGraph/MCP when structure matters; verify before completion. |
| `review_gated` | Boundary, security, permissions, public API, deployment/database high-risk state, hidden acceptance risk. | Use medium steps plus child/reviewer or stronger checklist before acceptance. |
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
| `structural_localization` | Unfamiliar cross-file code path. | Use `rg` and CodeGraph/MCP when available to find owner, callers, tests, and impact radius. | Impact radius is broad or risky. |
| `feature_discovery` | Feature request is vague or alternatives matter. | Short brainstorm, assumptions/questions, acceptance criteria, route decision. | Feature becomes multi-step, cross-boundary, or high-risk. |
| `feature_plan` | Mid-size feature with sequencing or multiple areas. | Short implementation plan, scope, steps, verification, risks. Parent may implement when S2-bounded. | Requires formal module delivery or hidden acceptance review. |
| `docs_assisted` | Current API, SDK, Codex/OpenAI, or platform docs matter. | Check official docs before deciding, then implement narrowly. | Docs conflict with repo facts or live behavior. |
| `review_gated` | Boundary, security, permissions, exports, public API, hidden acceptance risk. | Independent read-only reviewer or equivalent checklist before acceptance. | Reviewer returns No-Go or risk requires formal delivery. |
| `deployment_route` | Production config, environment, nginx, certs, reload/restart, CI/CD, Docker/compose. | Pre-change evidence, rollback, dry-run/config-test, operator boundary, smoke plan. | Live blast radius, missing rollback, credentials, restart risk, or production uncertainty. |
| `server_inspection` | Read-only server file/config/process/log inspection through preconfigured no-secret access. | Fresh objective, host alias, read-only command plan, redacted output summary, no raw credential handling. | Command would write, restart, deploy, inspect secrets, use passwords, or change remote state. |
| `database_route` | Schema, migration, SQL, ORM, data repair, import/export, permission data. | Environment/database identity, impact preview, backup/rollback, transaction/dry-run, row-count/destructive guards. | Production, privacy, destructive, broad row-count, permission, export/import, or rollback uncertainty. |
| `branch_finish` | Implementation is complete and the agent is preparing commit, push, PR, merge, keep, or cleanup. | Verify tests/checks first, inspect branch/worktree state, summarize options, preserve worktree for PR iteration, require confirmation for discard/delete. | Tests fail, base branch is unclear, branch cleanup is destructive, or PR/merge needs human approval. |
| `lab_ai_delivery` | Formal module, high-risk delivery, required evaluator/Gate Report. | Task Packet, child/generator, parent gates, evaluator, Gate Report. | Human decides to stop or change scope. |

## Daily Route Rules

Use the lightest route that still gives trustworthy completion evidence.

Prefer:

```text
S0 direct answer
> S1 lightweight_fix
> S2 audit_fix / structural_localization / feature_plan / docs_assisted
> S3 review_gated / deployment_route / server_inspection / database_route
> S4 staged delivery / lab_ai_delivery when required
```

Do not use the highest route by default. Do not use the lowest route when risk is obvious.

## Parent-router / Child-executor

Default principle: parent routes, scopes, accepts, and verifies. Child execution is reserved for tasks where it improves safety, focus, or throughput.

Use direct parent execution when:

- task is S0 or S1; or
- task is S2 with clear boundaries, known allowed files, and an obvious verification path.

Use child execution as recommended when:

- S2 is cross-file but bounded;
- a medium new feature benefits from a separate implementer;
- structural localization may exceed context comfort;
- the parent wants an isolated investigation report before editing.

Use child/reviewer as required or strongly required when:

- task is S3 or S4;
- hidden acceptance risk exists;
- deployment, database, server mutation, security, permission, auth, public API, or production boundary is involved;
- area is unfamiliar and cross-module.

If child execution is unavailable:

- S0-S2: state the limitation or why a child is not worth opening, then continue.
- S3-S4: stop, explain risk, and ask for parent-only authorization or child/reviewer support.

See `docs/parent-child-execution.md`.

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

## Server Inspection Work

Use `server_inspection` when the Human wants Codex to inspect server state directly for a project, but not mutate the server.

New project default:

```text
project profile
> check for server SSH alias
> if alias exists: run server-inspection-check and proceed with read-only queries
> if alias missing: ask Human to configure Windows SSH config alias once
> never request raw password or password screenshot
```

Allowed access pattern:

- Human gives a fresh objective for the specific inspection.
- Access is already configured without exposing raw credentials: SSH config host alias, SSH agent, short-lived operator-prepared session, or a platform CLI session.
- Commands do not contain passwords, tokens, private keys, `.env` values, or connection strings.
- Commands are read-only and produce compact redacted evidence.

Examples of acceptable read-only checks:

```text
hostname
uptime
pwd
ls -la /path
test -f /path/file && echo present
sed -n '1,80p' /non-secret/config
tail -n 100 /non-secret/log
systemctl status service-name
docker ps
```

Blocked by default:

- password screenshots, copied passwords, `sshpass`, interactive password entry, or credential values in commands;
- `sudo` unless the Human explicitly approved the exact read-only command and it does not reveal secrets;
- writes, deploys, reload/restart, file edits, `rm`, `mv`, `chmod`, `chown`, package installs, database writes;
- reading `.env`, private keys, secret manager values, database URLs, cookies, or raw user/private data.

Use `templates/server-inspection.md` and `scripts/server-inspection-check.ps1`.

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

## Branch Finish Work

Use `branch_finish` when implementation is complete and the next step is commit, push, PR, merge, keep, discard, branch deletion, or worktree cleanup.

Required before presenting integration options:

- required tests/checks have passed, or a narrow not-verified reason is recorded;
- `git status` is reviewed;
- current branch, base branch, remote, and worktree state are known;
- changed files and residual risk are summarized;
- destructive cleanup is not automatic.

Default options:

```text
1. Push branch / create PR when platform and auth support it
2. Keep branch as-is for later
3. Merge locally only with explicit Human approval
4. Discard/delete only after exact confirmation
```

Rules:

- Do not offer merge/PR as ready when tests or required checks failed.
- Do not delete a branch or worktree before merge/PR success is verified.
- Preserve the worktree for PR feedback unless the Human asks to clean it.
- Detect GitHub versus non-GitHub remotes before suggesting `gh pr create`.
- Use `templates/branch-finish.md` and `scripts/branch-finish-check.ps1`.

## Formal Delivery

Use `lab_ai_delivery` for formal modules and high-risk governed work.

It is retained, not removed. It should not be the daily default.

Use it when:

- the Human requests formal module delivery;
- a Task Packet and Gate Report are required;
- evaluator review is mandatory;
- risk is high enough that lightweight routing is not sufficient;
- production/data/security impact cannot be safely bounded.
