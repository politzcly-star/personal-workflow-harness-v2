# Task Instance: evidence integrity drill

## Instance Header

```text
Task ID: phase-9-evidence-integrity-drill
Task Title: Evidence Index integrity and scope-change audit recovery drill
Parent Thread: 019ed8e6-1595-7140-9292-f61b30c3dbfb
Child Thread: Phase 9 child executor
North Star Version: v1
Current State: accepted
Simulated Audit Lane State: blocked: needs-human-decision
Blocked Reason: simulated duplicate Evidence ID, missing evidence refs, overwritten evaluator finding, and uncited scope-change must block acceptance.
Next Action: Local Phase 9 commit completed, then plan Phase 10 as a child-executed docs-only rehearsal.
Last Updated: 2026-06-18
```

## North Star Contract

Human-signed North Star is the highest task authority.

```text
Intent: Prove that v2 can audit Evidence Index integrity, scope-change records, and recovery from audit blockers without automation.
Task Name: evidence integrity drill
Non-goals: No runner, CI, Docker, browser automation, source code, production access, secrets, paid actions, push, PR, or v1 repository changes.
Acceptance Criteria:
- Evidence Index is append-only and old entries are never deleted or rewritten.
- Scope changes require a new evidence entry and cannot be smuggled into existing scope.
- Conflicts, evaluator findings, human decisions, and accepted risks each have evidence refs.
- Missing evidence refs, duplicate Evidence ID, overwritten evaluator finding, or uncited scope-change blocks acceptance.
- Parent Synthesis can reconstruct task history from Evidence IDs without chat memory.
Allowed Changes: README.md navigation links; docs/phase-9-evidence-integrity-guide.md; examples/phase-9-evidence-integrity-drill/*.md
Forbidden Changes: .claude/settings.local.json; D:\个人工作流; source code; runner; scripts; CI; Docker; browser automation; GitHub issue tracker integration; production; database; secrets; paid external actions; commit; push; PR; stage
Human GO Required For: Final acceptance and local Phase 9 commit.
```

## Human Signoff

```text
Human Signoff: signed
Confirmation Text: User delegated Phase 9 child execution for an Evidence Index integrity and scope-change audit recovery drill.
Confirmed At: 2026-06-18
Recorded By: Phase 9 child executor
```

## Dispatch And Evaluator State

```text
Dispatch Matrix Ref: examples/phase-9-evidence-integrity-drill/dispatch-matrix.md
Completed Child: C-P9-EVIDENCE-INTEGRITY
Child Report Ref: examples/phase-9-evidence-integrity-drill/child-report-evidence-integrity.md
Evaluator Assigned: EVAL-P9-EVIDENCE-INTEGRITY
Current Pass: synthesis-comparison
Decision: Go for drill completeness; simulated audit blockers remain No-Go until new evidence and Human decision resolve them.
Decision Ref: examples/phase-9-evidence-integrity-drill/evaluator-gate-card.md
Audit Record Ref: examples/phase-9-evidence-integrity-drill/evidence-audit-record.md
Scope Change Ref: examples/phase-9-evidence-integrity-drill/scope-change-record.md
```

## Evidence Index

Evidence Index is append-only. Do not delete or rewrite old entries.

```text
Evidence ID: P9-EV-001
Source: task-instance.md
Type: human-decision
Status: open
Summary: Human-signed North Star authorizes a markdown-only Evidence Index integrity and scope-change audit drill.
Reference: examples/phase-9-evidence-integrity-drill/task-instance.md#human-signoff
Created At: 2026-06-18
Updated By: C-P9-EVIDENCE-INTEGRITY
Update Reason: Initial Phase 9 task creation.
```

```text
Evidence ID: P9-EV-002
Source: dispatch-matrix.md
Type: diff
Status: open
Summary: Dispatch Matrix assigns one child generator and one independent evaluator; Parent cannot assign itself.
Reference: examples/phase-9-evidence-integrity-drill/dispatch-matrix.md
Created At: 2026-06-18
Updated By: C-P9-EVIDENCE-INTEGRITY
Update Reason: Dispatch boundaries recorded.
```

