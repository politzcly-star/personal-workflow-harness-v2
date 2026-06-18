# Handoff Recovery Record: context handoff rehearsal

## Header

```text
Recovery ID: REC-P7-CONTEXT-HANDOFF-001
Task ID: phase-7-context-handoff-rehearsal
Snapshot Ref: examples/phase-7-context-handoff-rehearsal/context-compression-snapshot.md
Recovered At: 2026-06-18
Recovered By: Resumed Parent
Evidence Ref: P7-EV-005
```

## Reload Order

```text
1. Human-signed North Star: task-instance.md P7-EV-001
2. Task Instance and Evidence Index: task-instance.md P7-EV-001 through P7-EV-008
3. Dispatch Matrix: dispatch-matrix.md P7-EV-002
4. Context Compression Snapshot: context-compression-snapshot.md P7-EV-004
5. Child Report and verification: child-report-context-handoff.md P7-EV-003
6. Evaluator Gate Card: evaluator-gate-card.md P7-EV-006
7. Parent Synthesis: parent-synthesis.md P7-EV-007
8. Human Decision placeholder: human-decision.md P7-EV-008
9. Chat Context: non-authority only
```

## Authority Check

```text
Human-signed North Star present: yes
Task State present: yes
Evaluator Decision present: yes
Snapshot reload paths complete: yes
Child Reports preserved or reloadable: yes
Conditional Go Conditions preserved: yes, none open
child-report: exhausted preserved: yes, none open
Conflicts preserved: yes, none open
Scope Changes preserved: yes, none open
Chat Memory Used As Authority: no
```

## Recovery Decision

```text
Recovery Status: recovered
Blocking Findings: none
If Missing Reload Path: No-Go
If Dropped Unresolved Finding: blocked: authority-conflict or No-Go
Next Action: Evaluator compares pre-handoff evidence with post-resume Parent Synthesis.
```

