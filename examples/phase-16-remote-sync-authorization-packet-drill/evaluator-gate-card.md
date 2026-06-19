# Evaluator Gate Card: remote-sync authorization packet drill

## Header

```text
Gate Card ID: EVAL-P16-REMOTE-SYNC-AUTH-PACKET-001
Evaluator ID: EVAL-P16-REMOTE-SYNC-AUTH-PACKET
Task Instance Ref: examples/phase-16-remote-sync-authorization-packet-drill/task-instance.md
Pass Types: evidence-first, synthesis-comparison
Created At: 2026-06-19
```

## Inputs

```text
Input Artifacts:
- Human-signed North Star: P16-EV-001
- Dispatch Matrix: P16-EV-002
- Phase 16 Guide: P16-EV-003
- Remote-Sync Authorization Packet: P16-EV-004, P16-EV-012
- Route Decision Matrix: P16-EV-005
- Child Report: P16-EV-006, P16-EV-010, P16-EV-011
- Parent Synthesis: read only during synthesis-comparison, P16-EV-008
- Human Decision Placeholder: P16-EV-009
- README Navigation: P16-EV-013
- Evidence Index: P16-EV-001 through P16-EV-013
```

## Evidence-First Pass

```text
Pass Type: evidence-first
Decision: No-Go for authorization
Lane: missing route selection
Summary: missing route selection blocks authorization because push and PR are separate routes and neither has been selected by Human.
Basis: P16-EV-004, P16-EV-005, P16-EV-009, P16-EV-012
Recovery Path: request explicit Human route selection with current evidence refs.
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go for authorization
Lane: stale baseline closure
Summary: Phase 15 local baseline closure does not authorize remote sync and cannot be reused if local evidence has drifted.
Basis: P16-EV-003, P16-EV-004, P16-EV-005, P16-EV-012
Recovery Path: refresh baseline closure evidence and rerun route decision review.
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go for authorization
Lane: branch/remote mismatch
Summary: branch/remote mismatch invalidates the required binding to master, origin URL, and origin/master..HEAD.
Basis: P16-EV-004, P16-EV-010, P16-EV-012
Recovery Path: refresh branch, remote URL, and commit range evidence.
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go for authorization
Lane: dirty staged files
Summary: dirty staged files block authorization because staged payload could diverge from the reviewed packet.
Basis: P16-EV-004, P16-EV-010, P16-EV-012
Recovery Path: clear staged area or explicitly review staged payload with evidence.
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go for authorization
Lane: missing evidence ref
Summary: missing evidence ref blocks authorization because Parent Synthesis and route decisions must be reconstructable without chat memory.
Basis: P16-EV-006, P16-EV-007, P16-EV-011, P16-EV-012
Recovery Path: append the missing P16-EV-* entry and rerun evidence-first review.
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go for authorization
Lane: fake remote Go
Summary: fake remote Go blocks authorization when approval is uncited, implied, stale, ambiguous, chat-only, or derived from local baseline closure.
Basis: P16-EV-001, P16-EV-004, P16-EV-005, P16-EV-009
Recovery Path: require explicit Human route selection with current evidence refs.
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go for authorization
Lane: unresolved No-Go
Summary: unresolved No-Go remains binding and blocks any future push or PR authorization.
Basis: P16-EV-007, P16-EV-012
Recovery Path: resolve the evaluator finding or append Human accepted-risk evidence.
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go for authorization
Lane: local-only state in release scope
Summary: local-only state in release scope blocks authorization because .claude/ and machine-local files are excluded from remote-sync scope.
Basis: P16-EV-004, P16-EV-010, P16-EV-012
Recovery Path: remove local-only state from release scope and record exclusion evidence.
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: Go for paper evidence completeness
Lane: no remote/network action occurred
Summary: Phase 16 records no push, PR, remote command, network remote action, or release, and keeps Human Decision pending.
Basis: P16-EV-001, P16-EV-006, P16-EV-009, P16-EV-010, P16-EV-011
Blocking: none for paper packet completeness
```

## Synthesis-Comparison Pass

```text
Pass Type: synthesis-comparison
Decision: Go for artifact completeness
Summary: Parent Synthesis uses Child Report and P16-EV-* Evidence IDs for each claim and does not infer remote-sync authorization from Phase 15 baseline closure, local commit state, chat memory, or candidate route text.
Basis: P16-EV-001, P16-EV-002, P16-EV-003, P16-EV-004, P16-EV-005, P16-EV-006, P16-EV-007, P16-EV-008, P16-EV-009, P16-EV-010, P16-EV-011, P16-EV-012, P16-EV-013
Blocking: none for drill artifact completeness
```

## Overall Gate Result

```text
Decision: Go for paper packet completeness
Remote-Sync Authorization Allowed: no
Route Selection Accepted: no
Release Allowed: no
Reason: The drill prepares a remote-sync authorization packet and route decision matrix without staging, committing, pushing, opening a PR, executing remote commands, performing network remote action, or release.
Conditions: Human Decision remains pending; selected route is none; push / PR Authorized: no.
Evidence Gaps: explicit Human route selection and remote execution evidence are intentionally absent because Phase 16 is paper-only and remote action is unauthorized.
```

Evaluator No-Go blocks authorization. Parent cannot reject or override missing route selection, stale baseline closure, branch/remote mismatch, dirty staged files, missing evidence ref, fake remote Go, unresolved No-Go, or local-only state in release scope.
