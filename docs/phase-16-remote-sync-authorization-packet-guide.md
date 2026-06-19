# Phase 16 Remote-Sync Authorization Packet Guide

Phase 16 rehearses a markdown-only remote-sync authorization packet and route decision drill. It prepares the paper evidence a future Human would need before choosing either a push route or a PR route. It does not authorize or perform push, PR, remote command execution, network remote action, release, runner, CI, Docker, browser automation, source code changes, GitHub issue tracker integration, production access, database access, secrets access, or paid external actions.

Phase 15 local baseline closure does not authorize remote sync. Baseline closure proves local reconstruction only. It cannot be reused as push authorization, PR authorization, release approval, or remote outcome acceptance.

## Authority Order

```text
Human-signed North Star
> explicit Human route selection
> Remote-Sync Authorization Packet
> Route Decision Matrix
> evaluator evidence-first findings
> evaluator synthesis-comparison findings
> Parent Synthesis
> Child Report / Evidence Refs
> Chat Context
```

Chat memory is not remote-sync authorization evidence.

## Route Separation

Push and PR are separate routes. The packet may describe both as future candidates, but the Human must explicitly select one route before any future remote-sync authorization can be considered.

```text
Route: push
State In Phase 16: candidate only
Authorization State: not authorized
Required Human Selection: explicit push route selection with current evidence refs
```

```text
Route: PR
State In Phase 16: candidate only
Authorization State: not authorized
Required Human Selection: explicit PR route selection with current evidence refs
```

Selecting one route does not authorize the other route. A local commit Go, Phase 15 baseline closure, artifact-completeness Go, or candidate command text cannot substitute for Human route selection.

## Required Future Authorization Binding

Any future authorization must bind to the exact reviewed local evidence. The binding must be refreshed if any element drifts.

```text
Required Branch: master
Required Remote Name: origin
Required Remote URL: https://github.com/politzcly-star/personal-workflow-harness-v2.git
Required Commit Range: explicit origin/master..HEAD
Required Staged Area: clean
Required Local-Only Exclusion: .claude/ excluded from remote-sync scope
Required Evidence: complete P16-EV-* Evidence Refs for every authorization claim
Required Route: exactly one Human-selected route, push or PR
```

## Authorization Blockers

Each blocker below prevents remote-sync authorization until recovered with current evidence and a fresh Human decision.

```text
Lane: missing route selection
Blocking State: No-Go
Recovery Path: ask Human to select exactly one route, push or PR, with current evidence refs.
```

```text
Lane: stale baseline closure
Blocking State: No-Go
Recovery Path: refresh baseline closure evidence and prove Phase 15 local baseline closure still matches the current origin/master..HEAD range before requesting route selection.
```

```text
Lane: branch/remote mismatch
Blocking State: No-Go
Recovery Path: refresh branch, remote URL, and origin/master..HEAD evidence before any authorization request.
```

```text
Lane: dirty staged files
Blocking State: No-Go
Recovery Path: clear staged files or explicitly review staged payload before any authorization request.
```

```text
Lane: missing evidence ref
Blocking State: No-Go
Recovery Path: append the missing P16-EV-* entry and rerun evidence-first review.
```

```text
Lane: fake remote Go
Blocking State: No-Go
Recovery Path: ignore uncited, ambiguous, or implied approval and request explicit Human route selection with evidence refs.
```

```text
Lane: unresolved No-Go
Blocking State: No-Go
Recovery Path: resolve the evaluator No-Go or append a Human accepted-risk decision before any future authorization request.
```

```text
Lane: local-only state in release scope
Blocking State: No-Go
Recovery Path: remove .claude/ and other local-only state from remote-sync or release scope and record exclusion evidence.
```

## Evaluator Passes

```text
Pass Type: evidence-first
Purpose: inspect branch, remote URL, origin/master..HEAD, staged area, .claude/ exclusion, authorization packet, route decision matrix, child report, and P16 Evidence Index before reading Parent Synthesis.
```

```text
Pass Type: synthesis-comparison
Purpose: compare Parent Synthesis against evidence-first findings and verify that every Parent claim cites only Child Report or P16-EV-* Evidence IDs.
```

Evaluator No-Go blocks authorization. Parent cannot override missing route selection, stale baseline closure, branch/remote mismatch, dirty staged files, missing evidence ref, fake remote Go, unresolved No-Go, or local-only state in release scope.

## Evidence Index Rule

The Evidence Index must be append-only style. `P16-EV-*` IDs must be unique. Do not delete, rewrite, renumber, or silently reclassify Evidence ID entries.

## Human Decision

Human Decision remains pending in Phase 16.

```text
Selected Route: none
push / PR Authorized: no
Remote Action Authorized: no
Remote Action Executed: no
Release Authorized: no
```
