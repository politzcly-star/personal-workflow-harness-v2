# Dispatch Matrix: execution Human Go capture drill

## Parent Control

```text
Parent Thread: Phase 20 parent thread
Parent Role: synthesis only
Parent Must Not: self-assign as Generator or Evaluator; edit outside Allowed Changes; stage; commit; push; PR; select route; authorize execution; execute remote commands; perform network remote action; release; read or modify the v1 repository; modify .claude/; treat Phase 19 local commit as execution Human Go; treat chat memory as execution Human Go evidence; claim execution authorization without cited evidence.
```

## Child Work Package

```text
Child ID: C-P20-EXECUTION-HUMAN-GO-CAPTURE
Role: Generator
Goal: Add Phase 20 guide, Execution Human Go Capture Packet, Exact Command Binding Record, Authorization Expiry Checklist, drill artifacts, and README Phase 20 navigation links.
Allowed Changes: README.md Phase 20 navigation links only; docs/phase-20-execution-human-go-capture-guide.md; examples/phase-20-execution-human-go-capture-drill/task-instance.md; examples/phase-20-execution-human-go-capture-drill/dispatch-matrix.md; examples/phase-20-execution-human-go-capture-drill/child-report-execution-human-go-capture.md; examples/phase-20-execution-human-go-capture-drill/execution-human-go-capture-packet.md; examples/phase-20-execution-human-go-capture-drill/exact-command-binding-record.md; examples/phase-20-execution-human-go-capture-drill/authorization-expiry-checklist.md; examples/phase-20-execution-human-go-capture-drill/evaluator-gate-card.md; examples/phase-20-execution-human-go-capture-drill/parent-synthesis.md; examples/phase-20-execution-human-go-capture-drill/human-decision.md
Forbidden Changes: .claude/settings.local.json; .claude/ files; v1 repository reads or writes; source code; runner; scripts; CI; Docker; browser automation; GitHub issue tracker integration; production; database; secrets; paid external actions; stage; commit; push; PR; route selection; execution authorization; remote command execution; network remote action; release; Phase 1-19 artifacts except README Phase 20 navigation additions
Stop Conditions: unexpected modified file outside allowed scope; staged files; changed HEAD/range/remote after validation; route selection request; execution authorization request; push/PR request; remote/network action request; .claude/ edit request; v1 repository access request; unresolved evaluator No-Go.
Report Contract: changed files, evidence refs, validation commands and results, execution authorization blockers, exact command binding state, forbidden-scope check, Human Decision state, remaining risk, parent acceptance recommendation
```

## Evaluator Work Package

```text
Evaluator ID: EVAL-P20-EXECUTION-HUMAN-GO-CAPTURE
Role: Independent execution Human Go capture evaluator
Must Inspect Before Parent Synthesis: Task Instance, Dispatch Matrix, Phase 20 Guide, Execution Human Go Capture Packet, Exact Command Binding Record, Authorization Expiry Checklist, Child Report, Human Decision placeholder, README navigation, and P20 Evidence Index.
Required Passes: evidence-first; synthesis-comparison
No-Go Rule: missing execution Go, ambiguous command wording, fake execution Go, command drift, stale evidence, dirty staged files, unexpected release files, missing evidence ref, unresolved No-Go, local-only state in release scope, duplicate P20-EV definition, remote/network action during drill, route selection during drill, execution authorization during drill, or uncited Parent Synthesis claim blocks execution capture.
```
