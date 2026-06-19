# Phase 20 Execution Human Go Capture Guide

Phase 20 rehearses a markdown-only Execution Human Go Capture / Exact Command Binding Drill. It defines how a future explicit execution Human Go must bind to one selected route, one exact reviewed command text, and current local evidence.

Phase 20 does not select a route, authorize execution, authorize push, authorize PR, run a push command, open a PR, execute a remote command, perform a network remote action, release, stage, commit, or publish anything.

Phase 19 local commit does not authorize execution. It proves only that a local markdown drill was accepted. It cannot be reused as route selection, execution Human Go, push authorization, PR authorization, remote command approval, network remote action approval, release approval, or exact command approval.

## Authority Order

```text
Human-signed North Star
> explicit future Human route selection decision
> separate explicit Human execution Go
> exact reviewed command text
> current evidence refresh packet
> Execution Human Go Capture Packet
> Exact Command Binding Record
> Authorization Expiry Checklist
> evaluator evidence-first findings
> evaluator synthesis-comparison findings
> Parent Synthesis
> Child Report / Evidence Refs
> Chat Context
```

Chat memory is not route evidence, command evidence, current evidence, or execution Human Go evidence.

## Current Drill Boundary

```text
Selected Route: none
Route Selection Decision Status: missing
Execution Human Go Status: missing
Execution Authorized: no
push / PR Authorized: no
Remote Action Authorized: no
Remote Action Executed: no
Release Authorized: no
```

Artifact completeness, an ahead count, a local commit, candidate command text, and route-selection planning do not authorize execution.

## Valid Future Execution Human Go

A valid future execution Human Go must be explicit, current, and bound to exactly one execution route and exact command text.

```text
Required Field: Selected Route
Required Value: exactly one route from a separate valid route selection record
Current Value: none
Validation: missing route selection, ambiguous route wording, inferred route, plural route, or route drift blocks execution capture
```

```text
Required Field: Exact Reviewed Command Text
Required Value: exact command text reviewed in the binding record for the selected route only
Current Value: candidate documentation only, non-authorized
Validation: candidate command text, ambiguous command wording, command drift, placeholder command text, undocumented flags, or copied text from chat memory blocks execution capture
```

```text
Required Field: Current Evidence
Required Value: current HEAD, branch, remote URL, origin/master..HEAD, clean staged area, excluded .claude/, release scope, evaluator decision, and complete P20-EV-* evidence refs
Validation: stale evidence, dirty staged files, unexpected release files, local-only state in release scope, missing evidence ref, unresolved No-Go, or changed evidence blocks execution capture
```

```text
Required Field: Human Wording
Required Value: explicit Human execution Go naming the selected route and exact reviewed command text
Current Value: missing execution Go
Validation: fake execution Go, inferred approval, local commit, ahead count, route selection, artifact completeness, or chat-memory approval blocks execution capture
```

## Authorization Expiry Rule

Execution authorization expires before execution if any reviewed binding changes.

```text
Expires If Changed: route
Expires If Changed: command text
Expires If Changed: HEAD
Expires If Changed: branch
Expires If Changed: remote URL
Expires If Changed: origin/master..HEAD
Expires If Changed: staged area
Expires If Changed: working tree
Expires If Changed: release scope
Expires If Changed: evidence refs
Expires If Changed: evaluator decision
Expires If Changed: Human wording
```

Expired authorization cannot be repaired by memory. It requires a fresh evidence-first pass, refreshed exact command binding, evaluator review, and a new explicit Human execution Go.

## Blocking Conditions

Each blocker prevents execution capture until recovered with current evidence and explicit Human wording.

```text
Lane: missing execution Go
Blocking State: No-Go
Recovery Path: request separate explicit Human execution Go after route and command binding are complete.
```

```text
Lane: ambiguous command wording
Blocking State: No-Go
Recovery Path: restate the exact command text and bind Human wording to that text only.
```

```text
Lane: fake execution Go
Blocking State: No-Go
Recovery Path: reject approvals inferred from chat memory, candidate command text, route selection, local commit, ahead count, or artifact completeness.
```

```text
Lane: command drift
Blocking State: No-Go
Recovery Path: regenerate and re-review exact command text against current evidence.
```

```text
Lane: stale evidence
Blocking State: No-Go
Recovery Path: rerun evidence for HEAD, branch, remote URL, origin/master..HEAD, staged area, working tree, release scope, evaluator state, and Evidence IDs.
```

```text
Lane: dirty staged files
Blocking State: No-Go
Recovery Path: clear staged area or explicitly include staged payload in reviewed evidence before any future execution Go.
```

```text
Lane: unexpected release files
Blocking State: No-Go
Recovery Path: remove unexpected files from release scope or capture accepted-risk Human decision with evidence.
```

```text
Lane: missing evidence ref
Blocking State: No-Go
Recovery Path: append the missing P20-EV-* entry and rerun evidence-first.
```

```text
Lane: unresolved No-Go
Blocking State: No-Go
Recovery Path: resolve evaluator No-Go before requesting execution Human Go.
```

```text
Lane: local-only state
Blocking State: No-Go
Recovery Path: exclude .claude/ and other local-only state from push, PR, release, and remote-sync execution scope.
```

## Evaluator Passes

```text
Pass Type: evidence-first
Purpose: inspect current HEAD, branch, remote URL, origin/master..HEAD, staged area, working tree, release scope, local-only exclusion, Execution Human Go Capture Packet, Exact Command Binding Record, Authorization Expiry Checklist, Child Report, and P20 Evidence Index before reading Parent Synthesis.
```

```text
Pass Type: synthesis-comparison
Purpose: compare Parent Synthesis against evidence-first findings and verify every Parent claim cites only Child Report or P20-EV-* Evidence IDs.
```

## Evidence Index Rule

The Evidence Index must be append-only style. `P20-EV-*` IDs must be unique. Do not delete, rewrite, renumber, or silently reclassify Evidence ID entries.

## Human Decision

Human Decision remains pending in Phase 20.

```text
Selected Route: none
Execution Authorized: no
push / PR Authorized: no
Remote Action Authorized: no
Remote Action Executed: no
No Remote/Network Action Occurred: yes
```
