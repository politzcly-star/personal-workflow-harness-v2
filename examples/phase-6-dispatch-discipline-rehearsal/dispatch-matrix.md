# Dispatch Matrix: dispatch discipline rehearsal

## Parent Boundary

```text
Parent Responsibilities:
- Prepare North Star, dispatch scope, and acceptance criteria.
- Read child report and evaluator finding.
- Produce Parent Synthesis using only child reports and Evidence IDs.
- Ask Human for final Go before commit.

Parent Forbidden:
- Parent cannot assign itself.
- Parent cannot assign itself as generator or evaluator.
- Parent cannot perform generator-owned docs implementation.
- Parent cannot reject Evaluator No-Go.
- Parent cannot accept unresolved Conditional Go.
- Parent cannot use accepted-risk unless Human explicitly names and accepts the risk.
```

## Child Ownership

```text
Child ID: C-P6-DISPATCH-DISCIPLINE
Role: generator
Goal: Add Phase 6 dispatch discipline guide, rehearsal artifacts, and README navigation links.
Allowed Read: README.md; docs/*.md; templates/*.md; examples/phase-1 through phase-5 markdown artifacts; examples/phase-6-dispatch-discipline-rehearsal/*.md
Allowed Changes: README.md navigation links; docs/phase-6-dispatch-discipline-guide.md; examples/phase-6-dispatch-discipline-rehearsal/*.md
Forbidden Changes: .claude/settings.local.json; D:\个人工作流; source code; runner; scripts; CI; Docker; browser automation; GitHub issue tracker integration; production; database; secrets; paid external actions; commit; push; PR; stage; Phase 1/2/3/4/5 docs, templates, or examples except README navigation additions
Required Verification: git status --short --branch; git ls-files --modified --others --exclude-standard; git diff --cached --name-only; key phrase search; README markdown link target check; allowed scope comparison
Stop Conditions: need to edit outside Allowed Changes; need to stage, commit, push, or PR; parent-direct implementation attempt without accepted-risk; verification unavailable; child-report: exhausted
Report Path: examples/phase-6-dispatch-discipline-rehearsal/child-report-dispatch-discipline.md
```

## Evaluator Assignment

```text
Evaluator ID: EVAL-P6-DISPATCH-DISCIPLINE
Role: evaluator
Allowed Read: Human-signed North Star, Task Instance, Dispatch Matrix, Child Report, verification outputs, diff, Evidence Index, Parent Synthesis after evidence-first
Passes: evidence-first, synthesis-comparison
Decision Set: Go, Conditional Go, No-Go
No-Go Rule: Missing child report, self-assigned Parent generator/evaluator, forbidden scope, or missing evidence refs blocks acceptance.
Conditional Go Rule: Narrow missing evidence requires follow-up evaluator pass before acceptance.
Go Rule: Scope, evidence, child verification, evaluator independence, and synthesis citations are complete.
```

## Authority Conflict Rule

```text
Parent-Direct Implementation Attempt: blocked: authority-conflict
Accepted-Risk Exception: allowed only when Human explicitly records accepted-risk for the named parent-direct implementation risk.
Evidence Required: append-only Evidence Index entry with reason and timestamp.
```
