# Phase 18 Route Selection Decision Capture Guide

Phase 18 rehearses a markdown-only Route Selection Decision Capture / Single-Route Binding Drill. It defines how a future Human route decision is captured, validated, bound to exactly one route, and blocked when wording or evidence is ambiguous.

Phase 18 does not choose a real route, authorize push, authorize PR, execute a remote command, perform a network remote action, release, stage, commit, open a PR, push, or publish anything.

Phase 17 local commit does not select push or PR. It is only a local artifact completeness event and cannot be reused as route selection, push authorization, PR authorization, release approval, remote command approval, network remote action approval, or remote outcome acceptance.

## Authority Order

```text
Human-signed North Star
> explicit future Human route selection decision
> current evidence refresh packet
> Route Selection Decision Packet
> Single-Route Binding Record
> Ambiguity Rejection Checklist
> evaluator evidence-first findings
> evaluator synthesis-comparison findings
> Parent Synthesis
> Child Report / Evidence Refs
> Chat Context
```

Chat context is not route selection decision evidence.

## Decision Boundary

Phase 18 only defines the future capture rule. It does not capture a real route decision in this drill.

```text
Selected Route: none
Route Selection Decision Status: pending
Single-Route Binding Status: unbound
Remote-Sync Authorization: not granted
push / PR Authorized: no
Remote Action Authorized: no
Remote Action Executed: no
Release Authorized: no
```

## Valid Future Decision Shape

A valid future route selection decision must choose exactly one route: `push` or `PR`.

```text
Required Field: Human Exact Wording
Required Value: explicit future Human route selection decision
Validation: wording must name exactly one route, push or PR
```

```text
Required Field: Selected Route
Required Value: push or PR
Validation: any missing, plural, combined, conditional, implied, or inferred route value blocks capture
```

```text
Required Field: Evidence Refs
Required Value: current P18-EV-* or later Evidence IDs
Validation: every route selection decision claim must be backed by evidence refs
```

```text
Required Field: Scope Binding
Required Value: current HEAD, branch, remote URL, origin/master..HEAD, staged area, working tree, local-only exclusion, and unresolved No-Go state
Validation: changed HEAD/range/remote, dirty staged files, stale evidence, missing evidence ref, unresolved No-Go, or local-only state in release scope blocks capture
```

## Single-Route Binding

Single-route binding means the decision record binds one Human selection to one route and no execution.

```text
Route: push
Meaning: future direct update route selection only
Execution Authorization: not included
```

```text
Route: PR
Meaning: future pull request route selection only
Execution Authorization: not included
```

Push and PR are mutually exclusive route values. Dual-route approval blocks route decision capture unless Human explicitly splits push and PR into separate future decisions with separate evidence records.

## Capture Blockers

Each blocker below prevents route selection decision capture until recovered with current evidence.

```text
Lane: ambiguous route wording
Blocking State: No-Go
Recovery Path: require exact wording naming push or PR, not both.
```

```text
Lane: dual-route approval
Blocking State: No-Go
Recovery Path: split into separate route decisions or select exactly one route.
```

```text
Lane: stale evidence
Blocking State: No-Go
Recovery Path: rerun evidence refresh for HEAD, branch, remote URL, origin/master..HEAD, staged area, working tree, .claude/ exclusion, and Evidence IDs.
```

```text
Lane: fake route Go
Blocking State: No-Go
Recovery Path: ignore implied, uncited, stale, local-only, local-commit, or artifact-completeness Go as route selection.
```

```text
Lane: missing evidence ref
Blocking State: No-Go
Recovery Path: append missing P18-EV-* or later Evidence ID and rerun evidence-first.
```

```text
Lane: dirty staged files
Blocking State: No-Go
Recovery Path: clear staged area or explicitly review staged payload with evidence.
```

```text
Lane: unresolved No-Go
Blocking State: No-Go
Recovery Path: resolve evaluator No-Go or append an explicit Human accepted-risk decision.
```

```text
Lane: changed HEAD/range/remote
Blocking State: No-Go
Recovery Path: restart route selection decision capture with fresh HEAD, origin/master..HEAD, and remote URL evidence.
```

```text
Lane: local-only state in release scope
Blocking State: No-Go
Recovery Path: exclude .claude/ and other local-only state from route, push, PR, release, and remote-sync scope.
```

## Separation From Execution

Route selection remains separate from execution. Even a valid future route selection decision does not itself execute push or PR, create a remote branch, open a PR, run a remote command, perform a network remote action, or release.

```text
Decision Capture: records exactly one selected route
Execution Handoff: separate future artifact
Execution Authorization: separate future Human Go
Remote/Network Action: not authorized by route selection decision capture
```

## Evaluator Passes

```text
Pass Type: evidence-first
Purpose: inspect current HEAD, branch, remote URL, origin/master..HEAD, staged area, working tree, .claude/ exclusion, Route Selection Decision Packet, Single-Route Binding Record, Ambiguity Rejection Checklist, Child Report, and P18 Evidence Index before reading Parent Synthesis.
```

```text
Pass Type: synthesis-comparison
Purpose: compare Parent Synthesis against evidence-first findings and verify every Parent claim cites only Child Report or P18-EV-* Evidence IDs.
```

## Evidence Index Rule

The Evidence Index must be append-only style. `P18-EV-*` IDs must be unique. Do not delete, rewrite, renumber, or silently reclassify Evidence ID entries.

## Human Decision

Human Decision remains pending in Phase 18.

```text
Selected Route: none
Route Selection Decision Status: pending
Single-Route Binding Status: unbound
push / PR Authorized: no
Remote Action Authorized: no
Remote Action Executed: no
No Remote/Network Action Occurred: yes
```
