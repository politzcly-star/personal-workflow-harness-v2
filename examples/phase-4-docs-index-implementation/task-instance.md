# Task Instance: docs navigation/index implementation

## Instance Header

```text
Task ID: phase-4-docs-index-implementation
Task Title: docs navigation/index implementation
Parent Thread: 019ed8e6-1595-7140-9292-f61b30c3dbfb delegated Phase 4 child thread
North Star Version: v1
Current State: accepted
Blocked Reason: none
Next Action: Commit Phase 4 locally; push and PR remain forbidden.
Last Updated: 2026-06-18
```

## North Star Contract

Human-signed North Star is the highest task authority.

```text
Intent: Implement the docs navigation/index improvement in README as the first real low-risk application of the v2 process.
Task Name: docs navigation/index implementation
Non-goals: No source code, runner, scripts, CI, Docker, browser automation, GitHub issue tracker integration, production action, database action, secrets, paid external action, v1 repository access, commit, push, PR, or staging.
Acceptance Criteria:
- README contains a concise Documentation Navigation section.
- Navigation groups include Start Here, Architecture &amp; Protocol, Templates, and Examples &amp; Rehearsals.
- Links point to existing markdown artifacts, including docs, templates, Phase 2 example, Phase 3 rehearsal artifacts, and Phase 4 artifacts.
- README preserves the warning that v2 is a markdown control plane, not runner/CI/automation.
- Phase 4 artifacts record dispatch, child report, evaluator gate card, parent synthesis, and Human Decision placeholder.
Quality Bar: Parent Synthesis factual claims cite the child report or Evidence IDs.
Forbidden Outcomes: Touching .claude/settings.local.json, reading or modifying D:\个人工作流, modifying source code or automation surfaces, changing prior Phase 1/2/3 templates or examples without a P0/P1 blocker, staging, committing, pushing, or opening a PR.
Allowed Changes: README.md; examples/phase-4-docs-index-implementation/task-instance.md; examples/phase-4-docs-index-implementation/dispatch-matrix.md; examples/phase-4-docs-index-implementation/child-report-docs-edit.md; examples/phase-4-docs-index-implementation/evaluator-gate-card.md; examples/phase-4-docs-index-implementation/parent-synthesis.md; examples/phase-4-docs-index-implementation/human-decision.md
Forbidden Changes: .claude/settings.local.json; D:\个人工作流; source code; runner; scripts; CI; Docker; browser automation; GitHub issue tracker integration; production; database; secrets; paid external actions; commit; push; PR; stage
Human GO Required For: Final acceptance, any scope expansion, any Conditional Go follow-up that is not already satisfied, and any change outside Allowed Changes.
```

## Human Signoff

```text
Human Signoff: signed
Confirmation Text: Delegation requested Phase 4 implementation of README docs navigation/index improvement with markdown-only allowed changes and no commit/stage/push/PR.
Confirmed At: 2026-06-18
Recorded By: Codex Phase 4 child thread
```

## Runtime Boundaries

```yaml
ports: []
databases: []
network: []
secrets: []
production: false
browser_state: []
external_paid_actions: false
```

## Control Plane Refs

```text
Dispatch Matrix Ref: examples/phase-4-docs-index-implementation/dispatch-matrix.md
Parent Synthesis Ref: examples/phase-4-docs-index-implementation/parent-synthesis.md
Evaluator Gate Card Refs: examples/phase-4-docs-index-implementation/evaluator-gate-card.md
Context Snapshot Refs: none
Human Decision Ref: examples/phase-4-docs-index-implementation/human-decision.md
```

## Children

```text
Active Children: none

Completed Children:
- Child ID: C-P4-DOCS-EDITOR
  Role: generator
  Status: complete
  Report Ref: examples/phase-4-docs-index-implementation/child-report-docs-edit.md
  Evidence Refs: EV-002, EV-003, EV-004
```

## Evaluator State

