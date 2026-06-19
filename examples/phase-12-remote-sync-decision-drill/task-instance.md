# Task Instance: remote-sync decision drill

## Instance Header

```text
Task ID: phase-12-remote-sync-decision-drill
Task Title: Remote-Sync Decision / Authorization Expiry Drill
Parent Thread: 019ed8e6-1595-7140-9292-f61b30c3dbfb
Child Thread: Phase 12 child executor
North Star Version: v1
Current State: accepted
Simulated Remote-Sync Lane State: blocked: needs-human-decision
Blocked Reason: remote-sync requires separate Human Go; authorization expires or blocks when commit range changes, staged files appear, .claude/ or unexpected files enter release scope, evidence refs are missing, scope changes are unreviewed, or fake remote approval appears.
Next Action: Phase 12 local commit completed, then plan Phase 13 remote-sync execution handoff drill. Push and PR remain unauthorized.
Last Updated: 2026-06-19
```

## North Star Contract

Human-signed North Star is the highest task authority.

```text
Intent: Prove that v2 can represent remote-sync decision validity and authorization expiry without performing push/PR.
Task Name: remote-sync decision drill
Non-goals: No runner, CI, Docker, browser automation, source code, production access, secrets, paid actions, push, PR, or v1 repository changes.
Acceptance Criteria:
- local commit Go is not push/PR authorization.
- separate Human Go is valid only for an explicit origin/master..HEAD commit range, clean status, and complete evidence refs.
- authorization expires or blocks if commit range changes, staged files appear, .claude/ or unexpected files enter release scope, evidence refs are missing, scope changes are unreviewed, or fake remote approval appears.
- Human Decision remains pending; Phase 12 performs no push/PR.
Allowed Changes: README.md navigation links; docs/phase-12-remote-sync-decision-guide.md; examples/phase-12-remote-sync-decision-drill/*.md
Forbidden Changes: .claude/settings.local.json; v1 repository; source code; runner; scripts; CI; Docker; browser automation; GitHub issue tracker integration; production; database; secrets; paid external actions; commit; push; PR; stage
Human GO Required For: Final local acceptance and any future remote-sync action.
```

## Human Signoff

```text
Human Signoff: signed
Confirmation Text: User delegated Phase 12 child execution for a Remote-Sync Decision / Authorization Expiry Drill.
Confirmed At: 2026-06-19
Recorded By: Phase 12 child executor
```

## Dispatch And Evaluator State

```text
Dispatch Matrix Ref: examples/phase-12-remote-sync-decision-drill/dispatch-matrix.md
Completed Child: C-P12-REMOTE-SYNC-DECISION
Child Report Ref: examples/phase-12-remote-sync-decision-drill/child-report-remote-sync-decision.md
Evaluator Assigned: EVAL-P12-REMOTE-SYNC-DECISION
Current Pass: synthesis-comparison
Decision: Go for drill completeness; simulated remote-sync authorization remains No-Go until separate Human Go and current release evidence resolve it.
Decision Ref: examples/phase-12-remote-sync-decision-drill/evaluator-gate-card.md
Remote-Sync Decision Request Ref: examples/phase-12-remote-sync-decision-drill/remote-sync-decision-request.md
```

## Evidence Index

Evidence Index is append-only. Do not delete or rewrite old entries.

```text
Evidence ID: P12-EV-001
Source: task-instance.md
Type: human-decision
Status: open
Summary: Human-signed North Star authorizes a markdown-only remote-sync decision and authorization expiry drill.
Reference: examples/phase-12-remote-sync-decision-drill/task-instance.md#human-signoff
Created At: 2026-06-19
Updated By: C-P12-REMOTE-SYNC-DECISION
Update Reason: Initial Phase 12 task creation.
```

```text
Evidence ID: P12-EV-002
Source: dispatch-matrix.md
Type: diff
Status: open
Summary: Dispatch Matrix assigns one child generator and one independent evaluator; Parent cannot assign itself.
Reference: examples/phase-12-remote-sync-decision-drill/dispatch-matrix.md
Created At: 2026-06-19
Updated By: C-P12-REMOTE-SYNC-DECISION
Update Reason: Dispatch boundaries recorded.
```

