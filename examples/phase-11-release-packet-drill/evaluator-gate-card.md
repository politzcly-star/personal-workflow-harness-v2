# Evaluator Gate Card: release packet drill

## Header

```text
Gate Card ID: EVAL-P11-RELEASE-PACKET-001
Evaluator ID: EVAL-P11-RELEASE-PACKET
Task Instance Ref: examples/phase-11-release-packet-drill/task-instance.md
Pass Types: evidence-first, synthesis-comparison, release-followup
Created At: 2026-06-19
```

## Inputs

```text
Input Artifacts:
- Human-signed North Star: task-instance.md P11-EV-001
- Dispatch Matrix: P11-EV-002
- Child Report: P11-EV-003
- Release Packet: P11-EV-004, P11-EV-008, P11-EV-009
- Parent Synthesis: read only during synthesis-comparison
- Human Decision Placeholder: P11-EV-007
- Evidence Index: P11-EV-001 through P11-EV-009
```

## Evidence-First Pass

```text
Pass Type: evidence-first
Decision: No-Go
Lane: missing commit range
Summary: missing commit range blocks acceptance because the release packet cannot define its payload.
Basis: P11-EV-004, P11-EV-005
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go
Lane: missing evidence refs
Summary: missing evidence refs blocks acceptance because Parent Synthesis cannot be audited from artifacts.
Basis: P11-EV-004, P11-EV-005
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go
Lane: dirty staged files
Summary: dirty staged files block acceptance because release payload cannot be trusted.
Basis: P11-EV-004, P11-EV-005
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go
Lane: unreviewed scope change
Summary: unreviewed scope change blocks acceptance until new scope evidence and Human decision exist.
Basis: P11-EV-004, P11-EV-005, P11-EV-008
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go
Lane: fake remote approval
Summary: fake remote approval blocks acceptance because remote-sync requires separate explicit Human Go.
Basis: P11-EV-007, P11-EV-008
Blocking: yes
```

```text
Pass Type: evidence-first
Decision: No-Go
Lane: unexpected release files
Summary: unexpected release files block acceptance until classified and either removed or accepted through evidence-backed scope change.
Basis: P11-EV-004, P11-EV-005
Blocking: yes
```

## Synthesis-Comparison Pass

```text
Pass Type: synthesis-comparison
Decision: Go for drill completeness
Summary: Parent Synthesis reconstructs Phase 11 release packet readiness from P11 Evidence IDs and does not rely on chat memory.
Basis: P11-EV-001, P11-EV-002, P11-EV-003, P11-EV-004, P11-EV-005, P11-EV-006, P11-EV-007, P11-EV-008, P11-EV-009
Blocking: none for drill completeness
```

## Overall Gate Result

```text
Decision: Go for artifact completeness
Accepted Task State Allowed: no until Human Decision
Release Action Allowed: no
Reason: The drill demonstrates release packet blockers and remote-sync authorization separation without performing push or PR.
Conditions: Future remote-sync requires separate Human Go with evidence ref and clean release packet.
Evidence Gaps: none for the drill artifact
```

Evaluator `No-Go` blocks release packet lanes. Parent cannot reject or override it. A future push or PR requires separate Human Go and cited release evidence.
