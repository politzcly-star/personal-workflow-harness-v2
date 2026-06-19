# Evaluator Gate Card: baseline closure drill

## Header

```text
Gate Card ID: EVAL-P15-BASELINE-CLOSURE-001
Evaluator ID: EVAL-P15-BASELINE-CLOSURE
Task Instance Ref: examples/phase-15-baseline-closure-drill/task-instance.md
Pass Types: evidence-first, synthesis-comparison
Created At: 2026-06-19
```

## Inputs

```text
Input Artifacts:
- Human-signed North Star: task-instance.md P15-EV-001
- Dispatch Matrix: P15-EV-002
- Child Report: P15-EV-003, P15-EV-011
- Baseline Closure Record: P15-EV-004, P15-EV-010, P15-EV-012
- End-to-End Evidence Map: P15-EV-005, P15-EV-009
- Parent Synthesis: read only during synthesis-comparison
- Human Decision Placeholder: P15-EV-008
- README Navigation: P15-EV-013
- Evidence Index: P15-EV-001 through P15-EV-013
```

## Evidence-First Pass

```text
Pass Type: evidence-first
Decision: No-Go
Lane: missing phase artifact
Summary: missing phase artifact blocks baseline closure because Phase 1-14 reconstruction would be incomplete.
Basis: P15-EV-004, P15-EV-005, P15-EV-009, P15-EV-012
Recovery Path: restore or document the missing artifact from repository history and append an Evidence Index entry.
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go
Lane: missing evidence ref
Summary: missing evidence ref blocks closure because Parent Synthesis cannot rely on chat memory or uncited summaries.
Basis: P15-EV-003, P15-EV-006, P15-EV-007, P15-EV-012
Recovery Path: append a P15 Evidence Index entry and rerun evidence-first review.
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go
Lane: unresolved No-Go
Summary: unresolved No-Go remains binding and blocks baseline closure.
Basis: P15-EV-006, P15-EV-012
Recovery Path: resolve the evaluator finding or append a Human accepted-risk record.
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go
Lane: dirty staged files
Summary: dirty staged files block baseline closure because staged payload could diverge from reviewed artifacts.
Basis: P15-EV-003, P15-EV-011, P15-EV-012
Recovery Path: clear staged files or explicitly review staged payload with evidence.
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go
Lane: branch/remote mismatch
Summary: branch/remote mismatch invalidates the recorded origin/master..HEAD baseline.
Basis: P15-EV-004, P15-EV-009, P15-EV-011, P15-EV-012
Recovery Path: refresh branch, remote URL, and commit range evidence before closure.
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go
Lane: fake closeout
Summary: fake closeout blocks closure when acceptance is claimed without Child Report or P15 Evidence ID citations.
Basis: P15-EV-003, P15-EV-006, P15-EV-007, P15-EV-012
Recovery Path: replace the closeout with cited evidence and rerun synthesis-comparison.
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go
Lane: local-only state in release scope
Summary: local-only state in release scope blocks closure and any future release path.
Basis: P15-EV-010, P15-EV-011, P15-EV-012
Recovery Path: remove local-only state from release scope and record exclusion evidence.
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go
Lane: unauthorized remote action
Summary: remote action unauthorized; Phase 15 cannot push, open PRs, execute remote commands, or perform network remote actions.
Basis: P15-EV-001, P15-EV-008, P15-EV-012
Recovery Path: stop and request a separate Human decision outside Phase 15.
Blocking: yes
```

## Synthesis-Comparison Pass

```text
Pass Type: synthesis-comparison
Decision: Go for artifact completeness
Summary: Parent Synthesis reconstructs Phase 15 baseline closure state from Child Report and P15 Evidence IDs and does not rely on chat memory.
Basis: P15-EV-001, P15-EV-002, P15-EV-003, P15-EV-004, P15-EV-005, P15-EV-006, P15-EV-007, P15-EV-008, P15-EV-009, P15-EV-010, P15-EV-011, P15-EV-012, P15-EV-013
Blocking: none for drill artifact completeness
```

## Overall Gate Result

```text
Decision: Go for artifact completeness
Accepted Task State Allowed: no until Human Decision
Baseline Closure Acceptance Allowed: no until Human Decision
Remote Action Allowed: no
Reason: The drill demonstrates local baseline closure reconstruction and blocker lanes without staging, committing, pushing, opening a PR, executing remote commands, or performing network remote action.
Conditions: Human Decision remains pending; push / PR Authorized: no; remote action unauthorized.
Evidence Gaps: none for drill artifact completeness; remote execution evidence is intentionally absent because remote action is unauthorized.
```

Evaluator `No-Go` blocks baseline closure lanes. Parent cannot reject or override it. A future stage, commit, push, PR, remote command, network remote action, or closure acceptance requires separate Human Go and current cited evidence.
