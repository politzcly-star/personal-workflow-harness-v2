# Dispatch Matrix: route selection decision drill

## Parent Controls

```text
Parent Thread: Phase 18 parent thread
Parent May: assign child generator; assign independent evaluator; perform read-only parent synthesis from Child Report and P18-EV-* Evidence IDs.
Parent Must Not: self-assign as Generator or Evaluator; edit outside Allowed Changes; stage; commit; push; PR; select route; execute remote commands; perform network remote action; release; read or modify the v1 repository; modify .claude/; treat Phase 17 local commit as push/PR authorization; treat chat memory as route selection decision evidence; claim route selection without cited evidence.
```

## Child Assignment

```text
Child ID: C-P18-ROUTE-SELECTION-DECISION
Role: Generator
Goal: Add Phase 18 guide, Route Selection Decision Packet, Single-Route Binding Record, Ambiguity Rejection Checklist, drill artifacts, and README Phase 18 navigation links.
Allowed Reads: README.md; docs/phase-17-route-selection-readiness-guide.md; examples/phase-17-route-selection-readiness-drill/*; local git metadata through allowed validation commands.
Allowed Changes: README.md Phase 18 navigation links only; docs/phase-18-route-selection-decision-guide.md; examples/phase-18-route-selection-decision-drill/task-instance.md; examples/phase-18-route-selection-decision-drill/dispatch-matrix.md; examples/phase-18-route-selection-decision-drill/child-report-route-selection-decision.md; examples/phase-18-route-selection-decision-drill/route-selection-decision-packet.md; examples/phase-18-route-selection-decision-drill/single-route-binding-record.md; examples/phase-18-route-selection-decision-drill/ambiguity-rejection-checklist.md; examples/phase-18-route-selection-decision-drill/evaluator-gate-card.md; examples/phase-18-route-selection-decision-drill/parent-synthesis.md; examples/phase-18-route-selection-decision-drill/human-decision.md
Forbidden Changes: .claude/settings.local.json; .claude/ files; v1 repository reads or writes; source code; runner; scripts; CI; Docker; browser automation; GitHub issue tracker integration; production; database; secrets; paid external actions; stage; commit; push; PR; route selection; remote command execution; network remote action; release; Phase 1/2/3/4/5/6/7/8/9/10/11/12/13/14/15/16/17 docs, templates, or examples except README Phase 18 navigation additions
Stop Conditions: unexpected modified file outside allowed scope; staged files; changed HEAD/range/remote after validation; route selection request; push/PR request; remote/network action request; .claude/ edit request; v1 repository access request; unresolved evaluator No-Go.
Report Contract: changed files, evidence refs, validation commands and results, route decision blockers, forbidden-scope check, Human Decision state, remaining risk, parent acceptance recommendation
```

## Evaluator Assignment

```text
Evaluator ID: EVAL-P18-ROUTE-SELECTION-DECISION
Role: Independent route selection decision evaluator
Pass Order: evidence-first, then synthesis-comparison
Must Inspect Before Parent Synthesis: Task Instance, Dispatch Matrix, Phase 18 Guide, Route Selection Decision Packet, Single-Route Binding Record, Ambiguity Rejection Checklist, Child Report, Human Decision placeholder, README navigation, and P18 Evidence Index.
Must Verify: Phase 17 local commit does not select push or PR; valid future decision chooses exactly one route, push or PR; route selection remains separate from execution; Human Decision remains pending; Selected Route: none; push / PR Authorized: no; no remote/network action occurred.
No-Go Rule: ambiguous route wording, dual-route approval, stale evidence, fake route Go, dirty staged files, missing evidence ref, unresolved No-Go, changed HEAD/range/remote, local-only state in release scope, duplicate P18-EV definition, remote/network action during drill, route selection during drill, or uncited Parent Synthesis claim blocks route decision capture.
```
