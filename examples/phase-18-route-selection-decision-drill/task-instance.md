# Task Instance: route selection decision drill

## Instance Header

```text
Task ID: phase-18-route-selection-decision-drill
Task Title: Route Selection Decision Capture / Single-Route Binding Drill
Parent Thread: Phase 18 parent thread
Child Thread: Phase 18 child executor
North Star Version: v1
Current State: accepted
Route Selection Decision State: blocked: needs-future-human-route-selection
Single-Route Binding State: unbound
Remote-Sync Authorization State: blocked: decision-capture-only
Blocked Reason: Phase 18 defines future route selection decision capture only; Selected Route: none; push / PR Authorized: no.
Next Action: Phase 18 local commit completed / Phase 19 planning. Future Human may separately select exactly one route, push or PR, with current evidence, but no route selection, push, PR, remote command, network remote action, or release is authorized now.
Last Updated: 2026-06-19
```

## North Star Contract

Human-signed North Star is the highest task authority.

```text
Intent: Implement a markdown-only Route Selection Decision Capture / Single-Route Binding Drill that defines how a future Human route decision is captured, validated, and blocked when ambiguous.
Task Name: route selection decision drill
Non-goals: No real route selection, push, PR, remote command, network remote action, release, stage, commit, source code, runner, scripts, CI, Docker, browser automation, GitHub issue tracker integration, production, database, secrets, paid external actions, v1 repository access, or .claude/ edits.
Acceptance Criteria:
- Phase 17 local commit does not select push or PR.
- A valid future route decision must choose exactly one route: push or PR.
- Ambiguous route wording, dual-route approval, stale evidence, fake route Go, missing evidence refs, dirty staged files, unresolved No-Go, changed HEAD/range/remote, or local-only state in release scope blocks route decision capture.
- Route selection remains separate from execution; even a valid future route selection does not itself execute push/PR.
- Human Decision remains pending; Selected Route: none; push / PR Authorized: no; no remote/network action occurs.
- Parent Synthesis claims cite only Child Report or P18-EV-* Evidence IDs.
- Evaluator Gate Card includes evidence-first and synthesis-comparison passes.
- Evidence Index uses append-only style and P18-EV-* IDs are unique.
Allowed Changes: README.md Phase 18 navigation links only; docs/phase-18-route-selection-decision-guide.md; examples/phase-18-route-selection-decision-drill/task-instance.md; examples/phase-18-route-selection-decision-drill/dispatch-matrix.md; examples/phase-18-route-selection-decision-drill/child-report-route-selection-decision.md; examples/phase-18-route-selection-decision-drill/route-selection-decision-packet.md; examples/phase-18-route-selection-decision-drill/single-route-binding-record.md; examples/phase-18-route-selection-decision-drill/ambiguity-rejection-checklist.md; examples/phase-18-route-selection-decision-drill/evaluator-gate-card.md; examples/phase-18-route-selection-decision-drill/parent-synthesis.md; examples/phase-18-route-selection-decision-drill/human-decision.md
Forbidden Changes: .claude/settings.local.json; .claude/ files; v1 repository reads or writes; source code; runner; scripts; CI; Docker; browser automation; GitHub issue tracker integration; production; database; secrets; paid external actions; stage; commit; push; PR; remote command; network remote action; release; Phase 1-17 artifacts except README Phase 18 navigation links.
Human GO Required For: any future route selection, single-route binding acceptance beyond this drill, stage, commit, push, PR, remote command, network remote action, release, or remote-sync authorization as separate decisions.
```

## Human Signoff

```text
Human Signoff: signed for markdown-only route selection decision capture drill execution
Confirmation Text: User delegated Phase 18 child execution for a Route Selection Decision Capture / Single-Route Binding Drill and explicitly forbade stage, commit, push, PR, remote command execution, network remote action, release, .claude/ edits, v1 repository access, and Phase 1-17 artifact edits except README Phase 18 navigation links.
Confirmed At: 2026-06-19
Recorded By: Phase 18 child executor
```

## Dispatch And Evaluator State

```text
Dispatch Matrix Ref: examples/phase-18-route-selection-decision-drill/dispatch-matrix.md
Completed Child: C-P18-ROUTE-SELECTION-DECISION
Child Report Ref: examples/phase-18-route-selection-decision-drill/child-report-route-selection-decision.md
Evaluator Assigned: EVAL-P18-ROUTE-SELECTION-DECISION
Current Pass: synthesis-comparison
Decision: Go for paper decision-capture package completeness; route selection and remote-sync authorization remain No-Go until explicit future Human route selection with current evidence.
Decision Ref: examples/phase-18-route-selection-decision-drill/evaluator-gate-card.md
Route Selection Decision Packet Ref: examples/phase-18-route-selection-decision-drill/route-selection-decision-packet.md
Single-Route Binding Record Ref: examples/phase-18-route-selection-decision-drill/single-route-binding-record.md
Ambiguity Rejection Checklist Ref: examples/phase-18-route-selection-decision-drill/ambiguity-rejection-checklist.md
```

