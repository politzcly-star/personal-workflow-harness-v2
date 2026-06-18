# Task Instance: context handoff rehearsal

## Instance Header

```text
Task ID: phase-7-context-handoff-rehearsal
Task Title: context compression and handoff recovery rehearsal
Parent Thread: 019ed8e6-1595-7140-9292-f61b30c3dbfb
Child Thread: Phase 7 child executor
North Star Version: v1
Current State: accepted
Blocked Reason: none
Next Action: Commit Phase 7 locally, then dispatch Phase 8 evaluator dispute recovery drill to a child thread.
Last Updated: 2026-06-18
```

## North Star Contract

Human-signed North Star is the highest task authority.

```text
Intent: Prove that v2 can survive context compression, parent handoff, and resume by reloading artifacts instead of relying on chat memory.
Task Name: context handoff rehearsal
Non-goals: No runner, CI, Docker, browser automation, source code, production access, secrets, paid actions, push, PR, or v1 repository changes.
Acceptance Criteria:
- Context Compression Snapshot is mandatory before handoff/resume when active child reports or Evaluator findings exist.
- Snapshot preserves unresolved P0/P1, conflicts, scope changes, Evaluator findings, Conditional Go conditions, child-report: exhausted, and full reload path details.
- Parent handoff recovery uses artifacts as authority, not chat memory.
- Evaluator compares pre-handoff evidence with post-resume Parent Synthesis through evidence-first and synthesis-comparison.
- Missing reload path or dropped unresolved finding blocks acceptance through No-Go or blocked: authority-conflict.
Allowed Changes: README.md navigation links; docs/phase-7-context-handoff-guide.md; examples/phase-7-context-handoff-rehearsal/*.md
Forbidden Changes: .claude/settings.local.json; D:\个人工作流; source code; runner; scripts; CI; Docker; browser automation; GitHub issue tracker integration; production; database; secrets; paid external actions; commit; push; PR; stage
Human GO Required For: Final acceptance and local Phase 7 commit.
```

## Human Signoff

```text
Human Signoff: signed
Confirmation Text: Parent delegated Phase 7 child execution for a docs-only context compression and handoff recovery rehearsal.
Confirmed At: 2026-06-18
Recorded By: Phase 7 child executor
```

## Dispatch And Evaluator State

```text
Dispatch Matrix Ref: examples/phase-7-context-handoff-rehearsal/dispatch-matrix.md
Completed Child: C-P7-CONTEXT-HANDOFF
Child Report Ref: examples/phase-7-context-handoff-rehearsal/child-report-context-handoff.md
Snapshot Ref: examples/phase-7-context-handoff-rehearsal/context-compression-snapshot.md
Recovery Ref: examples/phase-7-context-handoff-rehearsal/handoff-recovery-record.md
Evaluator Assigned: EVAL-P7-CONTEXT-HANDOFF
Current Pass: synthesis-comparison
Decision: Go for artifact completeness
Decision Ref: examples/phase-7-context-handoff-rehearsal/evaluator-gate-card.md
Dispute: NONE
```

## Evidence Index

Evidence Index is append-only. Do not delete or rewrite old entries.

```text
Evidence ID: P7-EV-001
Source: task-instance.md
Type: human-decision
Status: open
Summary: Human-signed North Star authorizes a markdown-only context handoff rehearsal.
Reference: examples/phase-7-context-handoff-rehearsal/task-instance.md#human-signoff
Created At: 2026-06-18
Updated By: C-P7-CONTEXT-HANDOFF
Update Reason: Initial Phase 7 task creation.
```

```text
Evidence ID: P7-EV-002
Source: dispatch-matrix.md
Type: diff
Status: open
Summary: Dispatch Matrix assigns one child generator and one independent evaluator; Parent cannot assign itself.
Reference: examples/phase-7-context-handoff-rehearsal/dispatch-matrix.md
Created At: 2026-06-18
Updated By: C-P7-CONTEXT-HANDOFF
Update Reason: Dispatch discipline recorded.
```

```text
Evidence ID: P7-EV-003
Source: child-report-context-handoff.md
Type: child-report
Status: open
Summary: Child report records docs-only changes, verification commands, evidence refs, and no exhaustion.
Reference: examples/phase-7-context-handoff-rehearsal/child-report-context-handoff.md
Created At: 2026-06-18
Updated By: C-P7-CONTEXT-HANDOFF
Update Reason: Child execution evidence recorded.
```

```text
Evidence ID: P7-EV-004
Source: context-compression-snapshot.md
Type: verification
Status: open
Summary: Context Compression Snapshot preserves required handoff state and reload paths.
Reference: examples/phase-7-context-handoff-rehearsal/context-compression-snapshot.md
Created At: 2026-06-18
Updated By: C-P7-CONTEXT-HANDOFF
Update Reason: Snapshot evidence recorded.
```

```text
Evidence ID: P7-EV-005
Source: handoff-recovery-record.md
Type: verification
Status: open
Summary: Handoff Recovery Record reloads artifacts in authority order and rejects chat memory as authority.
Reference: examples/phase-7-context-handoff-rehearsal/handoff-recovery-record.md
Created At: 2026-06-18
Updated By: C-P7-CONTEXT-HANDOFF
Update Reason: Recovery evidence recorded.
```

```text
Evidence ID: P7-EV-006
Source: evaluator-gate-card.md
Type: evaluator-finding
Status: open
Summary: Evaluator records evidence-first and synthesis-comparison passes and No-Go / Conditional Go blocking rules.
Reference: examples/phase-7-context-handoff-rehearsal/evaluator-gate-card.md
Created At: 2026-06-18
Updated By: EVAL-P7-CONTEXT-HANDOFF
Update Reason: Evaluator finding recorded.
```

```text
Evidence ID: P7-EV-007
Source: parent-synthesis.md
Type: parent-synthesis
Status: open
Summary: Parent Synthesis cites child report and P7 Evidence IDs, not chat memory.
Reference: examples/phase-7-context-handoff-rehearsal/parent-synthesis.md
Created At: 2026-06-18
Updated By: Parent
Update Reason: Parent synthesis draft recorded.
```

```text
Evidence ID: P7-EV-008
Source: human-decision.md
Type: human-decision
Status: open
Summary: Human Decision placeholder records that Phase 7 has not been accepted or committed.
Reference: examples/phase-7-context-handoff-rehearsal/human-decision.md
Created At: 2026-06-18
Updated By: C-P7-CONTEXT-HANDOFF
Update Reason: Human decision placeholder recorded.
```

```text
Evidence ID: P7-EV-009
Source: human-decision.md
Type: human-decision
Status: resolved
Summary: Human approved Phase 7 local commit with `go，commit，给出下一阶段计划`; push and PR remain unauthorized.
Reference: examples/phase-7-context-handoff-rehearsal/human-decision.md#decision-state
Created At: 2026-06-18
Updated By: Parent
Update Reason: Appended Human Go after explicit user approval; previous Evidence Index entries were not deleted or rewritten.
```
