# Phase 25 Current Release Candidate Refreeze Guide

Phase 25 rehearses a markdown-only Current Release Candidate Refreeze / Evidence Refresh Drill. It repairs the stale Phase 24 freeze state by creating a refreshed local paper snapshot at the current real HEAD, while preserving No-Go for release, execution, push, PR, remote action, remote execution, remote-sync, route selection, remote command, and exact command execution.

Phase 25 does not execute, stage, commit, push, open a PR, perform a remote command, perform a network remote action, release, publish, tag, run browser automation, edit source code, edit scripts, edit CI, edit Docker, touch production, access secrets, use paid external actions, read or write the v1 repository, or edit `.claude/`.

## Authority Order

```text
Human-signed North Star
> current release candidate refreeze packet
> refreshed evidence snapshot
> canonical authorization state snapshot
> Evidence Refresh Checklist
> current evaluator evidence-first pass
> current evaluator synthesis-comparison pass
> Parent Synthesis
> Child Report / P25 Evidence Refs
> Phase 24 review artifacts as historical evidence only
> Chat Context
```

Chat context cannot authorize release or remote action. A local refreeze packet binds only the recorded paper snapshot. It does not authorize execution, push, PR, remote action, remote execution, remote-sync, route selection, release, or exact command execution.

## Refreshed Snapshot Binding

The Phase 25 refreshed evidence snapshot is bound to this current local repository state:

```text
Current HEAD: 32e8c207783b46c67ac32693748bdb3694a3960a
Current HEAD short: 32e8c20
Current Subject: docs: add v2 phase 24 release candidate review drill
Current Branch: master
Current Remote: origin https://github.com/politzcly-star/personal-workflow-harness-v2.git
Current Commit Range: origin/master..HEAD
Current Ahead Count: 24
Current Staged Area: clean
Excluded Local State: .claude/ and .claude/settings.local.json
```

The Phase 24 local commit is evidence that Phase 24 paper artifacts were added locally. It does not authorize release, execution, push, PR, remote action, remote execution, remote-sync, route selection, remote command, or exact command execution.

## Canonical Authorization State

Every Phase 25 decision-bearing artifact must preserve these exact canonical status fields.

```text
Execution Authorized: no
push / PR Authorized: no
Remote Action Authorized: no
Remote Execution Authorized: no
Remote Action Executed: no
Release Authorized: no
```

Human Decision remains pending for Phase 25. No current HEAD, local commit, ahead count, release-candidate wording, artifact completeness, evaluator pass, parent acceptance recommendation, refreshed evidence snapshot, or local-only paper state can authorize execution, push, PR, remote action, remote execution, remote-sync, or release.

## Evidence Refresh Checklist Blockers

Acceptance is invalidated or blocked by any of the following:

```text
later change to HEAD
later change to branch
later change to remote URL
later change to origin/master..HEAD
later change to staged area
later change to working tree
later change to release scope
later change to canonical status fields
later change to evidence refs
later change to evaluator state
later change to Human wording
dirty staged files
missing evidence ref
unresolved No-Go
local-only state
fake release approval
remote action claim
duplicate P25-EV-* Evidence ID
non-append-only Evidence Index rewrite
Parent Synthesis claim without Child Report or P25-EV-* citation
```

## Required Future Revalidation

Before any future release, execution, push, PR, route selection, remote action, remote execution, or remote-sync decision, a new decision packet must revalidate:

```text
HEAD
branch
remote URL
origin/master..HEAD
staged area
working tree
.claude/ exclusion
release scope
canonical authorization fields
evaluator state
Human wording
evidence refs
```

If any of those inputs changed since the Phase 25 refreshed evidence snapshot, the snapshot is invalid for future release or remote use.

## Evaluator Passes

```text
Pass Type: evidence-first
Purpose: inspect repository binding, current release candidate refreeze packet, refreshed evidence snapshot, canonical authorization state snapshot, Evidence Refresh Checklist, Human Decision placeholder, Child Report, README navigation, and P25 Evidence Index before reading Parent Synthesis.
```

```text
Pass Type: synthesis-comparison
Purpose: compare Parent Synthesis against evidence-first findings and verify every Claim, Finding, and Recommended Decision cites only Child Report or P25-EV-* Evidence IDs.
```

## Evidence Index Rule

The Evidence Index must be append-only style. `P25-EV-*` IDs must be unique. Do not delete, rewrite, renumber, or silently reclassify Evidence ID entries.

## Human Decision

Human Decision remains pending in Phase 25.

```text
Execution Authorized: no
push / PR Authorized: no
Remote Action Authorized: no
Remote Execution Authorized: no
Remote Action Executed: no
Release Authorized: no
No Remote/Network Action Occurred: yes
```
