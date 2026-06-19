# Phase 12 Remote-Sync Decision Guide

Phase 12 rehearses the lifecycle of a remote-sync decision. It keeps v2 as a markdown control plane and does not add runner, CI, Docker, browser automation, source code, production access, secrets, paid actions, push, or PR.

## Authority Order

```text
Human-signed North Star
> remote-sync decision request
> evaluator evidence-first findings
> evaluator synthesis-comparison findings
> Parent Synthesis
> Child Report / Evidence Refs
> Chat Context
```

Chat memory is not remote-sync authorization evidence.

## Decision Boundary

Local commit Go is not push/PR authorization. A remote-sync decision requires separate Human Go with an evidence ref. That Human Go is valid only for the explicit `origin/master..HEAD` commit range, clean status, and complete evidence refs captured in the decision request.

## Authorization Expiry

```text
authorization expires: commit range changed
authorization expires: working tree changed after review
authorization expires: staged files appear
authorization expires: evidence refs are missing or stale
authorization expires: scope changes are unreviewed
```

Expired authorization is treated as missing authorization. Parent must return to `blocked: needs-human-decision` or request a fresh Human Go with updated evidence.

## Blocking Lanes

```text
changed commit range: No-Go
dirty staged files: No-Go
.claude in release scope: No-Go
unexpected release files: No-Go
missing evidence refs: No-Go
unreviewed scope change: No-Go
fake remote approval: No-Go
```

## Parent Boundary

Parent cannot assign itself. Parent may prepare a remote-sync decision request, synthesize evidence, and ask Human for a separate push/PR decision. Parent cannot push, open a PR, infer approval from local commits, or include `.claude/` in remote-sync scope.

## Evaluator Passes

```text
Pass Type: evidence-first
Purpose: inspect git status, origin/master..HEAD commit range, staged file status, decision request, child report, and Evidence Index before reading Parent Synthesis.
```

```text
Pass Type: synthesis-comparison
Purpose: compare Parent Synthesis against evidence-first remote-sync decision findings and ensure every decision claim cites Evidence IDs.
```

Evaluator `No-Go` blocks remote-sync decision acceptance. Changed commit range, dirty staged files, `.claude` in release scope, unexpected release files, missing evidence refs, unreviewed scope change, or fake remote approval must route back to blocked review before any push or PR.

## Human Decision

Human Decision remains pending until the user gives a separate Human Go for push or PR. The placeholder must state `push / PR Authorized: no` and `separate Human Go: missing` until that happens.
