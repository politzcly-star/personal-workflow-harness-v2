# Dispatch Matrix: release gate drill

## Parent Boundary

```text
Parent Role: control-plane dispatcher and synthesizer only
Parent Must Not: self-assign as Generator or Evaluator; edit outside Allowed Changes; stage; commit; push; PR; treat local commit approval as remote approval.
Parent cannot assign itself.
```

## Generator Child

```text
Child ID: C-P10-RELEASE-GATE
Role: Generator
Goal: Add Phase 10 release gate guide, release readiness drill artifacts, and README navigation links.
Allowed Read: README.md; docs; templates; examples; git status/log/diff outputs in this v2 repository
Allowed Changes: README.md navigation links; docs/phase-10-release-gate-guide.md; examples/phase-10-release-gate-drill/*.md
Forbidden Changes: .claude/settings.local.json; v1 repository; source code; runner; scripts; CI; Docker; browser automation; GitHub issue tracker integration; production; database; secrets; paid external actions; commit; push; PR; stage; Phase 1/2/3/4/5/6/7/8/9 docs, templates, or examples except README navigation additions
Stop Conditions: need to edit outside Allowed Changes; need to stage, commit, push, or PR; release approval cannot be represented safely; verification unavailable; child-report: exhausted
Report Contract: changed files, evidence refs, verification commands, release blockers, forbidden-scope check, remaining risk, parent acceptance recommendation
```

## Evaluator

```text
Evaluator ID: EVAL-P10-RELEASE-GATE
Role: Independent release gate evaluator
Allowed Read: Human-signed North Star, Task Instance, Dispatch Matrix, Child Report, Release Gate Checklist, verification outputs, diff, Evidence Index, Parent Synthesis after evidence-first
Passes: evidence-first, synthesis-comparison
Decision Set: Go, Conditional Go, No-Go
No-Go Rule: dirty staged files, missing release evidence, fake push approval, unreviewed scope change, unexpected files, or local state in release scope blocks release gate.
```

## Release Decision Boundary

```text
Local Commit Decision: may be requested after Phase 10 review_ready.
Remote-Sync Decision: separate Human Go required.
push / PR Authorized: no
separate Human Go Required: yes
```
