# Dispatch Matrix: release packet drill

## Parent Boundary

```text
Parent Role: control-plane dispatcher and synthesizer only
Parent Must Not: self-assign as Generator or Evaluator; edit outside Allowed Changes; stage; commit; push; PR; treat release packet preparation as remote approval.
Parent cannot assign itself.
```

## Generator Child

```text
Child ID: C-P11-RELEASE-PACKET
Role: Generator
Goal: Add Phase 11 release packet guide, release packet drill artifacts, and README navigation links.
Allowed Read: README.md; docs; templates; examples; git status/log/diff outputs in this v2 repository
Allowed Changes: README.md navigation links; docs/phase-11-release-packet-guide.md; examples/phase-11-release-packet-drill/*.md
Forbidden Changes: .claude/settings.local.json; v1 repository; source code; runner; scripts; CI; Docker; browser automation; GitHub issue tracker integration; production; database; secrets; paid external actions; commit; push; PR; stage; Phase 1/2/3/4/5/6/7/8/9/10 docs, templates, or examples except README navigation additions
Stop Conditions: need to edit outside Allowed Changes; need to stage, commit, push, or PR; release packet approval cannot be represented safely; verification unavailable; child-report: exhausted
Report Contract: changed files, evidence refs, verification commands, release packet blockers, forbidden-scope check, remaining risk, parent acceptance recommendation
```

## Evaluator

```text
Evaluator ID: EVAL-P11-RELEASE-PACKET
Role: Independent release packet evaluator
Allowed Read: Human-signed North Star, Task Instance, Dispatch Matrix, Child Report, Release Packet, verification outputs, diff, Evidence Index, Parent Synthesis after evidence-first
Passes: evidence-first, synthesis-comparison
Decision Set: Go, Conditional Go, No-Go
No-Go Rule: missing commit range, missing evidence refs, dirty staged files, unreviewed scope change, fake remote approval, unexpected release files, or local state in release packet blocks acceptance.
```

## Remote-Sync Decision Boundary

```text
Release Packet Decision: may be requested after Phase 11 review_ready.
Remote-Sync Decision: separate Human Go required.
push / PR Authorized: no
separate Human Go Required: yes
```
