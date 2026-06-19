# Phase 21 Execution Denial / Abort and Recovery Guide

Phase 21 rehearses a markdown-only Execution Denial / Abort and Recovery Drill. It defines how the v2 control plane blocks execution when Human No-Go, expired authorization, last-moment abort, or evidence drift appears before execution.

Phase 21 does not select a route, authorize execution, authorize push, authorize PR, run a push command, open a PR, execute a remote command, perform a network remote action, release, stage, commit, or publish anything.

Phase 20 local commit does not authorize execution. It proves only that a local markdown drill was accepted. It cannot be reused as Human Go, route selection, execution permission, push authorization, PR authorization, remote command approval, network remote action approval, release approval, or exact command approval.

## Authority Order

```text
Human-signed North Star
> explicit current Human Go for execution
> current evaluator evidence-first pass
> current evaluator synthesis-comparison pass
> recovery decision matrix
> abort trigger checklist
> execution denial record
> Parent Synthesis
> Child Report / P21 Evidence Refs
> Chat Context
```

Chat memory is not execution permission. Chat-only approval, silence, stale approval, ambiguous abort wording, and candidate command text cannot authorize execution.

## Current Drill Boundary

```text
Selected Route: none
Execution Human Go Status: missing
Human Decision State: pending
Execution Authorized: no
push / PR Authorized: no
Remote Action Authorized: no
Remote Action Executed: no
Release Authorized: no
```

Artifact completeness, a local commit, ahead count, candidate command text, local-only state, and parent synthesis text do not authorize execution.

## Execution Denial Rule

Execution denial is mandatory when any blocking condition is present before execution.

```text
Human No-Go: blocks execution
expired authorization: blocks execution
ambiguous abort wording: blocks execution until clarified as recovery decision evidence
stale approval: blocks execution
silence: blocks execution
chat-only approval: blocks execution
changed HEAD/range/remote: blocks execution
dirty staged files: blocks execution
unexpected release files: blocks execution
missing evidence ref: blocks execution
unresolved No-Go: blocks execution
local-only state in release scope: blocks execution
```

Parent cannot convert rejection, silence, stale approval, local commit, ahead count, candidate command text, or chat-only wording into execution permission.

## Abort Trigger Rule

An abort trigger takes precedence over any candidate execution path. The control plane must stop before execution if the trigger appears after review and before command use.

```text
abort trigger: Human No-Go
abort trigger: authorization expired
abort trigger: ambiguous stop or abort wording
abort trigger: evidence drift
abort trigger: staged payload changed
abort trigger: release scope changed
abort trigger: remote target changed
abort trigger: missing or invalid Evidence ID
abort trigger: unresolved evaluator No-Go
```

Abort is not failure to follow the plan. Abort is the required safe state when execution evidence is no longer current.

## Recovery Decision Rule

Recovery requires a new decision path. Recovery cannot reuse stale evidence, stale approval, local commit acceptance, parent inference, or chat-only wording.

```text
Step 1: stop execution and record execution denial.
Step 2: refresh evidence for HEAD, branch, remote URL, origin/master..HEAD, staged area, working tree, release scope, local-only exclusions, and Evidence IDs.
Step 3: rerun evaluator evidence-first.
Step 4: rerun evaluator synthesis-comparison.
Step 5: require a new explicit Human Go naming the current execution decision.
```

Until all recovery steps complete, `Execution Authorized: no` and `push / PR Authorized: no` remain true.

## Evaluator Passes

```text
Pass Type: evidence-first
Purpose: inspect current denial state, abort trigger checklist, recovery decision matrix, HEAD, branch, remote URL, origin/master..HEAD, staged area, working tree, release scope, local-only exclusion, Child Report, Human Decision placeholder, and P21 Evidence Index before reading Parent Synthesis.
```

```text
Pass Type: synthesis-comparison
Purpose: compare Parent Synthesis against evidence-first findings and verify every Parent claim cites only Child Report or P21-EV-* Evidence IDs.
```

## Evidence Index Rule

The Evidence Index must be append-only style. `P21-EV-*` IDs must be unique. Do not delete, rewrite, renumber, or silently reclassify Evidence ID entries.

## Human Decision

Human Decision remains pending in Phase 21.

```text
Execution Authorized: no
push / PR Authorized: no
Remote Action Authorized: no
Remote Action Executed: no
No Remote/Network Action Occurred: yes
```
