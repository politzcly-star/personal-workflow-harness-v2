# Task Instance: release gate drill

## Instance Header

```text
Task ID: phase-10-release-gate-drill
Task Title: Release Gate / Remote-Sync Readiness Drill
Parent Thread: 019ed8e6-1595-7140-9292-f61b30c3dbfb
Child Thread: Phase 10 child executor
North Star Version: v1
Current State: accepted
Simulated Release Lane State: blocked: needs-human-decision
Blocked Reason: remote-sync requires separate Human Go; fake push approval, dirty staged files, missing release evidence, unreviewed scope change, and unexpected files block release.
Next Action: Phase 10 local commit completed, then plan Phase 11 release packet drill. Push and PR remain unauthorized until separate Human Go.
Last Updated: 2026-06-19
```

## North Star Contract

Human-signed North Star is the highest task authority.

```text
Intent: Prove that v2 can distinguish local commit acceptance from remote push/PR authorization and can block unsafe release state without automation.
Task Name: release gate drill
Non-goals: No runner, CI, Docker, browser automation, source code, production access, secrets, paid actions, push, PR, or v1 repository changes.
Acceptance Criteria:
- local commit acceptance is not push/PR authorization.
- push/PR requires a separate Human Go with an evidence ref.
- Release Gate Checklist can reconstruct Phase 1-9 commit/evidence status without chat memory.
- .claude/settings.local.json and other local state are excluded from release scope.
- dirty staged files, missing release evidence, fake push approval, unreviewed scope change, and unexpected files block the release gate.
Allowed Changes: README.md navigation links; docs/phase-10-release-gate-guide.md; examples/phase-10-release-gate-drill/*.md
Forbidden Changes: .claude/settings.local.json; v1 repository; source code; runner; scripts; CI; Docker; browser automation; GitHub issue tracker integration; production; database; secrets; paid external actions; commit; push; PR; stage
Human GO Required For: Final acceptance and any future remote-sync action.
```

## Human Signoff

```text
Human Signoff: signed
Confirmation Text: User delegated Phase 10 child execution for a Release Gate / Remote-Sync Readiness Drill.
Confirmed At: 2026-06-18
Recorded By: Phase 10 child executor
```

## Dispatch And Evaluator State

```text
Dispatch Matrix Ref: examples/phase-10-release-gate-drill/dispatch-matrix.md
Completed Child: C-P10-RELEASE-GATE
Child Report Ref: examples/phase-10-release-gate-drill/child-report-release-gate.md
Evaluator Assigned: EVAL-P10-RELEASE-GATE
Current Pass: synthesis-comparison
Decision: Go for drill completeness; simulated release blockers remain No-Go until separate Human Go and release evidence resolve them.
Decision Ref: examples/phase-10-release-gate-drill/evaluator-gate-card.md
Release Checklist Ref: examples/phase-10-release-gate-drill/release-gate-checklist.md
```

## Evidence Index

Evidence Index is append-only. Do not delete or rewrite old entries.

```text
Evidence ID: P10-EV-001
Source: task-instance.md
Type: human-decision
Status: open
Summary: Human-signed North Star authorizes a markdown-only release gate and remote-sync readiness drill.
Reference: examples/phase-10-release-gate-drill/task-instance.md#human-signoff
Created At: 2026-06-18
Updated By: C-P10-RELEASE-GATE
Update Reason: Initial Phase 10 task creation.
```

```text
Evidence ID: P10-EV-002
Source: dispatch-matrix.md
Type: diff
Status: open
Summary: Dispatch Matrix assigns one child generator and one independent evaluator; Parent cannot assign itself.
Reference: examples/phase-10-release-gate-drill/dispatch-matrix.md
Created At: 2026-06-18
Updated By: C-P10-RELEASE-GATE
Update Reason: Dispatch boundaries recorded.
```

```text
Evidence ID: P10-EV-003
Source: child-report-release-gate.md
Type: child-report
Status: open
Summary: Child Report records Phase 10 docs-only changes, verification requirements, evidence refs, and no exhaustion.
Reference: examples/phase-10-release-gate-drill/child-report-release-gate.md
Created At: 2026-06-18
Updated By: C-P10-RELEASE-GATE
Update Reason: Child execution evidence recorded.
```

```text
Evidence ID: P10-EV-004
Source: release-gate-checklist.md
Type: verification
Status: open
Summary: Release Gate Checklist reconstructs Phase 1-9 commit status, ahead count, staged file status, local-state exclusion, and release approval status.
Reference: examples/phase-10-release-gate-drill/release-gate-checklist.md
Created At: 2026-06-18
Updated By: C-P10-RELEASE-GATE
Update Reason: Release checklist recorded.
```

```text
Evidence ID: P10-EV-005
Source: evaluator-gate-card.md
Type: evaluator-finding
Status: open
Summary: Evaluator records evidence-first No-Go lanes for dirty staged files, missing release evidence, fake push approval, unreviewed scope change, and unexpected files.
Reference: examples/phase-10-release-gate-drill/evaluator-gate-card.md
Created At: 2026-06-18
Updated By: EVAL-P10-RELEASE-GATE
Update Reason: Evaluator release findings recorded.
```

```text
Evidence ID: P10-EV-006
Source: parent-synthesis.md
Type: parent-synthesis
Status: open
Summary: Parent Synthesis reconstructs release readiness from P10 Evidence IDs without chat memory.
Reference: examples/phase-10-release-gate-drill/parent-synthesis.md
Created At: 2026-06-18
Updated By: Parent
Update Reason: Parent synthesis draft recorded.
```

```text
Evidence ID: P10-EV-007
Source: human-decision.md
Type: human-decision
Status: open
Summary: Human Decision placeholder records that Phase 10 is not accepted for local commit and push / PR Authorized: no.
Reference: examples/phase-10-release-gate-drill/human-decision.md
Created At: 2026-06-18
Updated By: C-P10-RELEASE-GATE
Update Reason: Human decision placeholder recorded.
```

```text
Evidence ID: P10-EV-008
Source: release-gate-checklist.md
Type: conflict
Status: disputed
Summary: Simulated remote-sync blockers require separate Human Go and clean release evidence before any push or PR.
Reference: examples/phase-10-release-gate-drill/release-gate-checklist.md#blocking-release-lanes
Created At: 2026-06-18
Updated By: C-P10-RELEASE-GATE
Update Reason: Negative release lanes recorded without remote action.
```

```text
Evidence ID: P10-EV-009
Source: release-gate-checklist.md
Type: verification
Status: open
Summary: Commit inventory records Phase 1-9 local commits and ahead count for release readiness review.
Reference: examples/phase-10-release-gate-drill/release-gate-checklist.md#commit-inventory
Created At: 2026-06-18
Updated By: C-P10-RELEASE-GATE
Update Reason: Local commit inventory recorded.
```

```text
Evidence ID: P10-EV-010
Source: human-decision.md
Type: human-decision
Status: resolved
Summary: Human explicitly approved Phase 10 local commit only; local commit acceptance is not push/PR authorization, and remote-sync still requires separate Human Go with evidence ref.
Reference: examples/phase-10-release-gate-drill/human-decision.md#decision-state
Created At: 2026-06-19
Updated By: Parent
Update Reason: Appended local-commit Go after explicit user approval; prior Evidence Index entries, evaluator findings, and release gate blockers were not deleted or rewritten.
```
