# Phase 22 Authorization State Canonicalization Guide

Phase 22 rehearses a markdown-only Authorization State Canonicalization / Cross-Artifact Consistency Drill. It converts the Phase 21 non-blocking observations into an independent consistency drill: every authorization state must use the same canonical status fields, every non-authorization input must be inventoried, and any cross-artifact mismatch blocks acceptance.

Phase 22 does not revise Phase 21 artifacts, select a route, authorize execution, authorize push, authorize PR, run a command, perform a remote/network action, stage, commit, push, open a PR, release, or publish anything.

## Authority Order

```text
Human-signed North Star
> canonical authorization state field registry
> cross-artifact consistency checklist
> non-authorization input inventory
> current evaluator evidence-first pass
> current evaluator synthesis-comparison pass
> Parent Synthesis
> Child Report / P22 Evidence Refs
> Chat Context
```

Chat context cannot repair a missing canonical status field, conflicting yes/no field, omitted non-authorization input, stale evidence, dirty staged files, missing evidence ref, unresolved No-Go, or local-only state in release scope.

## Canonical Status Fields

Every Phase 22 decision-bearing artifact must use these exact canonical status fields when it discusses authorization state.

```text
Execution Authorized: no
push / PR Authorized: no
Remote Action Authorized: no
Remote Execution Authorized: no
Remote Action Executed: no
Release Authorized: no
```

If an artifact introduces a conflicting synonym, partial yes/no field, or local-only release implication, acceptance is blocked until the artifact is corrected in the current Phase 22 scope.

## Non-Authorization Inputs

These inputs are evidence about state, not permission.

```text
rejection: does not authorize execution, push, PR, remote action, remote execution, or release
silence: does not authorize execution, push, PR, remote action, remote execution, or release
stale approval: does not authorize execution, push, PR, remote action, remote execution, or release
local commit: does not authorize execution, push, PR, remote action, remote execution, or release
ahead count: does not authorize execution, push, PR, remote action, remote execution, or release
candidate command text: does not authorize execution, push, PR, remote action, remote execution, or release
chat-only wording: does not authorize execution, push, PR, remote action, remote execution, or release
artifact completeness: does not authorize execution, push, PR, remote action, remote execution, or release
```

Parent cannot convert these inputs into permission. Evaluator must treat omission of any input from the inventory as a blocking artifact completeness defect.

## Cross-Artifact Blockers

Acceptance is blocked by any of the following:

```text
missing canonical status field
conflicting yes/no fields
omitted non-authorization input
stale evidence
dirty staged files
missing evidence ref
unresolved No-Go
local-only state in release scope
Parent Synthesis claim without Child Report or P22-EV-* citation
duplicate P22-EV-* Evidence ID
non-append-only Evidence Index rewrite
```

The control plane must preserve the safest state when artifacts disagree:

```text
Execution Authorized: no
push / PR Authorized: no
Remote Action Authorized: no
Remote Execution Authorized: no
Remote Action Executed: no
Release Authorized: no
```

## Evaluator Passes

```text
Pass Type: evidence-first
Purpose: inspect the canonical status fields, non-authorization input inventory, cross-artifact consistency checklist, Human Decision placeholder, Child Report, README navigation, local git evidence, and P22 Evidence Index before reading Parent Synthesis.
```

```text
Pass Type: synthesis-comparison
Purpose: compare Parent Synthesis against evidence-first findings and verify every Parent claim cites only Child Report or P22-EV-* Evidence IDs.
```

## Evidence Index Rule

The Evidence Index must be append-only style. `P22-EV-*` IDs must be unique. Do not delete, rewrite, renumber, or silently reclassify Evidence ID entries.

## Human Decision

Human Decision remains pending in Phase 22.

```text
Execution Authorized: no
push / PR Authorized: no
Remote Action Authorized: no
Remote Execution Authorized: no
Remote Action Executed: no
Release Authorized: no
No Remote/Network Action Occurred: yes
```
