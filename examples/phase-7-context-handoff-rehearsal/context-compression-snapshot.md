# Context Compression Snapshot: context handoff rehearsal

## Snapshot Header

```text
Snapshot ID: SNAP-P7-CONTEXT-HANDOFF-001
Task ID: phase-7-context-handoff-rehearsal
North Star Version: v1
Created At: 2026-06-18
Created By: C-P7-CONTEXT-HANDOFF
Trigger: Parent handoff/resume rehearsal with active child report and Evaluator finding.
Mandatory: yes
Evidence Ref: P7-EV-004
```

## Authority State

```text
Human-signed North Star: examples/phase-7-context-handoff-rehearsal/task-instance.md#human-signoff
Task State: review_ready
Dispatch Matrix: examples/phase-7-context-handoff-rehearsal/dispatch-matrix.md
Completed Children: C-P7-CONTEXT-HANDOFF
Active Children: none
Evaluator State: evidence-first and synthesis-comparison complete with Go decision
Human Decision: pending
```

## Preserved Details

```text
Preserved:
- Human-signed North Star
- Task Instance state and Evidence Index P7-EV-001 through P7-EV-008
- Dispatch Matrix with Parent cannot assign itself
- Child Report with verification section and no exhaustion
- Evaluator finding and decision rules
- Parent Synthesis draft path
- Human Decision placeholder
```

## Unresolved Finding Inventory

```text
Unresolved P0/P1: none
Conflicts: none
Scope Changes: none
Evaluator Findings: EVAL-P7-CONTEXT-HANDOFF-001, Go for artifact completeness
Conditional Go Conditions: none
child-report: exhausted: none, reload path retained for the child report field
Authority Conflict: none
```

## Omitted Details With Reload Paths

```text
Omitted Detail: full README diff
Reload path: git diff -- README.md
Reason: README change is navigation-only and reloadable from git diff.

Omitted Detail: full Phase 7 guide text
Reload path: docs/phase-7-context-handoff-guide.md
Reason: guide is stored as a file artifact.

Omitted Detail: child verification command output
Reload path: examples/phase-7-context-handoff-rehearsal/child-report-context-handoff.md#verification
Reason: verification summary is recorded in Child Report.

Omitted Detail: Evaluator pass details
Reload path: examples/phase-7-context-handoff-rehearsal/evaluator-gate-card.md
Reason: Evaluator Gate Card is stored as a file artifact.
```

## Blocking Rule

```text
Missing reload path: No-Go.
Dropped unresolved finding: No-Go, or blocked: authority-conflict if artifacts disagree.
Chat memory substitution: No-Go.
Next Action: resumed Parent must reload artifacts before final synthesis or Human Acceptance Summary.
```

