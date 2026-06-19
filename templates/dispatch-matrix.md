# Dispatch Matrix Template

The Dispatch Matrix is the v2 assignment surface for a goal-first, agent-orchestrated control plane.
It records ownership and stop rules for child work; it does not execute work automatically.

## Header

```text
Dispatch ID:
Task Instance Ref:
North Star Version:
Human Signoff Ref:
Parent Thread:
Created At:
```

## Parent Boundary

```text
Parent Responsibilities:
- Draft child goals.
- Maintain control-plane artifacts.
- Synthesize reports from evidence refs.
- Escalate conflicts and scope changes.

Parent Forbidden:
- Parent cannot assign itself.
- Parent cannot assign itself as generator or evaluator.
- Parent cannot modify child-owned business files directly.
- Parent cannot replace child verification evidence with chat memory.
```

## Child Ownership Rows

```text
Child ID:
Role: planner | researcher | generator | evaluator
Goal:
Owned Files:
Allowed Read:
Allowed Changes:
Forbidden Changes:
Expected Evidence:
Required Verification:
Stop Conditions:
Report Contract:
Report Path:
Exhaustion Output: child-report: exhausted
```

## Stop Conditions

Use explicit stop conditions, for example:

- Required file or evidence is outside Allowed Read.
- Needed change is outside Allowed Changes.
- Verification cannot be run or produces inconclusive output.
- Child detects authority conflict, scope conflict, or unsafe side effect.
- Child exhausts available actions.

When a child exhausts available actions, the report must include `child-report: exhausted`.
Parent must not re-dispatch the same goal unchanged.

## Report Contract

Every child report must include:

- changed files, including `none` when no files changed
- evidence refs or exact evidence text
- verification command, exit code, and result, or a reason verification was not run
- stop conditions triggered
- exhaustion status
- recommended parent action

## Merge And Conflict Rules

```text
Merge Rule:
Conflict Rule:
Shared File Rule:
Evaluator Assignment:
Human GO Required For:
```

Rules:

- Generator ownership must be disjoint unless Human explicitly accepts overlap.
- Shared files are parent-owned unless exactly one child owns them.
- Evaluator read scope is automatic and must not be narrowed by Parent.
- Scope expansion must become `blocked: needs-human-decision` until Human approves.
