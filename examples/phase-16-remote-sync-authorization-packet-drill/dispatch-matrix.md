# Dispatch Matrix: remote-sync authorization packet drill

## Parent Boundary

```text
Parent Role: control-plane dispatcher and synthesizer only
Parent Must Not: self-assign as Generator or Evaluator; edit outside Allowed Changes; stage; commit; push; PR; execute remote commands; perform network remote action; release; read or modify the v1 repository; modify .claude/; treat Phase 15 local baseline closure as remote-sync authorization; treat chat memory as authorization evidence; claim route selection without cited evidence.
Parent cannot assign itself.
```

## Generator Child

```text
Child ID: C-P16-REMOTE-SYNC-AUTH-PACKET
Role: Generator
Goal: Add Phase 16 guide, Remote-Sync Authorization Packet, Route Decision Matrix, drill artifacts, and README Phase 16 navigation links.
Allowed Read: README.md; docs; templates; examples; local git status/remote/branch/log/diff outputs in this v2 repository
Allowed Changes: README.md Phase 16 navigation links only; docs/phase-16-remote-sync-authorization-packet-guide.md; examples/phase-16-remote-sync-authorization-packet-drill/task-instance.md; examples/phase-16-remote-sync-authorization-packet-drill/dispatch-matrix.md; examples/phase-16-remote-sync-authorization-packet-drill/child-report-remote-sync-authorization-packet.md; examples/phase-16-remote-sync-authorization-packet-drill/remote-sync-authorization-packet.md; examples/phase-16-remote-sync-authorization-packet-drill/route-decision-matrix.md; examples/phase-16-remote-sync-authorization-packet-drill/evaluator-gate-card.md; examples/phase-16-remote-sync-authorization-packet-drill/parent-synthesis.md; examples/phase-16-remote-sync-authorization-packet-drill/human-decision.md
Forbidden Changes: .claude/settings.local.json; .claude/ files; v1 repository reads or writes; source code; runner; scripts; CI; Docker; browser automation; GitHub issue tracker integration; production; database; secrets; paid external actions; stage; commit; push; PR; remote command execution; network remote action; release; Phase 1/2/3/4/5/6/7/8/9/10/11/12/13/14/15 docs, templates, or examples except README Phase 16 navigation additions
Stop Conditions: need to edit outside Allowed Changes; need to stage, commit, push, PR, execute remote command, perform network remote action, or release; need to read or modify v1; need to modify .claude/; missing current repository evidence prevents packet creation; child-report: exhausted
Report Contract: changed files, evidence refs, validation commands and results, route decision blockers, forbidden-scope check, Human Decision state, remaining risk, parent acceptance recommendation
```

## Evaluator

```text
Evaluator ID: EVAL-P16-REMOTE-SYNC-AUTH-PACKET
Role: Independent remote-sync authorization packet evaluator
Allowed Read: Human-signed North Star, Task Instance, Dispatch Matrix, Child Report, Remote-Sync Authorization Packet, Route Decision Matrix, validation outputs, diff, Evidence Index, Parent Synthesis after evidence-first
Passes: evidence-first, synthesis-comparison
Decision Set: Go, Conditional Go, No-Go
No-Go Rule: missing route selection, stale baseline closure, branch/remote mismatch, dirty staged files, missing evidence ref, fake remote Go, unresolved No-Go, local-only state in release scope, duplicate P16-EV definition, remote/network action during drill, or uncited Parent Synthesis claim blocks authorization.
```

## Route Decision Boundary

```text
Phase 15 Baseline Closure: local only; does not authorize remote sync.
Route Options: push route, PR route
Selected Route: none
Remote-Sync Authorization: not granted
Remote Execution: not authorized
Release: not authorized
.claude/ and local-only state: excluded from any future remote-sync scope
push / PR Authorized: no
Human Decision: pending
```
