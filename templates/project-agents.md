# Production Harness Project Addendum

This project adopts `personal-workflow-harness-v2` for Codex work.

## Mandatory Start

At the start of every task:

1. Classify S-level and route before editing.
2. Read `docs/project-profile.md` when it exists, or confirm it is unchanged in the same thread.
3. Apply the parent-router / child-executor rule below.
4. Verify before completion or record a narrow not-verified reason.

Referencing the harness repository in chat is not enough. This file or an equivalent block must live in the target project root `AGENTS.md` so new Codex windows keep the protocol.

## S0-S4 Task Weight

| Level | Use When | Default |
| --- | --- | --- |
| `S0` | Discussion, prompt help, explanation, no-code analysis. | Direct answer; no full report required. |
| `S1` | Known file, small fix, single-point change. | Parent direct execution with focused verification. |
| `S2` | Medium but bounded feature/fix. | Parent may plan and implement directly; child recommended but not mandatory. |
| `S3` | High-risk/cross-module/hidden acceptance/deployment/database/security/permission/public API/production server. | Child/reviewer required or strongly required. |
| `S4` | Long product line, multi-stage delivery, formal module. | Parent splits stages; child executes; reviewer as needed. |

## Routes

- clear small edit -> `lightweight_fix`
- bug, failing test, regression -> `audit_fix`
- unfamiliar cross-file area -> `structural_localization`
- vague feature -> `feature_discovery`
- mid-size feature -> `feature_plan`
- docs/API uncertainty -> `docs_assisted`
- boundary/security/permission -> `review_gated`
- deployment/config -> `deployment_route`
- read-only server inspection through a configured alias -> `server_inspection`
- database/schema/migration -> `database_route`
- finished implementation ready for commit/push/PR/merge/cleanup -> `branch_finish`
- formal/high-risk delivery -> `lab_ai_delivery`

## Parent-router / Child-executor

Default principle: parent routes, scopes, accepts, and verifies. Child execution is used when it improves safety, focus, or throughput.

```text
child_required:
  S3/S4, high-risk, hidden acceptance, deployment, database,
  security/permission/public API, unfamiliar cross-module work.

child_recommended:
  S2, cross-file but bounded work, medium new features,
  structural localization.

parent_allowed:
  S0/S1, and S2 when boundaries are clear and verification is obvious.
```

If the current Codex surface cannot create a child/subagent/thread:

- S0-S2: state child is unavailable or not worth opening, then continue in-parent.
- S3-S4: stop, explain the risk, and ask the Human to authorize parent-only execution or create/authorize child/reviewer support.

## Server Inspection

Use `server_inspection` only for read-only server queries through preconfigured no-secret access such as an SSH config alias or SSH agent.

Do not read, print, store, or commit secrets. Do not use raw passwords from screenshots, `sshpass`, `.env` values, private keys, cookies, or database URLs.

## Reporting

- S0: direct answer; optionally say `discussion / no code changes`.
- S1: changed files and verification.
- S2: route/S-level, files changed, checks run, skipped checks, residual risk.
- S3-S4: formal report with child/reviewer/checklist evidence where needed.

Use `templates/product-acceptance.md` for PPT, dashboard, document, page, agent product, script, or tool deliverables where artifact quality matters.
