# Parent Agent Protocol

This protocol defines what the Parent Agent may do, what it must not do, and
how it coordinates Child agents, Evaluator, artifacts, and Human decisions.

## Parent May

- Draft North Star Contract.
- Draft Dispatch Matrix.
- Dispatch Child Goals.
- Read and summarize Child Reports.
- Create Parent Synthesis.
- Prepare Human Acceptance Summary.
- Maintain v2 control-plane artifacts.

## Parent Must Not

- Start implementation before Human signoff.
- Assign itself as Generator or Evaluator.
- Directly modify managed business files outside the signed scope.
- Reject or override Evaluator `No-Go`.
- Override Evaluator findings.
- Expand allowed changes without Human signoff.
- Modify a signed North Star.
- Delete or rewrite existing Evidence Index entries.
- Replace child verification or evaluator evidence with chat memory.

Parent cannot assign itself.

## Human Signoff

Parent may draft the North Star, but it becomes active only after explicit Human
signoff.

Valid signoff requires:

- explicit Human confirmation such as `Go`, `agree`, `confirm`, or equivalent
- recorded confirmation text
- timestamp
- recorder identity

Without valid signoff, task state must remain `proposed` or
`blocked: needs-human-signoff`.

## Dispatch Matrix Schema

```text
Dispatch ID:
Parent Task:
North Star Version:
Human Signoff:
Children:
  - Child ID:
    Role: planner | generator | evaluator | researcher
    Goal:
    Owned Files:
    Allowed Read:
    Allowed Changes:
    Forbidden Changes:
    Expected Evidence:
    Verification:
    Stop Conditions:
    Report Path:
Evaluator Assignment:
Conflict Rule:
Merge Rule:
Human GO Required For:
```

Rules:

- Parent cannot assign itself as `generator` or `evaluator`.
- Generator ownership must be disjoint unless Human explicitly accepts overlap.
- Evaluator read scope is automatic and must not be narrowed by Parent.
- Shared files are parent-owned unless exactly one child owns them.
- Stop conditions and report contract must be explicit before child work starts.

## Child Goal Schema

```text
Child ID:
Role: planner | generator | evaluator | researcher
Parent Task:
Goal:
Allowed Read:
Allowed Changes:
Forbidden Changes:
Expected Evidence:
Verification:
Stop Conditions:
Report Contract:
Self-Verification Result:
Exhaustion Rule:
```

If a child triggers a stop condition or exhausts available actions, it must
output `child-report: exhausted`. Parent must not re-dispatch the same goal
unchanged.

## Child Report Schema

```text
Child ID:
Role:
Goal:
Status: complete | blocked | exhausted | failed
Changed Files:
Evidence:
Verification:
Self-Verification Result:
Findings:
Open Questions:
Stop Conditions Triggered:
Recommended Parent Action:
```

Child test results and verification evidence must be written into the report.
Parent must not infer pass/fail from chat memory.

## Evaluator Rules

Evaluator is an independent quality gate.

Evaluator may read:

- Human-signed North Star
- Task State
- Dispatch Matrix
- all Generator modified files
- full diff
- all Child Reports
- verification outputs
- relevant project facts
- Evidence Index

Evaluator must use two passes:

1. `evidence-first`: read raw evidence, diff, child reports, verification
   output, project facts, and North Star before reading Parent Synthesis.
2. `synthesis-comparison`: read Parent Synthesis only after the first pass,
   treating it as Parent's statement rather than source truth.

## Evaluator Decision Schema

```text
Evaluator ID:
Pass Type: evidence-first | synthesis-comparison | conditional-followup
Input Artifacts:
Decision: Go | Conditional Go | No-Go
Findings:
Conditions:
Evidence Gaps:
Disputes:
Timestamp:
```

Rules:

- `No-Go` blocks the task.
- Parent cannot reject or override Evaluator findings.
- Parent may record `Evaluator Dispute` only by entering
  `blocked: needs-human-decision`.
- `Conditional Go` requires a follow-up Evaluator pass.
- A task cannot become `accepted` until Conditional Go conditions are verified.
- Evidence Index append-only violations are blockers.

## Parent Synthesis Schema

```text
Input Reports:
Accepted Findings:
Conflicts:
Evaluator State:
Evidence Refs:
Scope Changes:
Remaining Uncertainty:
Recommended Human Decision:
```

Parent Synthesis must cite evidence refs, not memory.

## Evidence Index Rules

Evidence Index is append-only.

```text
Evidence ID:
Source:
Type: diff | child-report | verification | evaluator-finding | human-decision | conflict | scope-change
Status: open | resolved | disputed | accepted-risk
Summary:
Reference:
Created At:
Updated By:
Update Reason:
```

Do not delete, rewrite, renumber, duplicate, or silently reclassify entries.
Status changes must append an update record with reason and timestamp.

Evaluator may issue `No-Go` when Evidence Index omits P0/P1 findings, scope
changes, conflicts, or Evaluator findings.

## Authority Conflict

Use `blocked: authority-conflict` when authoritative artifacts disagree about:

- signed North Star content
- current task state
- Evaluator decision
- allowed scope
- evidence status
- Human decision

Parent must request Human resolution instead of choosing the convenient source.
