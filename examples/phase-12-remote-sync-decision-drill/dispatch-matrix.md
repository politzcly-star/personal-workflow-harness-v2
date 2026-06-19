# Dispatch Matrix: remote-sync decision drill

## Parent Boundary

```text
Parent Role: control-plane dispatcher and synthesizer only
Parent Must Not: self-assign as Generator or Evaluator; edit outside Allowed Changes; stage; commit; push; PR; treat local commit Go as remote-sync authorization.
Parent cannot assign itself.
```

## Generator Child

```text
Child ID: C-P12-REMOTE-SYNC-DECISION
Role: Generator
Goal: Add Phase 12 remote-sync decision guide, authorization expiry drill artifacts, and README navigation links.
Allowed Read: README.md; docs; templates; examples; git status/log/diff outputs in this v2 repository
Allowed Changes: README.md navigation links; docs/phase-12-remote-sync-decision-guide.md; examples/phase-12-remote-sync-decision-drill/*.md
Forbidden Changes: .claude/settings.local.json; v1 repository; source code; runner; scripts; CI; Docker; browser automation; GitHub issue tracker integration; production; database; secrets; paid external actions; commit; push; PR; stage; Phase 1/2/3/4/5/6/7/8/9/10/11 docs, templates, or examples except README navigation additions
Stop Conditions: need to edit outside Allowed Changes; need to stage, commit, push, or PR; remote-sync authorization cannot be represented safely; verification unavailable; child-report: exhausted
Report Contract: changed files, evidence refs, verification commands, authorization expiry blockers, forbidden-scope check, remaining risk, parent acceptance recommendation
```

## Evaluator

```text
Evaluator ID: EVAL-P12-REMOTE-SYNC-DECISION
Role: Independent remote-sync decision evaluator
Allowed Read: Human-signed North Star, Task Instance, Dispatch Matrix, Child Report, Remote-Sync Decision Request, verification outputs, diff, Evidence Index, Parent Synthesis after evidence-first
Passes: evidence-first, synthesis-comparison
Decision Set: Go, Conditional Go, No-Go
No-Go Rule: changed commit range, dirty staged files, .claude in release scope, unexpected release files, missing evidence refs, unreviewed scope change, fake remote approval, or expired authorization blocks acceptance.
```

## Remote-Sync Decision Boundary

```text
Remote-Sync Decision: separate Human Go required.
Authorization Validity: explicit origin/master..HEAD range, clean status, and complete evidence refs only.
push / PR Authorized: no
separate Human Go: missing
```