```text
Evaluator Assigned: EVAL-P4-DOCS
Current Pass: synthesis-comparison
Decision: Go
Decision Ref: examples/phase-4-docs-index-implementation/evaluator-gate-card.md
Dispute: NONE
```

Evaluator `No-Go` blocks the task. Evaluator `Conditional Go` requires a second lightweight pass before acceptance. Parent cannot override Evaluator findings.

## Conditional Go Conditions

```text
Conditions: none
```

## Open Conflicts

```text
Open Conflicts: none
Authority Conflict Rule: use blocked: authority-conflict if signed North Star, task state, Evaluator decision, allowed scope, evidence status, or Human decision disagree.
```

## Evidence Index

Evidence Index is append-only. Do not delete or rewrite old entries.

```text
Evidence ID: EV-001
Source: task-instance.md
Type: human-decision
Status: open
Summary: Human-signed North Star authorizes a markdown-only Phase 4 README navigation/index implementation.
Reference: examples/phase-4-docs-index-implementation/task-instance.md#human-signoff
Created At: 2026-06-18
Updated By: Codex Phase 4 child thread
Update Reason: Initial Phase 4 task creation.
```

```text
Evidence ID: EV-002
Source: README.md
Type: diff/changed-file
Status: open
Summary: README gained a concise Documentation Navigation section with required groups and artifact links.
Reference: README.md#documentation-navigation
Created At: 2026-06-18
Updated By: C-P4-DOCS-EDITOR
Update Reason: README docs index implementation recorded.
```

```text
Evidence ID: EV-003
Source: child-report-docs-edit.md
Type: child-report
Status: open
Summary: Docs Editor reports the README navigation/index edit and changed files.
Reference: examples/phase-4-docs-index-implementation/child-report-docs-edit.md
Created At: 2026-06-18
Updated By: C-P4-DOCS-EDITOR
Update Reason: Child report recorded.
```

```text
Evidence ID: EV-004
Source: child-report-docs-edit.md
Type: verification
Status: open
Summary: Docs Editor verification records rg --files and key phrase searches for README and Phase 4 artifacts.
Reference: examples/phase-4-docs-index-implementation/child-report-docs-edit.md#verification
Created At: 2026-06-18
Updated By: C-P4-DOCS-EDITOR
Update Reason: Verification evidence recorded.
```

```text
Evidence ID: EV-005
Source: evaluator-gate-card.md
Type: evaluator-finding
Status: open
Summary: Evaluator completed evidence-first and synthesis-comparison passes with Go decision for scope and evidence completeness.
Reference: examples/phase-4-docs-index-implementation/evaluator-gate-card.md
Created At: 2026-06-18
Updated By: EVAL-P4-DOCS
Update Reason: Evaluator finding recorded.
```

```text
Evidence ID: EV-006
Source: parent-synthesis.md
Type: parent-synthesis
Status: open
Summary: Parent Synthesis cites child report and Evidence IDs, then recommends human review.
Reference: examples/phase-4-docs-index-implementation/parent-synthesis.md
Created At: 2026-06-18
Updated By: Parent
Update Reason: Parent synthesis recorded.
```

```text
Evidence ID: EV-007
Source: human-decision.md
Type: human-decision
Status: open
Summary: Human Decision placeholder records that no final user acceptance has been claimed.
Reference: examples/phase-4-docs-index-implementation/human-decision.md
Created At: 2026-06-18
Updated By: Parent
Update Reason: Placeholder recorded pending Human Go, Reject, or Request Follow-up.
```

```text
Evidence ID: EV-008
Source: human-decision.md
Type: human-decision
Status: accepted
Summary: Human explicitly approved Phase 4 local commit with `go,commit,给出下一阶段计划`.
Reference: examples/phase-4-docs-index-implementation/human-decision.md#human-decision-record
Created At: 2026-06-18
Updated By: Parent
Update Reason: Appended Human Go record after explicit user approval; previous Evidence Index entries were not deleted or rewritten.
```
