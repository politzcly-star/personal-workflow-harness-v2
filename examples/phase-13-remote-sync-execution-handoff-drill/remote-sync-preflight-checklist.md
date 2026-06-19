# Remote-Sync Preflight Checklist: execution handoff drill

## Header

```text
Checklist ID: CHECK-P13-REMOTE-SYNC-PREFLIGHT-001
Task Instance Ref: examples/phase-13-remote-sync-execution-handoff-drill/task-instance.md
Created At: 2026-06-19
Current Decision State: pending
push / PR Authorized: no
execution Human Go: missing
```

## Required Current Facts

```text
Check: branch
Required: master
Execution Valid Only If Current: yes
Evidence Refs: P13-EV-005, P13-EV-011
```

```text
Check: remote URL
Required: origin remains the reviewed remote URL
Execution Valid Only If Current: yes
Evidence Refs: P13-EV-005, P13-EV-011
```

```text
Check: commit range
Required: explicit origin/master..HEAD
Execution Valid Only If Current: yes
Evidence Refs: P13-EV-005, P13-EV-011
```

```text
Check: staged area
Required: clean staged area
Execution Valid Only If Current: yes
Evidence Refs: P13-EV-005, P13-EV-011
```

```text
Check: local-only state
Required: .claude/ excluded from payload
Execution Valid Only If Current: yes
Evidence Refs: P13-EV-005, P13-EV-010, P13-EV-011
```

```text
Check: evidence refs
Required: complete P13-EV-001 through P13-EV-011, plus Phase 10-12 release gate, release packet, and remote-sync decision artifacts
Execution Valid Only If Current: yes
Evidence Refs: P13-EV-001, P13-EV-002, P13-EV-003, P13-EV-004, P13-EV-005, P13-EV-006, P13-EV-007, P13-EV-008, P13-EV-009, P13-EV-010, P13-EV-011
```

## Authorization Expiry Checks

```text
authorization expires: HEAD changes after review
authorization expires: branch changes after review
authorization expires: remote URL changes after review
authorization expires: working tree changes after review
authorization expires: staged area changes after review
authorization expires: release scope changes after review
authorization expires: evidence refs change, disappear, or become stale
```

## Blocking Execution Lanes

```text
Lane: missing execution Human Go
Blocking State: No-Go
Recovery: obtain explicit Human Go naming execution route and current evidence refs.
```

```text
Lane: ambiguous push-vs-PR route
Blocking State: No-Go
Recovery: Human must choose push, PR, or no remote action before execution.
```

```text
Lane: stale release packet
Blocking State: No-Go
Recovery: refresh Phase 11 release packet evidence and rerun evaluator evidence-first pass.
```

```text
Lane: fake command authorization
Blocking State: No-Go
Recovery: treat candidate actions as inert until separate execution Human Go exists.
```

```text
Lane: dirty staged files
Blocking State: No-Go
Recovery: clear staged area or review staged payload before execution.
```

```text
Lane: unexpected release files
Blocking State: No-Go
Recovery: classify file, update release scope, and route to Human if payload expands.
```

```text
Lane: .claude/ in payload
Blocking State: No-Go
Recovery: keep .claude/ excluded and rerun scope verification.
```

## Preflight Result

```text
Result: blocked: needs-execution-human-go
Reason: Human Decision is pending; push / PR Authorized: no; execution Human Go: missing.
Remote Command Execution: not authorized
```
