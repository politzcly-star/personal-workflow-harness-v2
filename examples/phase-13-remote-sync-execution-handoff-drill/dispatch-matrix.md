# Dispatch Matrix: remote-sync execution handoff drill

## Parent Boundary

```text
Parent Role: control-plane dispatcher and synthesizer only
Parent Must Not: self-assign as Generator or Evaluator; edit outside Allowed Changes; stage; commit; push; PR; execute candidate remote commands; treat local commit acceptance or remote-sync authorization as remote-sync execution approval.
Parent cannot assign itself.
```

## Generator Child

```text
Child ID: C-P13-REMOTE-SYNC-EXECUTION-HANDOFF
Role: Generator
Goal: Add Phase 13 remote-sync execution handoff guide, final preflight drill artifacts, and README Phase 13 navigation links.
Allowed Read: README.md; docs; templates; examples; git status/remote/branch/log/diff outputs in this v2 repository
Allowed Changes: README.md Phase 13 navigation links only; docs/phase-13-remote-sync-execution-handoff-guide.md; examples/phase-13-remote-sync-execution-handoff-drill/*.md
Forbidden Changes: .claude/settings.local.json; .claude/ files; v1 repository; source code; runner; scripts; CI; Docker; browser automation; GitHub issue tracker integration; production; database; secrets; paid external actions; commit; push; PR; stage; Phase 1/2/3/4/5/6/7/8/9/10/11/12 docs, templates, or examples except README Phase 13 navigation additions
Stop Conditions: need to edit outside Allowed Changes; need to stage, commit, push, PR, or execute remote command; execution Human Go cannot be represented safely; verification unavailable; child-report: exhausted
Report Contract: changed files, evidence refs, verification commands and results, execution handoff blockers, forbidden-scope check, Human Decision state, remaining risk, parent acceptance recommendation
```

## Evaluator

```text
Evaluator ID: EVAL-P13-REMOTE-SYNC-EXECUTION-HANDOFF
Role: Independent remote-sync execution handoff evaluator
Allowed Read: Human-signed North Star, Task Instance, Dispatch Matrix, Child Report, Remote-Sync Execution Runbook, Remote-Sync Preflight Checklist, verification outputs, diff, Evidence Index, Parent Synthesis after evidence-first
Passes: evidence-first, synthesis-comparison
Decision Set: Go, Conditional Go, No-Go
No-Go Rule: missing execution Human Go, ambiguous push-vs-PR route, stale release packet, fake command authorization, dirty staged files, unexpected release files, .claude/ in payload, expired authorization, or missing evidence refs blocks execution.
```

## Remote-Sync Execution Boundary

```text
Local Commit Acceptance: separate decision, not execution authorization.
Remote-Sync Authorization: separate decision, not execution authorization.
Remote-Sync Execution: separate execution Human Go required.
Authorization Validity: current master, current origin, explicit origin/master..HEAD, clean staged area, .claude/ excluded, and complete P13 Evidence Refs only.
Candidate Actions: inert future options only; not approved; not executed.
push / PR Authorized: no
execution Human Go: missing
```
