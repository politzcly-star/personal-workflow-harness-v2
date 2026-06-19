# Task Instance: route selection readiness drill

## Instance Header

```text
Task ID: phase-17-route-selection-readiness-drill
Task Title: Remote-Sync Route Selection Readiness / Evidence Refresh Drill
Parent Thread: Phase 17 parent thread
Child Thread: Phase 17 child executor
North Star Version: v1
Current State: accepted
Route Selection State: blocked: needs-future-human-route-selection
Remote-Sync Authorization State: blocked: route-selection-readiness-only
Blocked Reason: Phase 17 refreshes evidence for future review only; selected route is none; push / PR Authorized: no.
Next Action: Phase 17 local commit completed / Phase 18 planning. Future Human may review refreshed evidence and separately choose push or PR, but no route selection, push, PR, remote command, network remote action, or release is authorized now.
Last Updated: 2026-06-19
```

## North Star Contract

Human-signed North Star is the highest task authority.

```text
Intent: Prepare a markdown-only Remote-Sync Route Selection Readiness / Evidence Refresh Drill for a future Human route decision without selecting a route or authorizing push/PR.
Task Name: route selection readiness drill
Non-goals: No route selection, push, PR, remote command, network remote action, release, stage, commit, source code, runner, scripts, CI, Docker, browser automation, GitHub issue tracker integration, production, database, secrets, paid external actions, v1 repository access, or .claude/ edits.
Acceptance Criteria:
- Phase 16 local commit does not authorize push/PR or select a route.
- A future route decision must re-check current HEAD, branch, remote URL, origin/master..HEAD, staged area, working tree, .claude/ exclusion, and complete evidence refs.
- Push route and PR route are mutually exclusive unless Human explicitly splits them into separate decisions.
- Authorization expires if HEAD, branch, remote URL, staged area, working tree, evidence refs, or route wording changes after review.
- Missing route selection, stale evidence, ambiguous push-vs-PR wording, fake route Go, dirty staged files, missing evidence ref, unresolved No-Go, or local-only state in release scope blocks route selection.
- Human Decision remains pending; push / PR Authorized: no; no remote/network action occurred.
- Parent Synthesis claims cite only Child Report or P17-EV-* Evidence IDs.
- Evaluator Gate Card includes evidence-first and synthesis-comparison passes.
- Evidence Index uses append-only style and P17-EV-* IDs are unique.
Allowed Changes: README.md Phase 17 navigation links only; docs/phase-17-route-selection-readiness-guide.md; examples/phase-17-route-selection-readiness-drill/task-instance.md; examples/phase-17-route-selection-readiness-drill/dispatch-matrix.md; examples/phase-17-route-selection-readiness-drill/child-report-route-selection-readiness.md; examples/phase-17-route-selection-readiness-drill/route-selection-readiness-record.md; examples/phase-17-route-selection-readiness-drill/evidence-refresh-checklist.md; examples/phase-17-route-selection-readiness-drill/evaluator-gate-card.md; examples/phase-17-route-selection-readiness-drill/parent-synthesis.md; examples/phase-17-route-selection-readiness-drill/human-decision.md
Forbidden Changes: .claude/settings.local.json; .claude/ files; v1 repository reads or writes; source code; runner; scripts; CI; Docker; browser automation; GitHub issue tracker integration; production; database; secrets; paid external actions; stage; commit; push; PR; remote command; network remote action; release; Phase 1-16 artifacts except README Phase 17 navigation links.
Human GO Required For: any future route selection, local acceptance beyond this drill, stage, commit, push, PR, remote command, network remote action, release, or remote-sync authorization as separate decisions.
```

## Human Signoff

```text
Human Signoff: signed for markdown-only route selection readiness drill execution
Confirmation Text: User delegated Phase 17 child execution for a Remote-Sync Route Selection Readiness / Evidence Refresh Drill and explicitly forbade stage, commit, push, PR, remote command execution, network remote action, release, .claude/ edits, v1 repository access, and Phase 1-16 artifact edits except README Phase 17 navigation links.
Confirmed At: 2026-06-19
Recorded By: Phase 17 child executor
```

## Dispatch And Evaluator State

