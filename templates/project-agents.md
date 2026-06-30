# Production Harness Project Addendum

This project adopts `personal-workflow-harness-v2` for Codex work.

## Mandatory Start

At the start of every task:

1. Name the route before editing.
2. Read `docs/project-profile.md` when it exists.
3. Apply the parent-router / child-executor rule below.
4. Verify before completion or record a narrow not-verified reason.

Referencing the harness repository in chat is not enough. This file or an equivalent block must live in the target project root `AGENTS.md` so new Codex windows keep the protocol.

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

Default: parent routes, scopes, accepts, and verifies. Child executes non-trivial work.

Parent may directly execute only when all are true:

- route is `lightweight_fix`;
- task is tiny or obvious single-file work;
- target file/area is already known;
- no cross-file behavior, shared contract, new feature, deployment, database, server, auth, permission, public API, browser profile, or hidden acceptance risk exists;
- focused verification is obvious and cheap.

For every other task:

- Parent creates a scoped child task before implementation.
- Child performs investigation or implementation.
- Child returns changed files, checks, skipped checks, assumptions, risks, and next step.
- Parent reads the report, inspects scope, verifies, and writes the final answer.
- High-risk or hidden acceptance tasks get reviewer after the child report.

If the current Codex surface cannot create a child/subagent/thread, parent must state that limitation and ask the Human to authorize parent-only execution or create/authorize a child thread. Do not silently collapse non-trivial work into parent-only execution.

## Server Inspection

Use `server_inspection` only for read-only server queries through preconfigured no-secret access such as an SSH config alias or SSH agent.

Do not read, print, store, or commit secrets. Do not use raw passwords from screenshots, `sshpass`, `.env` values, private keys, cookies, or database URLs.

## Completion

Final report must include:

- route selected;
- direct execution exception used: yes/no;
- child report summary or reason child was unavailable;
- files changed;
- checks run and results;
- skipped checks and reason;
- residual risk.
