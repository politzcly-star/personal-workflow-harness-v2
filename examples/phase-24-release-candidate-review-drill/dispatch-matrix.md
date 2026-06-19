# Dispatch Matrix: release candidate review drill

## Parent Boundary

```text
Parent Role: Orchestrator and final synthesis drafter only
Parent May: assign child generator, assign evaluator, compare reports, request Human decision later
Parent Must Not: act as Generator, act as Evaluator, edit Phase 1-23 artifacts except README Phase 24 navigation, select route, authorize execution, stage, commit, push, PR, remote command, network remote action, remote execution, remote-sync, release, edit .claude/, read or write v1 repository
Parent Conversion Rule: Parent cannot convert Phase 23 freeze, Phase 23 local commit, current ahead count, artifact completeness, evaluator pass, paper package completeness, stale freeze finding, or chat-only wording into authorization.
```

## Child Assignments

```text
Child ID: C-P24-RELEASE-CANDIDATE-REVIEW
Role: Generator
Mission: create markdown-only Phase 24 control-plane artifacts for release candidate review, freeze freshness revalidation, stale freeze evidence, authorization state comparison, and review blockers.
Allowed Read: README.md; docs/phase-23-release-candidate-freeze-guide.md; examples/phase-23-release-candidate-freeze-drill/*; allowed Phase 24 files; local git metadata required by validation commands.
Allowed Change: README.md Phase 24 navigation links only; docs/phase-24-release-candidate-review-guide.md; examples/phase-24-release-candidate-review-drill/*.md.
Stop Conditions: need to edit outside Allowed Changes; need to stage, commit, push, PR, release, execute remote command, perform network remote action, remote execution, remote-sync, select route, authorize execution, alter .claude/, access v1 repository, or rewrite Phase 1-23 artifacts beyond README Phase 24 navigation links.
Report Contract: changed files, what was implemented, validation commands and results, scope/forbidden-action confirmation, evidence/citation checks, remaining risks, parent acceptance recommendation.
```

```text
Evaluator ID: EVAL-P24-RELEASE-CANDIDATE-REVIEW
Role: Independent release candidate review evaluator
Must Inspect Before Parent Synthesis: Task Instance, Dispatch Matrix, Phase 24 Guide, Release Candidate Review Packet, Freeze Freshness Revalidation Checklist, Authorization State Comparison Record, Child Report, Human Decision placeholder, README navigation, Phase 23 frozen snapshot, and P24 Evidence Index.
Required Passes: evidence-first; synthesis-comparison
No-Go Rule: Changed HEAD/range, stale freeze evidence, dirty staged files, dirty working tree, missing evidence ref, conflicting canonical authorization fields, unresolved No-Go, fake release approval, remote action claim, local-only state in release scope, changed branch, changed remote URL, stale evaluator state, or stale Human wording blocks release or remote acceptance.
```

## Current Authorization State

```text
Selected Route: none
Human Decision: pending
Execution Authorized: no
push / PR Authorized: no
Remote Action Authorized: no
Remote Execution Authorized: no
Remote Action Executed: no
Release Authorized: no
```