```text
Dispatch Matrix Ref: examples/phase-17-route-selection-readiness-drill/dispatch-matrix.md
Completed Child: C-P17-ROUTE-SELECTION-READINESS
Child Report Ref: examples/phase-17-route-selection-readiness-drill/child-report-route-selection-readiness.md
Evaluator Assigned: EVAL-P17-ROUTE-SELECTION-READINESS
Current Pass: synthesis-comparison
Decision: Go for paper readiness package completeness; route selection and remote-sync authorization remain No-Go until explicit future Human route selection with current evidence.
Decision Ref: examples/phase-17-route-selection-readiness-drill/evaluator-gate-card.md
Route Selection Readiness Record Ref: examples/phase-17-route-selection-readiness-drill/route-selection-readiness-record.md
Evidence Refresh Checklist Ref: examples/phase-17-route-selection-readiness-drill/evidence-refresh-checklist.md
```

## Evidence Index

Evidence Index is append-only style. Do not delete, rewrite, renumber, or silently reclassify old entries. `P17-EV-*` IDs must be unique.

```text
Evidence ID: P17-EV-001
Source: task-instance.md
Type: human-decision
Status: open
Summary: Human-signed North Star authorizes a markdown-only route selection readiness drill and forbids route selection, stage, commit, push, PR, remote commands, network remote action, release, v1 repository access, and .claude/ edits.
Reference: examples/phase-17-route-selection-readiness-drill/task-instance.md#human-signoff
Created At: 2026-06-19
Updated By: C-P17-ROUTE-SELECTION-READINESS
Update Reason: Initial Phase 17 task creation.
```

```text
Evidence ID: P17-EV-002
Source: dispatch-matrix.md
Type: diff
Status: open
Summary: Dispatch Matrix assigns one child generator and one independent evaluator; Parent cannot assign itself and cannot authorize route selection, push, PR, remote command, network remote action, or release.
Reference: examples/phase-17-route-selection-readiness-drill/dispatch-matrix.md
Created At: 2026-06-19
Updated By: C-P17-ROUTE-SELECTION-READINESS
Update Reason: Dispatch boundaries recorded.
```

```text
Evidence ID: P17-EV-003
Source: phase-17-route-selection-readiness-guide.md
Type: guide
Status: open
Summary: Guide records route selection readiness, evidence refresh requirements, route mutual exclusion, authorization expires triggers, blockers, evaluator passes, append-only Evidence Index rule, and pending Human Decision state.
Reference: docs/phase-17-route-selection-readiness-guide.md
Created At: 2026-06-19
Updated By: C-P17-ROUTE-SELECTION-READINESS
Update Reason: Phase 17 guide created.
```

```text
Evidence ID: P17-EV-004
Source: route-selection-readiness-record.md
Type: readiness-record
Status: open
Summary: Route Selection Readiness Record binds future review to refreshed HEAD, branch, remote URL, origin/master..HEAD, staged area, working tree, .claude/ exclusion, complete evidence refs, and exact route wording.
Reference: examples/phase-17-route-selection-readiness-drill/route-selection-readiness-record.md
Created At: 2026-06-19
Updated By: C-P17-ROUTE-SELECTION-READINESS
Update Reason: Route selection readiness requirements recorded.
```

```text
Evidence ID: P17-EV-005
Source: evidence-refresh-checklist.md
Type: checklist
Status: open
Summary: Evidence Refresh Checklist lists local commands and artifact checks required before future Human route selection.
Reference: examples/phase-17-route-selection-readiness-drill/evidence-refresh-checklist.md
Created At: 2026-06-19
Updated By: C-P17-ROUTE-SELECTION-READINESS
Update Reason: Evidence refresh checklist recorded.
```

```text
Evidence ID: P17-EV-006
Source: child-report-route-selection-readiness.md
Type: child-report
Status: open
Summary: Child Report records Phase 17 docs-only changes, required validation command results, forbidden-scope check, Human Decision state, remaining risk, and parent acceptance recommendation.
Reference: examples/phase-17-route-selection-readiness-drill/child-report-route-selection-readiness.md
Created At: 2026-06-19
Updated By: C-P17-ROUTE-SELECTION-READINESS
Update Reason: Child execution evidence recorded.
```

