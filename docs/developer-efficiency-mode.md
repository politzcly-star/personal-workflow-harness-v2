# Developer Efficiency Mode

v2.2 optimizes for real development speed without weakening high-risk boundaries.

## Core Rule

Use the fastest feedback path that can produce trustworthy evidence for the current S-level and route.

## Local First

Prefer local or isolated feedback before broad checks:

```text
inspect targeted files
> run smallest relevant test/check
> run necessary regression
> run full verification only when risk justifies it
```

Examples:

- docs-only change: markdown/readability checks and harness health checks;
- single bugfix: reproduce/focused test first, then related suite;
- frontend change: targeted build/lint plus browser or screenshot check when visual acceptance matters;
- script change: syntax parse and direct script invocation with safe inputs.

## Scope Discipline

Do not expand scope for aesthetic cleanup unless it reduces real complexity, fixes a real risk, or matches a nearby established pattern.

Prefer:

- small patches;
- existing project conventions;
- focused helpers over new frameworks;
- verification that maps to the changed behavior.

Avoid:

- unrelated refactors;
- formatting churn in untouched files;
- broad rewrites to satisfy a narrow request;
- repeated reads of unchanged durable docs inside the same thread.

## Remote And Deployment Work

For deployment, server, or config-adjacent tasks:

1. Start with read-only inspection when allowed.
2. Prefer dry-run, config-test, plan, preview, or smoke checklist.
3. Keep live operator actions outside Codex unless the Human gives a fresh objective and the route permits it.
4. Use redacted operator evidence rather than raw secrets or full logs.

Route-aware allowed examples:

- `server_inspection`: read-only SSH alias command with `# harness:server-inspection`.
- `deployment_route`: dry-run/config-test with rollback and smoke plan.
- `database_route`: `SELECT preview` or migration plan without writes.

## Model, Build, And Browser Cost Awareness

Production v2.2 keeps cost awareness lightweight. Do not add heavy evaluation telemetry or cost fields to normal reports.

Do:

- batch independent reads and safe checks;
- reuse already-loaded context when it is still current;
- run browser/UI verification only when it proves user-facing behavior;
- keep screenshots/log excerpts compact;
- prefer one meaningful build/test over repeated identical commands.

Do not:

- repeat full AGENTS/profile/tracker reads in the same thread when unchanged;
- run full regression before a focused failing test is understood;
- use personal logged-in browser state by default;
- add evaluation-only measurement fields to production templates.

## Completion

Efficiency does not remove verification. It chooses the smallest verification that matches the risk.
