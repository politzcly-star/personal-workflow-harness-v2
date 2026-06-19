# Dispatch Matrix: release candidate freeze drill

## Parent Boundary

```text
Parent Role: Orchestrator and final synthesis drafter only
Parent May: assign child generator, assign evaluator, compare reports, request Human decision later
Parent Must Not: act as Generator, act as Evaluator, edit Phase 1-22 artifacts except README Phase 23 navigation, select route, authorize execution, stage, commit, push, PR, remote command, network remote action, remote execution, release, edit .claude/, read or write v1 repository
Parent Conversion Rule: Parent cannot convert release candidate freeze, ahead count, local commit, artifact completeness, evaluator pass, paper package completeness, or chat-only wording into authorization.
```

## Child Assignments

```text
Child ID: C-P23-RELEASE-CANDIDATE-FREEZE
Role: Generator
Mission: create markdown-only Phase 23 control-plane artifacts for release candidate freeze, canonical evidence snapshot, authorization state snapshot, and evidence freeze blockers.
Allowed Read: README.md; docs/phase-22-authorization-state-canonicalization-guide.md; examples/phase-22-authorization-state-canonicalization-drill/*; allowed Phase 23 files; local git metadata required by validation commands.
Allowed Change: README.md Phase 23 navigation links only; docs/phase-23-release-candidate-freeze-guide.md; examples/phase-23-release-candidate-freeze-drill/*.md.
Stop Conditions: need to edit outside Allowed Changes; need to stage, commit, push, PR, execute remote command, perform network remote action, remote execution, select route, authorize execution, alter .claude/, access v1 repository, or rewrite Phase 1-22 artifacts beyond README Phase 23 navigation links.
Report Contract: changed files, guide/artifacts summary, validation command results, forbidden-scope confirmation, Human Decision state, Evidence ID uniqueness, Parent Synthesis citation result, remaining risks, parent acceptance recommendation.
```

```text
Evaluator ID: EVAL-P23-RELEASE-CANDIDATE-FREEZE
Role: Independent release candidate freeze evaluator
Must Inspect Before Parent Synthesis: Task Instance, Dispatch Matrix, Phase 23 Guide, Release Candidate Snapshot, Canonical Authorization State Snapshot, Evidence Freeze Checklist, Child Report, Human Decision placeholder, README navigation, and P23 Evidence Index.
Required Passes: evidence-first; synthesis-comparison
No-Go Rule: Missing snapshot evidence, dirty staged files, conflicting canonical authorization fields, omitted evidence ref, unresolved No-Go, local-only state in release scope, fake release approval, changed HEAD, changed branch, changed remote URL, changed commit range, changed working tree, stale evaluator state, or stale Human wording blocks acceptance.
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
