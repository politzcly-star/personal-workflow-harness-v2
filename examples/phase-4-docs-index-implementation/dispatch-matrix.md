# Dispatch Matrix: docs navigation/index implementation

## Header

```text
Dispatch ID: D-P4-DOCS-001
Task Instance Ref: examples/phase-4-docs-index-implementation/task-instance.md
North Star Version: v1
Human Signoff Ref: examples/phase-4-docs-index-implementation/task-instance.md#human-signoff
Parent Thread: 019ed8e6-1595-7140-9292-f61b30c3dbfb delegated Phase 4 child thread
Created At: 2026-06-18
```

## Parent Boundary

```text
Parent Responsibilities:
- Maintain the Phase 4 control-plane artifacts.
- Assign exactly one child for the README docs edit.
- Synthesize only from child report evidence and Evidence Index refs.
- Escalate conflicts and scope changes to Human.

Parent Forbidden:
- Parent cannot assign itself.
- Parent cannot assign itself as generator or evaluator.
- Parent cannot modify files outside the Phase 4 Allowed Changes.
- Parent cannot replace child verification evidence with chat memory.
```

## Child Ownership Rows

```text
Child ID: C-P4-DOCS-EDITOR
Role: generator
Goal: Implement the README Documentation Navigation section and record the markdown-only Phase 4 evidence chain.
Owned Files: README.md; examples/phase-4-docs-index-implementation/*.md
Allowed Read: README.md; docs/*.md; templates/*.md; examples/phase-2-paper-drill.md; examples/phase-3-docs-index-rehearsal/*.md; examples/phase-4-docs-index-implementation/*.md
Allowed Changes: README.md; examples/phase-4-docs-index-implementation/task-instance.md; examples/phase-4-docs-index-implementation/dispatch-matrix.md; examples/phase-4-docs-index-implementation/child-report-docs-edit.md; examples/phase-4-docs-index-implementation/evaluator-gate-card.md; examples/phase-4-docs-index-implementation/parent-synthesis.md; examples/phase-4-docs-index-implementation/human-decision.md
Forbidden Changes: .claude/settings.local.json; D:\个人工作流; source code; runner; scripts; CI; Docker; browser automation; GitHub issue tracker integration; production; database; secrets; paid external actions; commit; push; PR; stage; Phase 1/2/3 templates or examples
Expected Evidence: README diff summary, changed-file list, and verification command outputs.
Required Verification: rg --files; key phrase searches for required control-plane and README navigation phrases; git status scope check.
Stop Conditions: required link target missing; required change outside Allowed Changes; authority conflict; verification unavailable or inconclusive; accidental forbidden file modification; need to stage, commit, push, PR, or read v1.
Report Contract: include Changed Files, evidence refs, verification commands with exit code and output summary, stop conditions checked, exhaustion status, and recommended parent action.
Report Path: examples/phase-4-docs-index-implementation/child-report-docs-edit.md
Exhaustion Output: child-report: exhausted
```

## Stop Conditions

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
Merge Rule: One child owns README docs navigation/index implementation and the Phase 4 artifact record.
Conflict Rule: If authoritative artifacts disagree, set task state to blocked: authority-conflict and request Human decision.
Shared File Rule: README.md is child-owned for this task only; other README sections remain preserved unless needed for the navigation insertion.
Evaluator Assignment: EVAL-P4-DOCS reviews evidence-first before synthesis-comparison.
Human GO Required For: Final acceptance, scope expansion, Conditional Go follow-up not already satisfied, and any forbidden/uncertain operation.
```