```text
Evidence ID: P9-EV-003
Source: child-report-evidence-integrity.md
Type: child-report
Status: open
Summary: Child Report records Phase 9 docs-only changes, verification requirements, evidence refs, and no exhaustion.
Reference: examples/phase-9-evidence-integrity-drill/child-report-evidence-integrity.md
Created At: 2026-06-18
Updated By: C-P9-EVIDENCE-INTEGRITY
Update Reason: Child execution evidence recorded.
```

```text
Evidence ID: P9-EV-004
Source: evidence-audit-record.md
Type: verification
Status: open
Summary: Evidence Audit Record checks append-only history, duplicate Evidence ID, missing evidence refs, overwritten evaluator finding, and uncited scope-change blockers.
Reference: examples/phase-9-evidence-integrity-drill/evidence-audit-record.md
Created At: 2026-06-18
Updated By: C-P9-EVIDENCE-INTEGRITY
Update Reason: Evidence audit record created.
```

```text
Evidence ID: P9-EV-005
Source: scope-change-record.md
Type: scope-change
Status: open
Summary: Scope-change is recorded as a new evidence entry and is not smuggled into existing scope.
Reference: examples/phase-9-evidence-integrity-drill/scope-change-record.md
Created At: 2026-06-18
Updated By: C-P9-EVIDENCE-INTEGRITY
Update Reason: Scope-change recovery lane recorded.
```

```text
Evidence ID: P9-EV-006
Source: evaluator-gate-card.md
Type: evaluator-finding
Status: open
Summary: Evaluator records evidence-first No-Go lanes for duplicate Evidence ID, missing evidence refs, overwritten evaluator finding, and uncited scope-change, then synthesis-comparison Go for drill completeness.
Reference: examples/phase-9-evidence-integrity-drill/evaluator-gate-card.md
Created At: 2026-06-18
Updated By: EVAL-P9-EVIDENCE-INTEGRITY
Update Reason: Evaluator audit findings recorded.
```

```text
Evidence ID: P9-EV-007
Source: parent-synthesis.md
Type: parent-synthesis
Status: open
Summary: Parent Synthesis reconstructs task history from P9 Evidence IDs without chat memory.
Reference: examples/phase-9-evidence-integrity-drill/parent-synthesis.md
Created At: 2026-06-18
Updated By: Parent
Update Reason: Parent synthesis draft recorded.
```

```text
Evidence ID: P9-EV-008
Source: human-decision.md
Type: human-decision
Status: open
Summary: Human Decision placeholder records that Phase 9 is not accepted or committed.
Reference: examples/phase-9-evidence-integrity-drill/human-decision.md
Created At: 2026-06-18
Updated By: C-P9-EVIDENCE-INTEGRITY
Update Reason: Human decision placeholder recorded.
```

```text
Evidence ID: P9-EV-009
Source: evidence-audit-record.md
Type: conflict
Status: disputed
Summary: Simulated audit conflict records that old evidence cannot be rewritten; recovery must append a new evidence entry or Human decision.
Reference: examples/phase-9-evidence-integrity-drill/evidence-audit-record.md#audit-conflict-lanes
Created At: 2026-06-18
Updated By: C-P9-EVIDENCE-INTEGRITY
Update Reason: Negative audit lane recorded without changing prior evidence entries.
```

```text
Evidence ID: P9-EV-010
Source: human-decision.md
Type: human-decision
Status: accepted-risk
Summary: accepted-risk is documented as a future Human-only recovery option; no risk is accepted for Phase 9 yet.
Reference: examples/phase-9-evidence-integrity-drill/human-decision.md#accepted-risk-placeholder
Created At: 2026-06-18
Updated By: C-P9-EVIDENCE-INTEGRITY
Update Reason: Accepted-risk placeholder recorded as evidence, not as acceptance.
```

```text
Evidence ID: P9-EV-011
Source: human-decision.md
Type: human-decision
Status: resolved
Summary: Human explicitly approved Phase 9 local commit with `go,commit,给出下一阶段计划`; push and PR remain unauthorized.
Reference: examples/phase-9-evidence-integrity-drill/human-decision.md#decision-state
Created At: 2026-06-18
Updated By: Parent
Update Reason: Appended Human Go after explicit user approval; prior Evidence Index entries and evaluator findings were not deleted or rewritten.
```
