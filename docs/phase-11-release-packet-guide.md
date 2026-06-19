# Phase 11 Release Packet Guide

Phase 11 rehearses a release packet for remote-sync authorization requests. It keeps v2 as a markdown control plane and does not add runner, CI, Docker, browser automation, source code, production access, secrets, paid actions, push, or PR.

## Authority Order

```text
Human-signed North Star
> release packet
> evaluator evidence-first findings
> evaluator synthesis-comparison findings
> Parent Synthesis
> Child Report / Evidence Refs
> Chat Context
```

Chat memory is not release evidence.

## Remote-Sync Boundary

The release packet can summarize `origin/master..HEAD` without performing push/PR. A push or PR requires separate Human Go with an evidence ref. Local commit approval, ahead count, or a completed release packet does not authorize remote-sync.

## Blocking Lanes

```text
missing commit range: No-Go
missing evidence refs: No-Go
dirty staged files: No-Go
unreviewed scope change: No-Go
fake remote approval: No-Go
unexpected release files: No-Go
local-only state in packet: No-Go
```

## Parent Boundary

Parent cannot assign itself. Parent may prepare release packet artifacts, synthesize evidence, and ask Human for a remote-sync decision. Parent cannot push, open a PR, infer approval from local commits, or include `.claude/` in the release packet.

## Evaluator Passes

```text
Pass Type: evidence-first
Purpose: inspect git status, origin/master..HEAD commit range, release packet, child report, staged file status, and Evidence Index before reading Parent Synthesis.
```

```text
Pass Type: synthesis-comparison
Purpose: compare Parent Synthesis against evidence-first release packet findings and ensure every release claim cites Evidence IDs.
```

Evaluator `No-Go` blocks release packet acceptance. Missing commit range, missing evidence refs, dirty staged files, unreviewed scope change, fake remote approval, or unexpected release files must route back to blocked review before any remote-sync action.

## Human Decision

Human Decision remains pending until the user gives a separate Human Go for push or PR. The placeholder must state `push / PR Authorized: no` until that happens.
