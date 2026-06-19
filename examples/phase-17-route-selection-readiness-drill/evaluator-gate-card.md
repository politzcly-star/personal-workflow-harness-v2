# Evaluator Gate Card: route selection readiness drill

## Header

```text
Gate Card ID: EVAL-P17-ROUTE-SELECTION-READINESS-001
Evaluator ID: EVAL-P17-ROUTE-SELECTION-READINESS
Task Instance Ref: examples/phase-17-route-selection-readiness-drill/task-instance.md
Pass Types: evidence-first, synthesis-comparison
Created At: 2026-06-19
```

## Inputs

```text
Input Artifacts:
- Human-signed North Star: P17-EV-001
- Dispatch Matrix: P17-EV-002
- Phase 17 Guide: P17-EV-003
- Route Selection Readiness Record: P17-EV-004, P17-EV-012, P17-EV-014
- Evidence Refresh Checklist: P17-EV-005
- Child Report: P17-EV-006, P17-EV-010, P17-EV-011
- Parent Synthesis: read only during synthesis-comparison, P17-EV-008
- Human Decision Placeholder: P17-EV-009
- README Navigation: P17-EV-013
- Evidence Index: P17-EV-001 through P17-EV-014
```

## Evidence-First Pass

```text
Pass Type: evidence-first
Decision: No-Go for route selection
Lane: missing route selection
Summary: missing route selection blocks route selection because push and PR are mutually exclusive candidate routes and neither has been selected by Human.
Basis: P17-EV-003, P17-EV-004, P17-EV-009
Recovery Path: request explicit Human route selection with current evidence refs.
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go for route selection
Lane: stale evidence
Summary: stale evidence blocks route selection until HEAD, branch, remote URL, origin/master..HEAD, staged area, working tree, .claude/ exclusion, and Evidence IDs are refreshed.
Basis: P17-EV-003, P17-EV-004, P17-EV-005, P17-EV-012
Recovery Path: rerun evidence refresh and update evidence refs.
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go for route selection
Lane: ambiguous push-vs-PR wording
Summary: ambiguous push-vs-PR wording blocks route selection unless Human explicitly splits push and PR into separate decisions.
Basis: P17-EV-003, P17-EV-004, P17-EV-009
Recovery Path: require exact route wording.
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go for route selection
Lane: fake route Go
Summary: fake route Go blocks route selection when approval is implied by a local commit, artifact completeness, candidate text, stale evidence, or chat memory.
Basis: P17-EV-001, P17-EV-003, P17-EV-004, P17-EV-014
Recovery Path: require explicit Human route selection with current evidence refs.
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go for route selection
Lane: dirty staged files
Summary: dirty staged files block route selection because staged payload could diverge from reviewed evidence.
Basis: P17-EV-004, P17-EV-005, P17-EV-010
Recovery Path: clear staged area or explicitly review staged payload.
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go for route selection
Lane: missing evidence ref
Summary: missing evidence ref blocks route selection because Parent Synthesis and route readiness claims must be reconstructable without chat memory.
Basis: P17-EV-005, P17-EV-006, P17-EV-011
Recovery Path: append missing Evidence ID and rerun evidence-first.
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go for route selection
Lane: unresolved No-Go
Summary: unresolved No-Go remains binding and blocks any future push route or PR route selection.
Basis: P17-EV-007, P17-EV-012
Recovery Path: resolve finding or append Human accepted-risk evidence.
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go for route selection
Lane: local-only state in release scope
Summary: local-only state in release scope blocks route selection because .claude/ and machine-local files are excluded from route, push, PR, release, and remote-sync scope.
Basis: P17-EV-004, P17-EV-005, P17-EV-010
Recovery Path: remove local-only state from release scope and record exclusion evidence.
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: Go for paper readiness package completeness
Lane: no remote/network action occurred
Summary: Phase 17 records no route selection, push, PR, remote command, network remote action, release, stage, or commit, and keeps Human Decision pending.
Basis: P17-EV-001, P17-EV-006, P17-EV-009, P17-EV-010, P17-EV-011
Blocking: none for paper readiness package completeness
```

## Synthesis-Comparison Pass

```text
Pass Type: synthesis-comparison
Decision: Go for artifact completeness
Summary: Parent Synthesis uses Child Report and P17-EV-* Evidence IDs for each claim and does not infer route selection from Phase 16 local commit, local status, chat memory, candidate route text, or artifact-completeness Go.
Basis: P17-EV-001, P17-EV-002, P17-EV-003, P17-EV-004, P17-EV-005, P17-EV-006, P17-EV-007, P17-EV-008, P17-EV-009, P17-EV-010, P17-EV-011, P17-EV-012, P17-EV-013, P17-EV-014
Blocking: none for drill artifact completeness
```

## Overall Gate Result

```text
Decision: Go for paper readiness package completeness
Route Selection Accepted: no
Remote-Sync Authorization Allowed: no
push / PR Authorized: no
Release Allowed: no
Reason: The drill prepares a route selection readiness and evidence refresh package without staging, committing, selecting a route, pushing, opening a PR, executing remote commands, performing network remote action, or release.
Conditions: Human Decision remains pending; selected route is none; push / PR Authorized: no.
Evidence Gaps: explicit Human route selection and remote execution evidence are intentionally absent because Phase 17 is paper-only and remote action is unauthorized.
```

Evaluator No-Go blocks route selection. Parent cannot reject or override missing route selection, stale evidence, ambiguous push-vs-PR wording, fake route Go, dirty staged files, missing evidence ref, unresolved No-Go, or local-only state in release scope.
