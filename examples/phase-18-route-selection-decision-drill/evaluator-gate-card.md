# Evaluator Gate Card: route selection decision drill

## Header

```text
Gate Card ID: EVAL-P18-ROUTE-SELECTION-DECISION-001
Evaluator ID: EVAL-P18-ROUTE-SELECTION-DECISION
Task Instance Ref: examples/phase-18-route-selection-decision-drill/task-instance.md
Pass Types: evidence-first, synthesis-comparison
Created At: 2026-06-19
```

## Inputs

```text
Input Artifacts:
- Human-signed North Star: P18-EV-001
- Dispatch Matrix: P18-EV-002
- Phase 18 Guide: P18-EV-003
- Route Selection Decision Packet: P18-EV-004, P18-EV-015
- Single-Route Binding Record: P18-EV-005, P18-EV-014
- Ambiguity Rejection Checklist: P18-EV-006, P18-EV-016
- Child Report: P18-EV-007, P18-EV-011, P18-EV-012
- Parent Synthesis: read only during synthesis-comparison, P18-EV-009
- Human Decision Placeholder: P18-EV-010
- README Navigation: P18-EV-013
- Evidence Index: P18-EV-001 through P18-EV-016
```

## Evidence-First Pass

```text
Pass Type: evidence-first
Decision: No-Go for real route selection decision capture
Lane: missing route selection decision
Summary: Human Decision remains pending, Selected Route: none, and no single-route binding exists.
Basis: P18-EV-003, P18-EV-004, P18-EV-005, P18-EV-010
Recovery Path: request explicit Human route selection decision with current evidence refs.
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go for route decision capture
Lane: ambiguous route wording
Summary: ambiguous route wording blocks capture unless Human names exactly one route, push or PR.
Basis: P18-EV-003, P18-EV-004, P18-EV-006, P18-EV-016
Recovery Path: require exact Human route wording.
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go for route decision capture
Lane: dual-route approval
Summary: dual-route approval blocks capture because push and PR cannot be bound as one decision.
Basis: P18-EV-003, P18-EV-005, P18-EV-006, P18-EV-016
Recovery Path: select exactly one route or split into separate future decisions.
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go for route decision capture
Lane: stale evidence
Summary: stale evidence blocks capture until HEAD, branch, remote URL, origin/master..HEAD, staged area, working tree, .claude/ exclusion, and Evidence IDs are refreshed.
Basis: P18-EV-003, P18-EV-004, P18-EV-006, P18-EV-011
Recovery Path: rerun evidence refresh and update evidence refs.
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go for route decision capture
Lane: fake route Go
Summary: fake route Go blocks capture when approval is implied by Phase 17 local commit, artifact completeness, candidate text, stale evidence, or chat memory.
Basis: P18-EV-001, P18-EV-003, P18-EV-006, P18-EV-014
Recovery Path: require explicit Human route selection decision with current evidence refs.
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go for route decision capture
Lane: dirty staged files
Summary: dirty staged files block route decision capture because staged payload could diverge from reviewed evidence.
Basis: P18-EV-004, P18-EV-006, P18-EV-011
Recovery Path: clear staged area or explicitly review staged payload.
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go for route decision capture
Lane: missing evidence ref
Summary: missing evidence ref blocks route decision capture because Parent Synthesis and route decision claims must be reconstructable without chat memory.
Basis: P18-EV-004, P18-EV-006, P18-EV-012
Recovery Path: append missing Evidence ID and rerun evidence-first.
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go for route decision capture
Lane: unresolved No-Go
Summary: unresolved No-Go remains binding and blocks any future push route or PR route selection decision.
Basis: P18-EV-006, P18-EV-008, P18-EV-016
Recovery Path: resolve finding or append Human accepted-risk evidence.
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go for route decision capture
Lane: changed HEAD/range/remote
Summary: changed HEAD/range/remote blocks capture because the reviewed route decision scope is stale.
Basis: P18-EV-004, P18-EV-005, P18-EV-006, P18-EV-011
Recovery Path: restart capture with fresh HEAD, range, and remote evidence.
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go for route decision capture
Lane: local-only state in release scope
Summary: local-only state in release scope blocks capture because .claude/ and machine-local files are excluded from route, push, PR, release, and remote-sync scope.
Basis: P18-EV-004, P18-EV-005, P18-EV-006, P18-EV-011
Recovery Path: remove local-only state from release scope and record exclusion evidence.
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: Go for paper decision-capture package completeness
Lane: no remote/network action occurred
Summary: Phase 18 records no real route selection, push, PR, remote command, network remote action, release, stage, or commit, and keeps Human Decision pending.
Basis: P18-EV-001, P18-EV-007, P18-EV-010, P18-EV-011, P18-EV-012
Blocking: none for paper decision-capture package completeness
```

## Synthesis-Comparison Pass

```text
Pass Type: synthesis-comparison
Decision: Go for artifact completeness
Summary: Parent Synthesis uses Child Report and P18-EV-* Evidence IDs for each claim and does not infer route selection from Phase 17 local commit, local status, chat memory, candidate route text, or artifact-completeness Go.
Basis: P18-EV-001, P18-EV-002, P18-EV-003, P18-EV-004, P18-EV-005, P18-EV-006, P18-EV-007, P18-EV-008, P18-EV-009, P18-EV-010, P18-EV-011, P18-EV-012, P18-EV-013, P18-EV-014, P18-EV-015, P18-EV-016
Blocking: none for drill artifact completeness
```

## Overall Gate Result

```text
Decision: Go for paper decision-capture package completeness
Route Selection Decision Accepted: no
Single-Route Binding Accepted: no
Remote-Sync Authorization Allowed: no
push / PR Authorized: no
Release Allowed: no
Reason: The drill defines route selection decision capture and single-route binding without staging, committing, selecting a route, pushing, opening a PR, executing remote commands, performing network remote action, or release.
Conditions: Human Decision remains pending; Selected Route: none; push / PR Authorized: no.
Evidence Gaps: explicit Human route selection decision and remote execution evidence are intentionally absent because Phase 18 is paper-only and remote action is unauthorized.
```

Evaluator No-Go blocks route decision capture. Parent cannot reject or override ambiguous route wording, dual-route approval, stale evidence, fake route Go, dirty staged files, missing evidence ref, unresolved No-Go, changed HEAD/range/remote, or local-only state in release scope.
