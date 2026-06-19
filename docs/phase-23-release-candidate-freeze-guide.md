# Phase 23 Release Candidate Freeze Guide

Phase 23 rehearses a markdown-only Release Candidate Freeze / Canonical Evidence Snapshot Drill. It creates a local paper snapshot for the Phase 1-22 release-candidate range and proves the current release-candidate scope, canonical authorization state, and evidence refs can be reconstructed from repository state and artifacts without chat memory.

Phase 23 does not execute, stage, commit, push, open a PR, perform a remote command, perform a network remote action, release, publish, tag, run browser automation, edit source code, edit scripts, edit CI, edit Docker, touch production, access secrets, use paid external actions, read or write the v1 repository, or edit `.claude/`.

## Authority Order

```text
Human-signed North Star
> release candidate snapshot
> canonical authorization state snapshot
> evidence freeze checklist
> current evaluator evidence-first pass
> current evaluator synthesis-comparison pass
> Parent Synthesis
> Child Report / P23 Evidence Refs
> Chat Context
```

Chat context cannot repair changed HEAD, changed branch, changed remote URL, changed commit range, dirty staged files, dirty working tree, changed release scope, conflicting canonical authorization fields, missing evidence ref, unresolved No-Go, local-only state in release scope, fake release approval, stale evaluator state, or stale Human wording.

## Frozen Repository Binding

The Phase 23 snapshot is valid only for this local repository state:

```text
HEAD: 30e643c88753dc2542e5e615507843e9847bea58
HEAD short: 30e643c
HEAD subject: docs: add v2 phase 22 authorization state canonicalization drill
Branch: master
Remote: origin https://github.com/politzcly-star/personal-workflow-harness-v2.git
Commit Range: origin/master..HEAD
Ahead Count: 22
Staged Area: clean
Excluded Local State: .claude/ and .claude/settings.local.json
```

Any change to HEAD, branch, remote URL, `origin/master..HEAD`, staged area, working tree, release scope, canonical status fields, evidence refs, evaluator state, or Human wording invalidates the release candidate freeze and requires a new snapshot.

## Canonical Authorization State

Every Phase 23 decision-bearing artifact must preserve these exact canonical status fields.

```text
Execution Authorized: no
push / PR Authorized: no
Remote Action Authorized: no
Remote Execution Authorized: no
Remote Action Executed: no
Release Authorized: no
```

Human Decision remains pending for Phase 23. No local paper snapshot, ahead count, release-candidate wording, artifact completeness, evaluator pass, parent acceptance recommendation, or local commit can authorize execution, push, PR, remote action, remote execution, or release.

## Freeze Acceptance Blockers

Acceptance is blocked by any of the following:

```text
changed HEAD
changed branch
changed remote URL
changed origin/master..HEAD range
dirty staged files
dirty working tree outside allowed Phase 23 markdown files and excluded .claude/
changed release scope
conflicting canonical authorization fields
missing evidence ref
omitted evidence ref
unresolved No-Go
local-only state in release scope
fake release approval
missing snapshot evidence
stale evaluator state
stale Human wording
duplicate P23-EV-* Evidence ID
non-append-only Evidence Index rewrite
Parent Synthesis claim without Child Report or P23-EV-* citation
```

## Required Reconstruction Proof

The release candidate freeze must show how to reconstruct the Phase 1-22 local release candidate without chat memory:

```text
Repository identity: branch, HEAD, remote URL, commit range, clean staged area
Release scope: origin/master..HEAD commit list for Phase 1 through Phase 22
Artifact scope: README navigation plus Phase 1-22 docs and examples already in repo
Authorization state: canonical no fields in Phase 22 and Phase 23 artifacts
Evidence refs: append-only P23 Evidence Index with unique P23-EV-* IDs
Evaluator state: evidence-first and synthesis-comparison passes
Human state: pending; no authorization granted
Excluded local-only state: .claude/ and .claude/settings.local.json
```

## Evaluator Passes

```text
Pass Type: evidence-first
Purpose: inspect repository binding, release candidate snapshot, canonical authorization state snapshot, evidence freeze checklist, Human Decision placeholder, Child Report, README navigation, local git evidence, and P23 Evidence Index before reading Parent Synthesis.
```

```text
Pass Type: synthesis-comparison
Purpose: compare Parent Synthesis against evidence-first findings and verify every Parent claim cites only Child Report or P23-EV-* Evidence IDs.
```

## Evidence Index Rule

The Evidence Index must be append-only style. `P23-EV-*` IDs must be unique. Do not delete, rewrite, renumber, or silently reclassify Evidence ID entries.

## Human Decision

Human Decision remains pending in Phase 23.

```text
Execution Authorized: no
push / PR Authorized: no
Remote Action Authorized: no
Remote Execution Authorized: no
Remote Action Executed: no
Release Authorized: no
No Remote/Network Action Occurred: yes
```
