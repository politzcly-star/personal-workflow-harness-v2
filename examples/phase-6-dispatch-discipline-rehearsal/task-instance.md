# Task Instance: dispatch discipline rehearsal

## Instance Header

```text
Task ID: phase-6-dispatch-discipline-rehearsal
Task Title: dispatch discipline rehearsal
Parent Thread: 019ed8e6-1595-7140-9292-f61b30c3dbfb
Child Thread: Phase 6 child executor
North Star Version: v1
Current State: accepted
Blocked Reason: none
Next Action: Commit Phase 6 locally, then dispatch Phase 7 context handoff rehearsal to a child thread.
Last Updated: 2026-06-18
```

## North Star Contract

Human-signed North Star is the highest task authority.

```text
Intent: Prove that v2 Phase 6 uses child execution for generator work, independent evaluator review, and evidence-cited parent synthesis.
Task Name: dispatch discipline rehearsal
Non-goals: No runner, CI, Docker, browser automation, source code, production access, secrets, paid actions, push, PR, or v1 repository changes.
Acceptance Criteria:
- Parent prepares dispatch but does not self-assign as generator or evaluator.
- Child performs the controlled docs-only task and records verification in a Child Report.
- Evaluator performs evidence-first and synthesis-comparison independently.
- Parent Synthesis cites only Child Reports and Evidence IDs.
- Parent-direct implementation attempt records blocked: authority-conflict unless Human explicitly records accepted-risk.
Allowed Changes: README.md navigation links; docs/phase-6-dispatch-discipline-guide.md; examples/phase-6-dispatch-discipline-rehearsal/*.md
Forbidden Changes: .claude/settings.local.json; D:\个人工作流; source code; runner; scripts; CI; Docker; browser automation; GitHub issue tracker integration; production; database; secrets; paid external actions; commit; push; PR; stage
Human GO Required For: Final acceptance and local Phase 6 commit.
```

## Human Signoff

```text
Human Signoff: signed
Confirmation Text: Parent delegated Phase 6 child execution to correct parent-direct implementation drift.
Confirmed At: 2026-06-18
Recorded By: Phase 6 child executor
```

## Dispatch And Evaluator State

```text
Dispatch Matrix Ref: examples/phase-6-dispatch-discipline-rehearsal/dispatch-matrix.md
Completed Child: C-P6-DISPATCH-DISCIPLINE
Child Report Ref: examples/phase-6-dispatch-discipline-rehearsal/child-report-dispatch-discipline.md
Evaluator Assigned: EVAL-P6-DISPATCH-DISCIPLINE
Current Pass: synthesis-comparison
Decision: Go for artifact completeness
Decision Ref: examples/phase-6-dispatch-discipline-rehearsal/evaluator-gate-card.md
Dispute: NONE
```

## Evidence Index

Evidence Index is append-only. Do not delete or rewrite old entries.

```text
Evidence ID: P6-EV-001
Source: task-instance.md
Type: human-decision
Status: open
Summary: Human-signed North Star authorizes a markdown-only dispatch discipline rehearsal.
Reference: examples/phase-6-dispatch-discipline-rehearsal/task-instance.md#human-signoff
Created At: 2026-06-18
Updated By: C-P6-DISPATCH-DISCIPLINE
Update Reason: Initial Phase 6 task creation.
```

```text
Evidence ID: P6-EV-002
Source: dispatch-matrix.md
Type: diff
Status: open
Summary: Dispatch Matrix assigns one child generator and one independent evaluator; Parent cannot assign itself.
Reference: examples/phase-6-dispatch-discipline-rehearsal/dispatch-matrix.md
Created At: 2026-06-18
Updated By: C-P6-DISPATCH-DISCIPLINE
Update Reason: Dispatch discipline recorded.
```

```text
Evidence ID: P6-EV-003
Source: child-report-dispatch-discipline.md
Type: child-report
Status: open
Summary: Child report records docs-only changes, verification commands, evidence refs, and no exhaustion.
Reference: examples/phase-6-dispatch-discipline-rehearsal/child-report-dispatch-discipline.md
Created At: 2026-06-18
Updated By: C-P6-DISPATCH-DISCIPLINE
Update Reason: Child execution evidence recorded.
```

```text
Evidence ID: P6-EV-004
Source: evaluator-gate-card.md
Type: evaluator-finding
Status: open
Summary: Evaluator records evidence-first and synthesis-comparison passes and the Go / Conditional Go / No-Go blocking rules.
Reference: examples/phase-6-dispatch-discipline-rehearsal/evaluator-gate-card.md
Created At: 2026-06-18
Updated By: EVAL-P6-DISPATCH-DISCIPLINE
Update Reason: Evaluator finding recorded.
```

```text
Evidence ID: P6-EV-005
Source: parent-synthesis.md
Type: parent-synthesis
Status: open
Summary: Parent Synthesis cites child report and Evidence IDs, not chat memory.
Reference: examples/phase-6-dispatch-discipline-rehearsal/parent-synthesis.md
Created At: 2026-06-18
Updated By: Parent
Update Reason: Parent synthesis draft recorded.
```

```text
Evidence ID: P6-EV-006
Source: human-decision.md
Type: human-decision
Status: open
Summary: Human Decision placeholder records that Phase 6 has not been accepted or committed.
Reference: examples/phase-6-dispatch-discipline-rehearsal/human-decision.md
Created At: 2026-06-18
Updated By: C-P6-DISPATCH-DISCIPLINE
Update Reason: Human decision placeholder recorded.
```

```text
Evidence ID: P6-EV-007
Source: human-decision.md
Type: human-decision
Status: resolved
Summary: Human approved Phase 6 local commit with `go，commit，给出下一阶段计划`; push and PR remain unauthorized.
Reference: examples/phase-6-dispatch-discipline-rehearsal/human-decision.md#decision-state
Created At: 2026-06-18
Updated By: Parent
Update Reason: Appended Human Go after explicit user approval; previous Evidence Index entries were not deleted or rewritten.
```
