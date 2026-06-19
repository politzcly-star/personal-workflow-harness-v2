# Phase 13 Remote-Sync Execution Handoff Guide

Phase 13 rehearses the final paper handoff before any future remote-sync execution. It keeps v2 as a markdown control plane and does not add runner, CI, Docker, browser automation, source code, production access, secrets, paid actions, push, PR, or command execution against a remote.

## Authority Order

```text
Human-signed North Star
> Phase 10 release gate
> Phase 11 release packet
> Phase 12 remote-sync decision
> Phase 13 remote-sync execution handoff
> evaluator evidence-first findings
> evaluator synthesis-comparison findings
> Parent Synthesis
> Child Report / Evidence Refs
> Chat Context
```

Chat memory is not remote-sync execution authorization evidence.

## Decision Separation

Local commit acceptance, remote-sync authorization, and remote-sync execution are three independent decisions. A local commit Go does not authorize push or PR. A remote-sync decision does not authorize execution. Remote-sync execution requires a separate `execution Human Go` with current evidence refs.

## Execution Validity

A future `execution Human Go` is valid only for the current `master` branch, current `origin` remote URL, explicit `origin/master..HEAD` commit range, clean staged area, `.claude/ excluded` from payload, and complete evidence refs captured during review.

## Authorization Expiry

```text
authorization expires: HEAD changes after review
authorization expires: branch changes after review
authorization expires: remote URL changes after review
authorization expires: working tree changes after review
authorization expires: staged area changes after review
authorization expires: release scope changes after review
authorization expires: evidence refs change, disappear, or become stale
```

Expired authorization is missing authorization. Parent must return to `blocked: needs-human-decision` or request fresh review before any remote-sync execution.

## Candidate Actions Boundary

Future remote commands may be written only as `candidate actions`. Candidate actions are not authorized, not approved, and not executed by this drill. A candidate `git push` or PR route must remain inert until Human selects one explicit route and records `execution Human Go` with evidence refs.

## Blocking Lanes

```text
missing execution Human Go: No-Go
ambiguous push-vs-PR route: No-Go
stale release packet: No-Go
fake command authorization: No-Go
dirty staged files: No-Go
unexpected release files: No-Go
.claude/ in payload: No-Go
```

Evaluator `No-Go` blocks remote-sync execution lanes. Parent cannot reject or override it. Push and PR remain unauthorized until a fresh Human decision names the route and cites current evidence.

## Evaluator Passes

```text
Pass Type: evidence-first
Purpose: inspect current git status, remote URL, branch, origin/master..HEAD, staged files, runbook, preflight checklist, child report, and Evidence Index before reading Parent Synthesis.
```

```text
Pass Type: synthesis-comparison
Purpose: compare Parent Synthesis against evidence-first execution handoff findings and ensure every execution claim cites Child Report or P13 Evidence IDs.
```

## Human Decision

Human Decision remains pending until the user gives separate `execution Human Go`. The placeholder must state `push / PR Authorized: no` and `execution Human Go: missing`.
