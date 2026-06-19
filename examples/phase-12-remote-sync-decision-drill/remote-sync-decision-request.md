# Remote-Sync Decision Request: authorization expiry drill

## Header

```text
Request ID: REQUEST-P12-REMOTE-SYNC-001
Task Instance Ref: examples/phase-12-remote-sync-decision-drill/task-instance.md
Created At: 2026-06-19
```

## Requested Decision

```text
Requested Decision Type: future remote-sync Human Go
Current Decision State: pending
Remote Action Requested Now: none
push / PR Authorized: no
separate Human Go: missing
```

## Commit Range And Status

```text
Commit Range: origin/master..HEAD
Branch State: master...origin/master [ahead 11]
Latest Local Commit: 59450ee docs: add v2 phase 11 release packet drill
Required Status: no staged files; only explicitly excluded local state may remain untracked.
Excluded Local State: .claude/ and any other untracked local machine state
Evidence Refs: P12-EV-004, P12-EV-009
```

## Validity Requirements

```text
Requirement: explicit origin/master..HEAD range
Requirement: clean staged area
Requirement: complete P12 Evidence Refs for decision claims
Requirement: .claude/ excluded from remote-sync scope
Requirement: no unreviewed scope change
Requirement: separate Human Go with evidence ref before push or PR
```

## Authorization Expiry Triggers

```text
authorization expires: origin/master..HEAD changes after review
authorization expires: staged files appear
authorization expires: working tree changes are not reviewed
authorization expires: .claude/ enters remote-sync scope
authorization expires: unexpected release files appear
authorization expires: missing evidence refs are discovered
authorization expires: unreviewed scope change appears
authorization expires: fake remote approval is recorded
```

## Blocking Lanes

```text
Lane: changed commit range
Blocking State: No-Go
Recovery: regenerate decision request and request fresh Human Go with updated evidence refs.
```

```text
Lane: dirty staged files
Blocking State: No-Go
Recovery: clear or explicitly review staged payload before remote-sync.
```

```text
Lane: .claude in release scope
Blocking State: No-Go
Recovery: exclude local-only state from remote-sync scope and rerun evidence-first review.
```

```text
Lane: unexpected release files
Blocking State: No-Go
Recovery: identify file, classify scope, and route to Human if remote-sync payload expands.
```

```text
Lane: missing evidence refs
Blocking State: No-Go
Recovery: add P12 Evidence IDs for each remote-sync decision claim before Parent Synthesis.
```

```text
Lane: unreviewed scope change
Blocking State: No-Go
Recovery: append scope-change evidence and wait for Human decision.
```

```text
Lane: fake remote approval
Blocking State: No-Go
Recovery: require separate Human Go with evidence ref.
```
