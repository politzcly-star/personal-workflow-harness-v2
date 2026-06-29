# Parent-router / Child-executor Protocol

This protocol makes parent/child execution the default for new projects using v2.1.

## Default

The parent thread should route, decompose, review, verify, and report. It should not be the default implementer.

Use child execution for every non-trivial task.

## Direct Execution Exception

Parent may execute directly only when all criteria are true:

- route is `lightweight_fix`;
- task is tiny or obvious single-file work;
- target file/area is already known;
- no cross-file behavior or shared contract is involved;
- no new feature design is needed;
- no deployment, database, server, auth, permission, public API, browser profile, or hidden acceptance risk exists;
- focused verification is obvious and cheap.

If any criterion is false, use child execution.

## Parent Duties

Parent owns:

- requirement understanding;
- route and layer selection;
- capability selection;
- allowed and forbidden files;
- child task packet;
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

## Unavailable Child Capability

If the current Codex surface cannot create a child/subagent/thread:

1. State the limitation.
2. Present the intended child task.
3. Ask the Human to authorize parent execution or create/authorize a child thread.

Do not silently downgrade non-trivial work into parent-only execution.

## Completion Evidence

Final report should include:

- direct execution exception used: yes/no;
- child task path or summary;
- child report summary;
- reviewer status if used;
- parent verification;
- residual risk.