## Evidence Index

Evidence Index is append-only style. Do not delete, rewrite, renumber, or silently reclassify old entries. `P18-EV-*` IDs must be unique.

```text
Evidence ID: P18-EV-001
Source: task-instance.md
Type: human-decision
Status: open
Summary: Human-signed North Star authorizes a markdown-only route selection decision capture drill and forbids real route selection, stage, commit, push, PR, remote commands, network remote action, release, v1 repository access, and .claude/ edits.
Reference: examples/phase-18-route-selection-decision-drill/task-instance.md#human-signoff
Created At: 2026-06-19
Updated By: C-P18-ROUTE-SELECTION-DECISION
Update Reason: Initial Phase 18 task creation.
```

```text
Evidence ID: P18-EV-002
Source: dispatch-matrix.md
Type: diff
Status: open
Summary: Dispatch Matrix assigns one child generator and one independent evaluator; Parent cannot assign itself and cannot authorize route selection, push, PR, remote command, network remote action, or release.
Reference: examples/phase-18-route-selection-decision-drill/dispatch-matrix.md
Created At: 2026-06-19
Updated By: C-P18-ROUTE-SELECTION-DECISION
Update Reason: Dispatch boundaries recorded.
```

```text
Evidence ID: P18-EV-003
Source: phase-18-route-selection-decision-guide.md
Type: guide
Status: open
Summary: Guide records route selection decision capture rules, single-route binding, ambiguity blockers, execution separation, evaluator passes, append-only Evidence Index rule, and pending Human Decision state.
Reference: docs/phase-18-route-selection-decision-guide.md
Created At: 2026-06-19
Updated By: C-P18-ROUTE-SELECTION-DECISION
Update Reason: Phase 18 guide created.
```

```text
Evidence ID: P18-EV-004
Source: route-selection-decision-packet.md
Type: decision-packet
Status: open
Summary: Route Selection Decision Packet defines valid future capture fields, requires exactly one route, and keeps current Selected Route: none.
Reference: examples/phase-18-route-selection-decision-drill/route-selection-decision-packet.md
Created At: 2026-06-19
Updated By: C-P18-ROUTE-SELECTION-DECISION
Update Reason: Decision capture packet recorded.
```

```text
Evidence ID: P18-EV-005
Source: single-route-binding-record.md
Type: binding-record
Status: open
Summary: Single-Route Binding Record binds a valid future Human decision to exactly one route, push or PR, and separates route selection from execution.
Reference: examples/phase-18-route-selection-decision-drill/single-route-binding-record.md
Created At: 2026-06-19
Updated By: C-P18-ROUTE-SELECTION-DECISION
Update Reason: Single-route binding rules recorded.
```

```text
Evidence ID: P18-EV-006
Source: ambiguity-rejection-checklist.md
Type: checklist
Status: open
Summary: Ambiguity Rejection Checklist makes ambiguous route wording, dual-route approval, stale evidence, fake route Go, dirty staged files, missing evidence ref, unresolved No-Go, changed HEAD/range/remote, and local-only state blocking conditions.
Reference: examples/phase-18-route-selection-decision-drill/ambiguity-rejection-checklist.md
Created At: 2026-06-19
Updated By: C-P18-ROUTE-SELECTION-DECISION
Update Reason: Ambiguity and blocker checks recorded.
```

```text
Evidence ID: P18-EV-007
Source: child-report-route-selection-decision.md
Type: child-report
Status: open
Summary: Child Report records Phase 18 docs-only changes, required validation command results, forbidden-scope check, Human Decision state, remaining risk, and parent acceptance recommendation.
Reference: examples/phase-18-route-selection-decision-drill/child-report-route-selection-decision.md
Created At: 2026-06-19
Updated By: C-P18-ROUTE-SELECTION-DECISION
Update Reason: Child execution evidence recorded.
```

```text
Evidence ID: P18-EV-008
Source: evaluator-gate-card.md
Type: evaluator-finding
Status: open
Summary: Evaluator records evidence-first and synthesis-comparison passes and treats route decision capture blockers as No-Go until recovered with current evidence.
Reference: examples/phase-18-route-selection-decision-drill/evaluator-gate-card.md
Created At: 2026-06-19
Updated By: EVAL-P18-ROUTE-SELECTION-DECISION
Update Reason: Evaluator decision-capture findings recorded.
```

