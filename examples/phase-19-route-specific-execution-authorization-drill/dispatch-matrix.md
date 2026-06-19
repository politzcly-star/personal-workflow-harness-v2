# Dispatch Matrix: route-specific execution authorization drill

## Parent Controls

```text
Parent Thread: Phase 19 parent thread
Parent May: assign child generator; assign independent evaluator; perform read-only parent synthesis from Child Report and P19-EV-* Evidence IDs.
Parent Must Not: self-assign as Generator or Evaluator; edit outside Allowed Changes; stage; commit; push; PR; select route; authorize execution; execute remote commands; perform network remote action; release; read or modify the v1 repository; modify .claude/; treat Phase 18 local commit as push/PR authorization; treat chat memory as execution Human Go evidence; claim route-specific execution authorization without cited evidence.
```

## Child Assignment

```text
Child ID: C-P19-ROUTE-SPECIFIC-EXECUTION-AUTHORIZATION
Role: Generator
Goal: Add Phase 19 guide, Route-Specific Execution Authorization Packet, Candidate Command Isolation Record, Execution Authorization Checklist, drill artifacts, and README Phase 19 navigation links.
Allowed Reads: README.md; docs/phase-18-route-selection-decision-guide.md; examples/phase-18-route-selection-decision-drill/*; local git metadata through allowed validation commands.
Allowed Changes: README.md Phase 19 navigation links only; docs/phase-19-route-specific-execution-authorization-guide.md; examples/phase-19-route-specific-execution-authorization-drill/task-instance.md; examples/phase-19-route-specific-execution-authorization-drill/dispatch-matrix.md; examples/phase-19-route-specific-execution-authorization-drill/child-report-route-specific-execution-authorization.md; examples/phase-19-route-specific-execution-authorization-drill/route-specific-execution-authorization-packet.md; examples/phase-19-route-specific-execution-authorization-drill/candidate-command-isolation-record.md; examples/phase-19-route-specific-execution-authorization-drill/execution-authorization-checklist.md; examples/phase-19-route-specific-execution-authorization-drill/evaluator-gate-card.md; examples/phase-19-route-specific-execution-authorization-drill/parent-synthesis.md; examples/phase-19-route-specific-execution-authorization-drill/human-decision.md
Forbidden Changes: .claude/settings.local.json; .claude/ files; v1 repository reads or writes; source code; runner; scripts; CI; Docker; browser automation; GitHub issue tracker integration; production; database; secrets; paid external actions; stage; commit; push; PR; route selection; execution authorization; remote command execution; network remote action; release; Phase 1/2/3/4/5/6/7/8/9/10/11/12/13/14/15/16/17/18 docs, templates, or examples except README Phase 19 navigation additions
Stop Conditions: unexpected modified file outside allowed scope; staged files; changed HEAD/range/remote after validation; route selection request; execution authorization request; push/PR request; remote/network action request; .claude/ edit request; v1 repository access request; unresolved evaluator No-Go.
Report Contract: changed files, evidence refs, validation commands and results, execution authorization blockers, candidate command isolation state, forbidden-scope check, Human Decision state, remaining risk, parent acceptance recommendation
```

## Evaluator Assignment

```text
Evaluator ID: EVAL-P19-ROUTE-SPECIFIC-EXECUTION-AUTHORIZATION
Role: Independent route-specific execution authorization evaluator
Pass Order: evidence-first, then synthesis-comparison
Must Inspect Before Parent Synthesis: Task Instance, Dispatch Matrix, Phase 19 Guide, Route-Specific Execution Authorization Packet, Candidate Command Isolation Record, Execution Authorization Checklist, Child Report, Human Decision placeholder, README navigation, and P19 Evidence Index.
Must Verify: Phase 18 local commit does not select push or PR; even a future valid route selection does not authorize execution; execution requires separate explicit Human execution Go; candidate push/PR commands are documentation only and non-authorized; Human Decision remains pending; Selected Route: none; Execution Authorized: no; push / PR Authorized: no; no remote/network action occurred.
No-Go Rule: missing route selection, ambiguous route, fake execution Go, command drift, stale evidence, dirty staged files, unexpected release files, missing evidence ref, unresolved No-Go, local-only state in release scope, duplicate P19-EV definition, remote/network action during drill, route selection during drill, execution authorization during drill, or uncited Parent Synthesis claim blocks execution authorization.
```
