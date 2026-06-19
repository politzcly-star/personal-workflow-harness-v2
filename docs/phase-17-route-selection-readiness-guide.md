# Phase 17 Remote-Sync Route Selection Readiness Guide

Phase 17 rehearses a markdown-only Remote-Sync Route Selection Readiness / Evidence Refresh Drill. It prepares a future Human to decide whether to choose a push route or a PR route, but Phase 17 does not choose a route, authorize push, authorize PR, execute a remote command, perform a network remote action, release, stage, commit, open a PR, or publish anything.

Phase 16 local commit does not authorize push/PR or select a route. A local paper packet commit is only a local artifact completeness event. It cannot be reused as route selection, push authorization, PR authorization, release approval, remote command approval, network remote action approval, or remote outcome acceptance.

## Authority Order

```text
Human-signed North Star
> explicit future Human route selection
> current evidence refresh packet
> Route Selection Readiness Record
> Evidence Refresh Checklist
> evaluator evidence-first findings
> evaluator synthesis-comparison findings
> Parent Synthesis
> Child Report / Evidence Refs
> Chat Context
```

Chat context is not route selection evidence.

## Readiness Boundary

Phase 17 only says whether a future route decision has enough local paper evidence to be reviewed. It does not make the route decision.

```text
Selected Route: none
Route Selection Status: pending
Remote-Sync Authorization: not granted
push / PR Authorized: no
Remote Action Authorized: no
Remote Action Executed: no
Release Authorized: no
```

## Required Future Evidence Refresh

A future route decision must re-check current HEAD, branch, remote URL, `origin/master..HEAD`, staged area, working tree, `.claude/` exclusion, and complete evidence refs.

```text
Required HEAD: current git HEAD at review time
Required Branch: current branch at review time
Required Remote URL: current origin URL at review time
Required Commit Range: current origin/master..HEAD at review time
Required Staged Area: clean or explicitly reviewed with evidence
Required Working Tree: reviewed scope only, with local-only state excluded
Required Local-Only Exclusion: .claude/ excluded from route, push, PR, release, and remote-sync scope
Required Evidence Refs: complete P17-EV-* or later Evidence IDs for every route-readiness claim
Required Human Wording: exactly one route unless explicitly split into separate decisions
```

## Route Separation

Push route and PR route are mutually exclusive unless Human explicitly splits them into separate decisions. Ambiguous push-vs-PR wording blocks route selection because it can be mistaken for dual authorization.

```text
Candidate Route: push
State In Phase 17: candidate only
Authorization State: not authorized
Required Future Decision: explicit push route selection with current evidence refs
```

```text
Candidate Route: PR
State In Phase 17: candidate only
Authorization State: not authorized
Required Future Decision: explicit PR route selection with current evidence refs
```

## Authorization Expiry

Authorization expires if HEAD, branch, remote URL, staged area, working tree, evidence refs, or route wording changes after review. Expired authorization must be treated as No-Go until evidence refresh is rerun and Human gives a fresh route decision.

```text
Expiry Trigger: HEAD changed
Effect: reviewed payload is stale
Recovery: rerun evidence refresh and request a fresh Human decision
```

```text
Expiry Trigger: branch changed
Effect: reviewed branch binding is stale
Recovery: rerun branch and range evidence
```

```text
Expiry Trigger: remote URL changed
Effect: reviewed remote target is stale
Recovery: rerun remote evidence and route readiness review
```

```text
Expiry Trigger: staged area changed
Effect: reviewed staged payload is stale
Recovery: clear or explicitly review staged files with evidence
```

```text
Expiry Trigger: working tree changed
Effect: reviewed local scope is stale
Recovery: rerun scope and local-only exclusion checks
```

```text
Expiry Trigger: evidence refs changed
Effect: Parent Synthesis can no longer be reconstructed from the reviewed Evidence Index
Recovery: append missing Evidence IDs and rerun evidence-first
```

```text
Expiry Trigger: route wording changed
Effect: push-vs-PR authorization meaning may have changed
Recovery: request exact Human route wording again
```

## Route Selection Blockers

Each blocker below prevents route selection until recovered with current evidence.

```text
Lane: missing route selection
Blocking State: No-Go
Recovery Path: ask Human to select exactly one route, push or PR, with current evidence refs.
```

```text
Lane: stale evidence
Blocking State: No-Go
Recovery Path: rerun evidence refresh for HEAD, branch, remote URL, origin/master..HEAD, staged area, working tree, .claude/ exclusion, and Evidence IDs.
```

```text
Lane: ambiguous push-vs-PR wording
Blocking State: No-Go
Recovery Path: require exact wording for push route or PR route, or a Human split into separate decisions.
```

```text
Lane: fake route Go
Blocking State: No-Go
Recovery Path: ignore implied, uncited, stale, local-only, or artifact-completeness Go as route selection.
```

```text
Lane: dirty staged files
Blocking State: No-Go
Recovery Path: clear staged files or explicitly review staged payload with evidence.
```

```text
Lane: missing evidence ref
Blocking State: No-Go
Recovery Path: append missing P17-EV-* or later Evidence ID and rerun evidence-first.
```

```text
Lane: unresolved No-Go
Blocking State: No-Go
Recovery Path: resolve evaluator No-Go or append an explicit Human accepted-risk decision.
```

```text
Lane: local-only state in release scope
Blocking State: No-Go
Recovery Path: exclude .claude/ and other local-only state from route, push, PR, release, and remote-sync scope.
```

## Evaluator Passes

```text
Pass Type: evidence-first
Purpose: inspect current HEAD, branch, remote URL, origin/master..HEAD, staged area, working tree, .claude/ exclusion, Evidence Refresh Checklist, Route Selection Readiness Record, Child Report, and P17 Evidence Index before reading Parent Synthesis.
```

```text
Pass Type: synthesis-comparison
Purpose: compare Parent Synthesis against evidence-first findings and verify every Parent claim cites only Child Report or P17-EV-* Evidence IDs.
```

## Evidence Index Rule

The Evidence Index must be append-only style. `P17-EV-*` IDs must be unique. Do not delete, rewrite, renumber, or silently reclassify Evidence ID entries.

## Human Decision

Human Decision remains pending in Phase 17.

```text
Selected Route: none
Route Selection Status: pending
push / PR Authorized: no
Remote Action Authorized: no
Remote Action Executed: no
No Remote/Network Action Occurred: yes
```
