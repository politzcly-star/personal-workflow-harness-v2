# Task Instance: evaluator dispute recovery drill

## Instance Header

```text
Task ID: phase-8-evaluator-dispute-recovery-drill
Task Title: evaluator dispute and human decision recovery drill
Parent Thread: 019ed8e6-1595-7140-9292-f61b30c3dbfb
Child Thread: Phase 8 child executor
North Star Version: v1
Current State: accepted
Simulated Dispute Lane State: blocked: needs-human-decision
Blocked Reason: simulated Evaluator No-Go is disputed by Parent and requires Human decision recovery.
Next Action: Commit Phase 8 locally, then dispatch Phase 9 evidence integrity drill to a child thread.
Last Updated: 2026-06-18
```

## North Star Contract

Human-signed North Star is the highest task authority.

```text
Intent: Prove that v2 handles Evaluator No-Go, Parent disagreement, and Human decision recovery without Parent override.
Task Name: evaluator dispute recovery drill
Non-goals: No runner, CI, Docker, browser automation, source code, production access, secrets, paid actions, push, PR, or v1 repository changes.
Acceptance Criteria:
- Evaluator No-Go blocks acceptance and Parent cannot reject or override it.
- Parent disagreement becomes Evaluator Dispute, then blocked: needs-human-decision.
- Human decision recovery records Go, Reject, accepted-risk, or follow-up without rewriting Evaluator findings.
- Parent Synthesis distinguishes facts, evaluator findings, disputes, and human decisions using Evidence IDs only.
- Missing dispute evidence, overwritten evaluator findings, or fake Human acceptance blocks acceptance.
Allowed Changes: README.md navigation links; docs/phase-8-evaluator-dispute-guide.md; examples/phase-8-evaluator-dispute-recovery-drill/*.md
Forbidden Changes: .claude/settings.local.json; D:\个人工作流; source code; runner; scripts; CI; Docker; browser automation; GitHub issue tracker integration; production; database; secrets; paid external actions; commit; push; PR; stage
Human GO Required For: Final acceptance and local Phase 8 commit.
```

## Human Signoff

```text
Human Signoff: signed
Confirmation Text: User delegated Phase 8 child execution for an evaluator dispute and human decision recovery drill.
Confirmed At: 2026-06-18
Recorded By: Phase 8 child executor
```

## Dispatch And Evaluator State

```text
Dispatch Matrix Ref: examples/phase-8-evaluator-dispute-recovery-drill/dispatch-matrix.md
Completed Child: C-P8-EVALUATOR-DISPUTE
Child Report Ref: examples/phase-8-evaluator-dispute-recovery-drill/child-report-evaluator-dispute.md
Evaluator Assigned: EVAL-P8-EVALUATOR-DISPUTE
Current Pass: synthesis-comparison
Decision: Go for drill completeness; simulated lane remains blocked until Human decision.
Decision Ref: examples/phase-8-evaluator-dispute-recovery-drill/evaluator-gate-card.md
Dispute: EVALUATOR-DISPUTE-P8-001
Dispute Ref: examples/phase-8-evaluator-dispute-recovery-drill/evaluator-dispute-record.md
```

## Evidence Index

Evidence Index is append-only. Do not delete or rewrite old entries.

```text
Evidence ID: P8-EV-001
Source: task-instance.md
Type: human-decision
Status: open
Summary: Human-signed North Star authorizes a markdown-only evaluator dispute recovery drill.
Reference: examples/phase-8-evaluator-dispute-recovery-drill/task-instance.md#human-signoff
Created At: 2026-06-18
Updated By: C-P8-EVALUATOR-DISPUTE
Update Reason: Initial Phase 8 task creation.
```

```text
Evidence ID: P8-EV-002
Source: dispatch-matrix.md
Type: diff
Status: open
Summary: Dispatch Matrix assigns one child generator and one independent evaluator; Parent cannot assign itself.
Reference: examples/phase-8-evaluator-dispute-recovery-drill/dispatch-matrix.md
Created At: 2026-06-18
Updated By: C-P8-EVALUATOR-DISPUTE
Update Reason: Dispatch boundaries recorded.
```

```text
Evidence ID: P8-EV-003
Source: child-report-evaluator-dispute.md
Type: child-report
Status: open
Summary: Child Report records Phase 8 docs-only changes, verification requirements, evidence refs, and no exhaustion.
Reference: examples/phase-8-evaluator-dispute-recovery-drill/child-report-evaluator-dispute.md
Created At: 2026-06-18
Updated By: C-P8-EVALUATOR-DISPUTE
Update Reason: Child execution evidence recorded.
```

```text
Evidence ID: P8-EV-004
Source: evaluator-gate-card.md
Type: evaluator-finding
Status: open
Summary: Evaluator records evidence-first No-Go for the simulated lane and synthesis-comparison review for drill completeness.
Reference: examples/phase-8-evaluator-dispute-recovery-drill/evaluator-gate-card.md
Created At: 2026-06-18
Updated By: EVAL-P8-EVALUATOR-DISPUTE
Update Reason: Evaluator finding recorded.
```

```text
Evidence ID: P8-EV-005
Source: evaluator-dispute-record.md
Type: conflict
Status: disputed
Summary: Parent disagreement is recorded as Evaluator Dispute without rejecting or overriding the Evaluator No-Go.
Reference: examples/phase-8-evaluator-dispute-recovery-drill/evaluator-dispute-record.md
Created At: 2026-06-18
Updated By: Parent
Update Reason: Parent dispute route recorded.
```

```text
Evidence ID: P8-EV-006
Source: human-decision-recovery-record.md
Type: human-decision
Status: open
Summary: Recovery options are Go, Reject, accepted-risk, or follow-up, and none rewrites Evaluator findings.
Reference: examples/phase-8-evaluator-dispute-recovery-drill/human-decision-recovery-record.md
Created At: 2026-06-18
Updated By: C-P8-EVALUATOR-DISPUTE
Update Reason: Human recovery path recorded.
```

```text
Evidence ID: P8-EV-007
Source: parent-synthesis.md
Type: parent-synthesis
Status: open
Summary: Parent Synthesis distinguishes facts, evaluator findings, disputes, and human decisions using Evidence IDs only.
Reference: examples/phase-8-evaluator-dispute-recovery-drill/parent-synthesis.md
Created At: 2026-06-18
Updated By: Parent
Update Reason: Parent synthesis draft recorded.
```

```text
Evidence ID: P8-EV-008
Source: human-decision.md
Type: human-decision
Status: open
Summary: Human Decision placeholder records that Phase 8 is not accepted or committed.
Reference: examples/phase-8-evaluator-dispute-recovery-drill/human-decision.md
Created At: 2026-06-18
Updated By: C-P8-EVALUATOR-DISPUTE
Update Reason: Human decision placeholder recorded.
```

```text
Evidence ID: P8-EV-009
Source: human-decision.md
Type: human-decision
Status: resolved
Summary: Human approved Phase 8 local commit with `go,commit,给出下一阶段计划`; push and PR remain unauthorized.
Reference: examples/phase-8-evaluator-dispute-recovery-drill/human-decision.md#decision-state
Created At: 2026-06-18
Updated By: Parent
Update Reason: Appended Human Go after explicit user approval; previous Evidence Index entries and evaluator findings were not deleted or rewritten.
```