```text
Evidence ID: P18-EV-009
Source: parent-synthesis.md
Type: parent-synthesis
Status: open
Summary: Parent Synthesis reconstructs Phase 18 state from Child Report and P18 Evidence IDs without chat memory.
Reference: examples/phase-18-route-selection-decision-drill/parent-synthesis.md
Created At: 2026-06-19
Updated By: Parent
Update Reason: Parent synthesis draft recorded.
```

```text
Evidence ID: P18-EV-010
Source: human-decision.md
Type: human-decision
Status: open
Summary: Human Decision placeholder remains pending; Selected Route: none; push / PR Authorized: no; remote action unauthorized; no release authorized.
Reference: examples/phase-18-route-selection-decision-drill/human-decision.md
Created At: 2026-06-19
Updated By: C-P18-ROUTE-SELECTION-DECISION
Update Reason: Human decision placeholder recorded.
```

```text
Evidence ID: P18-EV-011
Source: child-report-route-selection-decision.md
Type: verification
Status: open
Summary: Local baseline evidence verifies current HEAD, branch master, origin URL, origin/master..HEAD local commit range, clean staged area, and excluded .claude/ local-only state.
Reference: examples/phase-18-route-selection-decision-drill/child-report-route-selection-decision.md#verification
Created At: 2026-06-19
Updated By: C-P18-ROUTE-SELECTION-DECISION
Update Reason: Required local git evidence recorded.
```

```text
Evidence ID: P18-EV-012
Source: child-report-route-selection-decision.md
Type: verification
Status: open
Summary: Required keyword search, README link target check, Parent Synthesis citation check, P18-EV-* uniqueness check, and scope check were run and recorded.
Reference: examples/phase-18-route-selection-decision-drill/child-report-route-selection-decision.md#verification
Created At: 2026-06-19
Updated By: C-P18-ROUTE-SELECTION-DECISION
Update Reason: Validation evidence recorded.
```

```text
Evidence ID: P18-EV-013
Source: README.md
Type: diff
Status: open
Summary: README navigation adds Phase 18 guide and drill artifact links only.
Reference: README.md#documentation-navigation
Created At: 2026-06-19
Updated By: C-P18-ROUTE-SELECTION-DECISION
Update Reason: Phase 18 navigation links recorded.
```

```text
Evidence ID: P18-EV-014
Source: single-route-binding-record.md
Type: boundary
Status: open
Summary: Phase 17 local commit does not select push or PR; Phase 18 does not change that state.
Reference: examples/phase-18-route-selection-decision-drill/single-route-binding-record.md#phase-17-boundary
Created At: 2026-06-19
Updated By: C-P18-ROUTE-SELECTION-DECISION
Update Reason: Phase 17-to-Phase 18 boundary recorded.
```

```text
Evidence ID: P18-EV-015
Source: route-selection-decision-packet.md
Type: boundary
Status: open
Summary: Route selection remains separate from execution; even a valid future route selection does not itself execute push/PR.
Reference: examples/phase-18-route-selection-decision-drill/route-selection-decision-packet.md#execution-separation
Created At: 2026-06-19
Updated By: C-P18-ROUTE-SELECTION-DECISION
Update Reason: Execution separation rule recorded.
```

```text
Evidence ID: P18-EV-016
Source: ambiguity-rejection-checklist.md
Type: blocker
Status: open
Summary: Ambiguous wording, dual-route approval, stale evidence, fake route Go, missing evidence refs, dirty staged files, unresolved No-Go, changed HEAD/range/remote, and local-only state in release scope block route decision capture.
Reference: examples/phase-18-route-selection-decision-drill/ambiguity-rejection-checklist.md
Created At: 2026-06-19
Updated By: C-P18-ROUTE-SELECTION-DECISION
Update Reason: Blocker lanes recorded.
```

```text
Evidence ID: P18-EV-017
Source: human-decision.md
Type: human-decision
Status: resolved
Summary: Human approved Phase 18 local decision-capture package completeness only; Selected Route remains none, Route Selection Decision Status remains missing, Single-Route Binding Status remains unbound, push / PR Authorized remains no, and remote-sync authorization remains not granted.
Reference: examples/phase-18-route-selection-decision-drill/human-decision.md
Created At: 2026-06-19
Updated By: Parent
Update Reason: Recorded explicit local decision-capture package completeness Go without changing route selection, single-route binding, or remote authorization state.
```
