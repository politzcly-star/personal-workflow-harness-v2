# Dispatch Matrix: evidence integrity drill

## Parent Boundary

```text
Parent Role: control-plane coordinator
Parent May: dispatch child, read child report, request evaluator review, synthesize evidence refs, prepare Human acceptance summary.
Parent Must Not: self-assign as Generator or Evaluator; edit outside Allowed Changes; stage; commit; push; PR; rewrite Evidence Index; overwrite evaluator finding; smuggle scope-change into old scope.
Parent cannot assign itself.
```

## Child Ownership

```text
Child ID: C-P9-EVIDENCE-INTEGRITY
Role: generator
Goal: Add Phase 9 evidence integrity guide, audit drill artifacts, scope-change record, and README navigation links.
Allowed Read: README.md; docs/*.md; templates/*.md; examples/phase-1 through phase-8 markdown artifacts; examples/phase-9-evidence-integrity-drill/*.md
Allowed Changes: README.md navigation links; docs/phase-9-evidence-integrity-guide.md; examples/phase-9-evidence-integrity-drill/*.md
Forbidden Changes: .claude/settings.local.json; D:\个人工作流; source code; runner; scripts; CI; Docker; browser automation; GitHub issue tracker integration; production; database; secrets; paid external actions; commit; push; PR; stage; Phase 1/2/3/4/5/6/7/8 docs, templates, or examples except README navigation additions
Required Verification: git status --short --branch; git ls-files --modified --others --exclude-standard; git diff --cached --name-only; key phrase search; README markdown link target check; Parent Synthesis citation check; Evidence ID uniqueness check; allowed scope comparison; git diff --check
Stop Conditions: need to edit outside Allowed Changes; need to stage, commit, push, or PR; duplicate Evidence ID cannot be represented safely; missing evidence refs cannot be recorded; overwritten evaluator finding; uncited scope-change; verification unavailable; child-report: exhausted
Report Path: examples/phase-9-evidence-integrity-drill/child-report-evidence-integrity.md
```

## Evaluator Assignment

```text
Evaluator ID: EVAL-P9-EVIDENCE-INTEGRITY
Role: evaluator
Allowed Read: Human-signed North Star, Task Instance, Dispatch Matrix, Child Report, Evidence Audit Record, Scope Change Record, verification outputs, diff, Evidence Index, Parent Synthesis after evidence-first
Passes: evidence-first, synthesis-comparison, optional evidence-recovery-followup
Decision Set: Go, Conditional Go, No-Go
No-Go Rule: duplicate Evidence ID, missing evidence refs, overwritten evaluator finding, or uncited scope-change blocks acceptance.
Conditional Go Rule: narrow missing audit evidence requires follow-up evaluator pass before acceptance.
Go Rule: Scope, evidence, child verification, evaluator independence, scope-change records, and synthesis citations are complete.
```

## Audit Recovery Rule

```text
Evidence Rewrite Allowed: no
append-only Required: yes
scope-change Evidence Required: yes
accepted-risk Requires Human: yes
Chat Memory As Audit Evidence: invalid
Recovery Options: append correction evidence, append scope-change, append evaluator-finding, append human-decision, or remain blocked.
```