```text
Evidence ID: P12-EV-003
Source: child-report-remote-sync-decision.md
Type: child-report
Status: open
Summary: Child Report records Phase 12 docs-only changes, verification requirements, evidence refs, and no exhaustion.
Reference: examples/phase-12-remote-sync-decision-drill/child-report-remote-sync-decision.md
Created At: 2026-06-19
Updated By: C-P12-REMOTE-SYNC-DECISION
Update Reason: Child execution evidence recorded.
```

```text
Evidence ID: P12-EV-004
Source: remote-sync-decision-request.md
Type: verification
Status: open
Summary: Remote-Sync Decision Request records origin/master..HEAD, validity requirements, expiry triggers, excluded local state, and authorization state.
Reference: examples/phase-12-remote-sync-decision-drill/remote-sync-decision-request.md
Created At: 2026-06-19
Updated By: C-P12-REMOTE-SYNC-DECISION
Update Reason: Remote-sync decision request recorded.
```

```text
Evidence ID: P12-EV-005
Source: evaluator-gate-card.md
Type: evaluator-finding
Status: open
Summary: Evaluator records evidence-first No-Go lanes for changed commit range, dirty staged files, .claude in release scope, unexpected release files, missing evidence refs, unreviewed scope change, and fake remote approval.
Reference: examples/phase-12-remote-sync-decision-drill/evaluator-gate-card.md
Created At: 2026-06-19
Updated By: EVAL-P12-REMOTE-SYNC-DECISION
Update Reason: Evaluator remote-sync decision findings recorded.
```

```text
Evidence ID: P12-EV-006
Source: parent-synthesis.md
Type: parent-synthesis
Status: open
Summary: Parent Synthesis reconstructs remote-sync decision readiness and expiry state from P12 Evidence IDs without chat memory.
Reference: examples/phase-12-remote-sync-decision-drill/parent-synthesis.md
Created At: 2026-06-19
Updated By: Parent
Update Reason: Parent synthesis draft recorded.
```

```text
Evidence ID: P12-EV-007
Source: human-decision.md
Type: human-decision
Status: open
Summary: Human Decision placeholder records that Phase 12 is not accepted for local commit and push / PR Authorized: no.
Reference: examples/phase-12-remote-sync-decision-drill/human-decision.md
Created At: 2026-06-19
Updated By: C-P12-REMOTE-SYNC-DECISION
Update Reason: Human decision placeholder recorded.
```

```text
Evidence ID: P12-EV-008
Source: remote-sync-decision-request.md
Type: conflict
Status: disputed
Summary: Simulated authorization expiry and remote-sync blockers require separate Human Go and current evidence before any push or PR.
Reference: examples/phase-12-remote-sync-decision-drill/remote-sync-decision-request.md#authorization-expiry-triggers
Created At: 2026-06-19
Updated By: C-P12-REMOTE-SYNC-DECISION
Update Reason: Negative authorization expiry lanes recorded without remote action.
```

```text
Evidence ID: P12-EV-009
Source: remote-sync-decision-request.md
Type: verification
Status: open
Summary: Decision request records Phase 1-11 local commit range and clean-status requirements for future remote-sync authorization review.
Reference: examples/phase-12-remote-sync-decision-drill/remote-sync-decision-request.md#commit-range-and-status
Created At: 2026-06-19
Updated By: C-P12-REMOTE-SYNC-DECISION
Update Reason: Local commit range and validity criteria recorded.
```

```text
Evidence ID: P12-EV-010
Source: human-decision.md
Type: human-decision
Status: resolved
Summary: Human approved Phase 12 for local commit only; push and PR remain unauthorized until separate Human Go with evidence ref.
Reference: examples/phase-12-remote-sync-decision-drill/human-decision.md
Created At: 2026-06-19
Updated By: Parent
Update Reason: Recorded explicit local-commit Go without changing remote-sync authorization state.
```