```text
Evidence ID: P17-EV-007
Source: evaluator-gate-card.md
Type: evaluator-finding
Status: open
Summary: Evaluator records evidence-first and synthesis-comparison passes and treats route selection blockers as No-Go until recovered with current evidence.
Reference: examples/phase-17-route-selection-readiness-drill/evaluator-gate-card.md
Created At: 2026-06-19
Updated By: EVAL-P17-ROUTE-SELECTION-READINESS
Update Reason: Evaluator route readiness findings recorded.
```

```text
Evidence ID: P17-EV-008
Source: parent-synthesis.md
Type: parent-synthesis
Status: open
Summary: Parent Synthesis reconstructs Phase 17 state from Child Report and P17 Evidence IDs without chat memory.
Reference: examples/phase-17-route-selection-readiness-drill/parent-synthesis.md
Created At: 2026-06-19
Updated By: Parent
Update Reason: Parent synthesis draft recorded.
```

```text
Evidence ID: P17-EV-009
Source: human-decision.md
Type: human-decision
Status: open
Summary: Human Decision placeholder remains pending; selected route is none; push / PR Authorized: no; remote action unauthorized; no release authorized.
Reference: examples/phase-17-route-selection-readiness-drill/human-decision.md
Created At: 2026-06-19
Updated By: C-P17-ROUTE-SELECTION-READINESS
Update Reason: Human decision placeholder recorded.
```

```text
Evidence ID: P17-EV-010
Source: child-report-route-selection-readiness.md
Type: verification
Status: open
Summary: Local baseline evidence verifies current HEAD, branch master, origin URL, origin/master..HEAD local commit range, clean staged area, and excluded .claude/ local-only state.
Reference: examples/phase-17-route-selection-readiness-drill/child-report-route-selection-readiness.md#verification
Created At: 2026-06-19
Updated By: C-P17-ROUTE-SELECTION-READINESS
Update Reason: Required local git evidence recorded.
```

```text
Evidence ID: P17-EV-011
Source: child-report-route-selection-readiness.md
Type: verification
Status: open
Summary: Required keyword search, README link target check, Parent Synthesis citation check, P17-EV-* uniqueness check, and scope check were run and recorded.
Reference: examples/phase-17-route-selection-readiness-drill/child-report-route-selection-readiness.md#verification
Created At: 2026-06-19
Updated By: C-P17-ROUTE-SELECTION-READINESS
Update Reason: Validation evidence recorded.
```

```text
Evidence ID: P17-EV-012
Source: route-selection-readiness-record.md
Type: recovery
Status: open
Summary: Future authorization expires if HEAD, branch, remote URL, staged area, working tree, evidence refs, or route wording changes after review.
Reference: examples/phase-17-route-selection-readiness-drill/route-selection-readiness-record.md#authorization-expiry
Created At: 2026-06-19
Updated By: C-P17-ROUTE-SELECTION-READINESS
Update Reason: Authorization expiry lanes recorded.
```

```text
Evidence ID: P17-EV-013
Source: README.md
Type: diff
Status: open
Summary: README navigation adds Phase 17 guide and drill artifact links only.
Reference: README.md#documentation-navigation
Created At: 2026-06-19
Updated By: C-P17-ROUTE-SELECTION-READINESS
Update Reason: Phase 17 navigation links recorded.
```

```text
Evidence ID: P17-EV-014
Source: route-selection-readiness-record.md
Type: boundary
Status: open
Summary: Phase 16 local commit does not authorize push/PR or select a route; Phase 17 does not change that state.
Reference: examples/phase-17-route-selection-readiness-drill/route-selection-readiness-record.md#phase-16-boundary
Created At: 2026-06-19
Updated By: C-P17-ROUTE-SELECTION-READINESS
Update Reason: Phase 16-to-Phase 17 boundary recorded.
```

```text
Evidence ID: P17-EV-015
Source: human-decision.md
Type: human-decision
Status: resolved
Summary: Human approved Phase 17 local readiness package completeness only; selected route remains none, route selection remains missing, push / PR Authorized remains no, and remote-sync authorization remains not granted.
Reference: examples/phase-17-route-selection-readiness-drill/human-decision.md
Created At: 2026-06-19
Updated By: Parent
Update Reason: Recorded explicit local readiness package completeness Go without changing route selection or remote authorization state.
```
