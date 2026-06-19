# Evaluator Gate Card: remote-sync decision drill

## Header

```text
Gate Card ID: EVAL-P12-REMOTE-SYNC-DECISION-001
Evaluator ID: EVAL-P12-REMOTE-SYNC-DECISION
Task Instance Ref: examples/phase-12-remote-sync-decision-drill/task-instance.md
Pass Types: evidence-first, synthesis-comparison, authorization-followup
Created At: 2026-06-19
```

## Inputs

```text
Input Artifacts:
- Human-signed North Star: task-instance.md P12-EV-001
- Dispatch Matrix: P12-EV-002
- Child Report: P12-EV-003
- Remote-Sync Decision Request: P12-EV-004, P12-EV-008, P12-EV-009
- Parent Synthesis: read only during synthesis-comparison
- Human Decision Placeholder: P12-EV-007
- Evidence Index: P12-EV-001 through P12-EV-009
```

## Evidence-First Pass

```text
Pass Type: evidence-first
Decision: No-Go
Lane: changed commit range
Summary: changed commit range causes authorization expires because Human Go would no longer match reviewed evidence.
Basis: P12-EV-004, P12-EV-005, P12-EV-008
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go
Lane: dirty staged files
Summary: dirty staged files block acceptance because remote-sync payload cannot be trusted.
Basis: P12-EV-004, P12-EV-005
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go
Lane: .claude in release scope
Summary: .claude/ in remote-sync scope blocks acceptance because local-only state must never be pushed.
Basis: P12-EV-004, P12-EV-005, P12-EV-008
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go
Lane: unexpected release files
Summary: unexpected release files block acceptance until classified and reviewed.
Basis: P12-EV-004, P12-EV-005
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go
Lane: missing evidence refs
Summary: missing evidence refs block acceptance because the remote-sync decision cannot be audited from artifacts.
Basis: P12-EV-004, P12-EV-005
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go
Lane: unreviewed scope change
Summary: unreviewed scope change blocks acceptance until new scope evidence and Human decision exist.
Basis: P12-EV-004, P12-EV-005, P12-EV-008
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go
Lane: fake remote approval
Summary: fake remote approval blocks acceptance because remote-sync requires separate explicit Human Go.
Basis: P12-EV-007, P12-EV-008
Blocking: yes
```

## Synthesis-Comparison Pass

```text
Pass Type: synthesis-comparison
Decision: Go for drill completeness
Summary: Parent Synthesis reconstructs Phase 12 remote-sync decision readiness and authorization expiry from P12 Evidence IDs and does not rely on chat memory.
Basis: P12-EV-001, P12-EV-002, P12-EV-003, P12-EV-004, P12-EV-005, P12-EV-006, P12-EV-007, P12-EV-008, P12-EV-009
Blocking: none for drill completeness
```

## Overall Gate Result

```text
Decision: Go for artifact completeness
Accepted Task State Allowed: no until Human Decision
Remote Action Allowed: no
Reason: The drill demonstrates remote-sync authorization expiry and separate Human Go requirements without performing push or PR.
Conditions: Future remote-sync requires separate Human Go with evidence ref, unchanged commit range, clean status, and complete evidence refs.
Evidence Gaps: none for the drill artifact
```

Evaluator `No-Go` blocks remote-sync decision lanes. Parent cannot reject or override it. A future push or PR requires separate Human Go and current cited evidence.
