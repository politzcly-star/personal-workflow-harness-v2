# Parent-router / Child-executor Protocol

This protocol keeps the parent thread responsible for routing and acceptance while avoiding unnecessary delegation for bounded daily work.

## Default Principle

Parent owns route, scope, verification, and final acceptance.

Child execution is used when it improves safety, focus, or throughput. It is not mandatory for every medium task.

## Activation Requirement

This protocol must be present in the target project's durable instructions. A first-turn chat note that says "use the harness" is not enough for later turns.

New project onboarding must install or merge `templates/project-agents.md` into the target project root `AGENTS.md`, then create `docs/project-profile.md`. The profile records project facts; root `AGENTS.md` carries the execution protocol every new window reads.

## Decision Table

| Decision | Required For | Recommended For | Parent Direct Allowed For |
| --- | --- | --- | --- |
| `child_required` | S3/S4, high-risk, hidden acceptance, deployment, database, security/permission/public API, unfamiliar cross-module work. | - | - |
| `child_recommended` | - | S2 cross-file but bounded work, medium new feature, structural localization, long investigation. | - |
| `parent_allowed` | - | - | S0/S1 and S2 with clear boundaries and obvious verification. |

## Parent Direct Execution

Parent may execute directly when:

- task is S0 or S1; or
- task is S2 and the boundaries are clear;
- allowed files or target areas are known enough to avoid scope drift;
- no deployment, database, server mutation, auth, permission, public API, security, or hidden acceptance risk exists;
- focused verification is obvious and cheap enough to run.

For S2 direct execution, parent should still write a short plan before editing when more than one file or step is involved.

## Child Required

Use child/reviewer support when:

- task is S3 or S4;
- production, deployment, database, server mutation, auth, permission, security, public API, or privacy boundary is involved;
- hidden acceptance risk is high;
- the code area is unfamiliar and cross-module;
- the task needs a long investigation or staged delivery;
- formal delivery requires child report or gate evidence.

## Child Recommended

Child is useful but not mandatory when:

- S2 work touches multiple files but has clear boundaries;
- a medium new feature benefits from separate implementation;
- structural localization may produce a useful report before edits;
- the parent is near context limits;
- isolated exploration would reduce acceptance risk.

For these cases, parent may decide to continue directly and record the reason briefly.

## Unavailable Child Capability

If the current Codex surface cannot create a child/subagent/thread:

- S0-S2: state the limitation or why child is not worth opening, then continue in-parent.
- S3-S4: stop, explain why parent-only execution is risky, and ask the Human to authorize parent-only execution or create/authorize child/reviewer support.

Do not silently downgrade S3/S4 work into parent-only execution.

## Parent Duties

Parent owns:

- requirement understanding;
- route, S-level, and layer selection;
- capability selection;
- allowed and forbidden files;
- child task packet when used;
- final diff/scope inspection;
- verification decision;
- final report and residual risk.

Parent should read child output, not re-implement child work unless a narrow repair is needed after review.

## Child Duties

Child owns:

- scoped investigation or implementation;
- staying inside allowed files;
- avoiding forbidden files/actions;
- running assigned checks when safe;
- returning a report with changed files, checks, skipped checks, assumptions, risks, and next step.

Use `templates/child-task.md` and `templates/child-report.md`.

## Reviewer

Use reviewer after child report when:

- hidden acceptance risk is high;
- security, permissions, auth, public API, deployment, database, or server boundary is involved;
- verification is incomplete but acceptance is tempting;
- formal delivery requires it.

## Completion Evidence

Final report weight follows `docs/reporting-policy.md`:

- S0: direct answer.
- S1: changed files and verification.
- S2: route, files, checks, skipped checks, residual risk.
- S3-S4: child/reviewer/checklist evidence as needed.
