# Dispatch Matrix: route selection readiness drill

## Parent Boundary

```text
Parent Role: control-plane dispatcher and synthesizer only
Parent Must Not: self-assign as Generator or Evaluator; edit outside Allowed Changes; stage; commit; push; PR; select route; execute remote commands; perform network remote action; release; read or modify the v1 repository; modify .claude/; treat Phase 16 local commit as push/PR authorization; treat chat memory as route selection evidence; claim route selection without cited evidence.
Parent cannot assign itself.
```

## Generator Child

```text
Child ID: C-P17-ROUTE-SELECTION-READINESS
Role: Generator
Goal: Add Phase 17 guide, Route Selection Readiness Record, Evidence Refresh Checklist, drill artifacts, and README Phase 17 navigation links.
Allowed Read: README.md; docs; templates; examples; local git status/remote/branch/log/diff outputs in this v2 repository
Allowed Changes: README.md Phase 17 navigation links only; docs/phase-17-route-selection-readiness-guide.md; examples/phase-17-route-selection-readiness-drill/task-instance.md; examples/phase-17-route-selection-readiness-drill/dispatch-matrix.md; examples/phase-17-route-selection-readiness-drill/child-report-route-selection-readiness.md; examples/phase-17-route-selection-readiness-drill/route-selection-readiness-record.md; examples/phase-17-route-selection-readiness-drill/evidence-refresh-checklist.md; examples/phase-17-route-selection-readiness-drill/evaluator-gate-card.md; examples/phase-17-route-selection-readiness-drill/parent-synthesis.md; examples/phase-17-route-selection-readiness-drill/human-decision.md
Forbidden Changes: .claude/settings.local.json; .claude/ files; v1 repository reads or writes; source code; runner; scripts; CI; Docker; browser automation; GitHub issue tracker integration; production; database; secrets; paid external actions; stage; commit; push; PR; route selection; remote command execution; network remote action; release; Phase 1/2/3/4/5/6/7/8/9/10/11/12/13/14/15/16 docs, templates, or examples except README Phase 17 navigation additions
Stop Conditions: need to edit outside Allowed Changes; need to stage, commit, push, PR, select route, execute remote command, perform network remote action, or release; need to read or modify v1; need to modify .claude/; missing current repository evidence prevents readiness package creation; child-report: exhausted
Report Contract: changed files, evidence refs, validation commands and results, route selection blockers, forbidden-scope check, Human Decision state, remaining risk, parent acceptance recommendation
```

## Evaluator

```text
Evaluator ID: EVAL-P17-ROUTE-SELECTION-READINESS
Role: Independent route selection readiness evaluator
Allowed Read: Human-signed North Star, Task Instance, Dispatch Matrix, Child Report, Route Selection Readiness Record, Evidence Refresh Checklist, validation outputs, diff, Evidence Index, Parent Synthesis after evidence-first
Passes: evidence-first, synthesis-comparison
Decision Set: Go, Conditional Go, No-Go
No-Go Rule: missing route selection, stale evidence, ambiguous push-vs-PR wording, fake route Go, dirty staged files, missing evidence ref, unresolved No-Go, local-only state in release scope, duplicate P17-EV definition, remote/network action during drill, route selection during drill, or uncited Parent Synthesis claim blocks route selection.
```

## Route Selection Boundary

```text
Phase 16 Local Commit: local only; does not authorize push/PR or select a route.
Route Options: push route, PR route
Selected Route: none
Remote-Sync Authorization: not granted
Remote Execution: not authorized
Release: not authorized
.claude/ and local-only state: excluded from any future route, push, PR, release, and remote-sync scope
push / PR Authorized: no
Human Decision: pending
```
