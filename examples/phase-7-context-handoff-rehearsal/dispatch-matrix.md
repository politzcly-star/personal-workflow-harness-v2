# Dispatch Matrix: context handoff rehearsal

## Parent Boundary

```text
Parent Responsibilities:
- Prepare North Star, dispatch scope, handoff acceptance criteria, and final Human Acceptance Summary.
- Read child report, snapshot, recovery record, and evaluator finding.
- Produce Parent Synthesis using only Child Reports and Evidence IDs.
- Ask Human for final Go before commit.

Parent Forbidden:
- Parent cannot assign itself.
- Parent cannot assign itself as generator or evaluator.
- Parent cannot replace reload paths with chat memory.
- Parent cannot reject Evaluator No-Go.
- Parent cannot accept unresolved Conditional Go.
- Parent cannot ignore child-report: exhausted during compression or recovery.
```

## Child Ownership

```text
Child ID: C-P7-CONTEXT-HANDOFF
Role: generator
Goal: Add Phase 7 context handoff guide, rehearsal artifacts, Context Compression Snapshot, Handoff Recovery Record, and README navigation links.
Allowed Read: README.md; docs/*.md; templates/*.md; examples/phase-1 through phase-6 markdown artifacts; examples/phase-7-context-handoff-rehearsal/*.md
Allowed Changes: README.md navigation links; docs/phase-7-context-handoff-guide.md; examples/phase-7-context-handoff-rehearsal/*.md
Forbidden Changes: .claude/settings.local.json; D:\个人工作流; source code; runner; scripts; CI; Docker; browser automation; GitHub issue tracker integration; production; database; secrets; paid external actions; commit; push; PR; stage; Phase 1/2/3/4/5/6 docs, templates, or examples except README navigation additions
Required Verification: git status --short --branch; git ls-files --modified --others --exclude-standard; git diff --cached --name-only; key phrase search; README markdown link target check; Parent Synthesis citation check; allowed scope comparison; git diff --check
Stop Conditions: need to edit outside Allowed Changes; need to stage, commit, push, or PR; missing reload path for an omitted required detail; dropped unresolved finding; verification unavailable; child-report: exhausted
Report Path: examples/phase-7-context-handoff-rehearsal/child-report-context-handoff.md
```

## Evaluator Assignment

```text
Evaluator ID: EVAL-P7-CONTEXT-HANDOFF
Role: evaluator
Allowed Read: Human-signed North Star, Task Instance, Dispatch Matrix, Child Report, Context Compression Snapshot, Handoff Recovery Record, verification outputs, diff, Evidence Index, Parent Synthesis after evidence-first
Passes: evidence-first, synthesis-comparison
Decision Set: Go, Conditional Go, No-Go
No-Go Rule: Missing reload path, dropped unresolved finding, missing child report, self-assigned Parent generator/evaluator, forbidden scope, or missing evidence refs blocks acceptance.
Conditional Go Rule: Narrow missing reload path or citation can be repaired under allowed scope, then checked by follow-up evaluator pass before acceptance.
Go Rule: Snapshot, recovery record, child verification, evaluator independence, and synthesis citations are complete.
```

## Handoff Recovery Rule

```text
Context Compression Snapshot: mandatory before handoff/resume when active child reports or Evaluator findings exist.
Chat Memory: non-authority; may help locate artifacts only.
Missing Reload Path: No-Go.
Dropped Unresolved Finding: blocked: authority-conflict when artifacts disagree; otherwise No-Go.
Evidence Required: append-only Evidence Index entry with reason and timestamp.
```

