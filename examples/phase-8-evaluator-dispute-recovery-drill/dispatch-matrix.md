# Dispatch Matrix: evaluator dispute recovery drill

## Parent Boundary

```text
Parent Responsibilities:
- Prepare North Star, dispatch scope, and acceptance criteria.
- Read child report and evaluator findings.
- Record Evaluator Dispute when Parent disagrees with Evaluator.
- Produce Parent Synthesis using only child reports and Evidence IDs.
- Ask Human for final Go before commit.

Parent Forbidden:
- Parent cannot assign itself.
- Parent cannot assign itself as generator or evaluator.
- Parent cannot reject Evaluator No-Go.
- Parent cannot override, delete, rewrite, or weaken Evaluator findings.
- Parent cannot accept unresolved Conditional Go.
- Parent cannot claim Human Go from chat memory or fake Human acceptance.
- Parent cannot use accepted-risk unless Human explicitly names and accepts the risk.
```

## Child Ownership

```text
Child ID: C-P8-EVALUATOR-DISPUTE
Role: generator
Goal: Add Phase 8 evaluator dispute guide, recovery drill artifacts, and README navigation links.
Allowed Read: README.md; docs/*.md; templates/*.md; examples/phase-1 through phase-7 markdown artifacts; examples/phase-8-evaluator-dispute-recovery-drill/*.md
Allowed Changes: README.md navigation links; docs/phase-8-evaluator-dispute-guide.md; examples/phase-8-evaluator-dispute-recovery-drill/*.md
Forbidden Changes: .claude/settings.local.json; D:\个人工作流; source code; runner; scripts; CI; Docker; browser automation; GitHub issue tracker integration; production; database; secrets; paid external actions; commit; push; PR; stage; Phase 1/2/3/4/5/6/7 docs, templates, or examples except README navigation additions
Required Verification: git status --short --branch; git ls-files --modified --others --exclude-standard; git diff --cached --name-only; key phrase search; README markdown link target check; Parent Synthesis citation check; allowed scope comparison; git diff --check
Stop Conditions: need to edit outside Allowed Changes; need to stage, commit, push, or PR; missing dispute evidence; overwritten evaluator finding; fake Human acceptance; verification unavailable; child-report: exhausted
Report Path: examples/phase-8-evaluator-dispute-recovery-drill/child-report-evaluator-dispute.md
```

## Evaluator Assignment

```text
Evaluator ID: EVAL-P8-EVALUATOR-DISPUTE
Role: evaluator
Allowed Read: Human-signed North Star, Task Instance, Dispatch Matrix, Child Report, verification outputs, diff, Evidence Index, Evaluator Dispute Record, Human Decision Recovery Record, Parent Synthesis after evidence-first
Passes: evidence-first, synthesis-comparison, optional human-decision-followup
Decision Set: Go, Conditional Go, No-Go
No-Go Rule: Evaluator No-Go blocks acceptance; Parent cannot reject or override it.
Conditional Go Rule: Narrow missing evidence requires follow-up evaluator pass before acceptance.
Go Rule: Scope, evidence, child verification, evaluator independence, dispute handling, and synthesis citations are complete.
```

## Dispute Recovery Rule

```text
Parent Disagreement: Evaluator Dispute
Required State: blocked: needs-human-decision
Parent Override Allowed: no
Recovery Options: Go, Reject, accepted-risk, follow-up
Evidence Required: append-only Evidence Index entry with reason, timestamp, and Human decision reference.
```

