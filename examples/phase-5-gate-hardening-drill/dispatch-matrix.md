# Dispatch Matrix: gate hardening drill

## Parent Boundary

```text
Parent Responsibilities:
- Assign negative-path child lanes.
- Preserve child evidence and evaluator findings.
- Synthesize only from child reports and Evidence IDs.

Parent Forbidden:
- Parent cannot assign itself.
- Parent cannot assign itself as generator or evaluator.
- Parent cannot reject Evaluator No-Go.
- Parent cannot re-dispatch an exhausted child goal unchanged.
- Parent cannot accept unresolved Conditional Go or authority conflict lanes.
```

## Child Ownership Rows

```text
Child ID: C-P5-CONDITIONAL
Role: generator
Goal: Record a Conditional Go lane and the narrow follow-up evidence.
Allowed Changes: examples/phase-5-gate-hardening-drill/child-report-conditional-followup.md
Stop Conditions: missing follow-up evidence; scope expansion; evaluator condition unclear
Report Path: examples/phase-5-gate-hardening-drill/child-report-conditional-followup.md
Exhaustion Output: child-report: exhausted
```

```text
Child ID: C-P5-NOGO
Role: generator
Goal: Record a No-Go lane where required evidence is missing.
Allowed Changes: examples/phase-5-gate-hardening-drill/child-report-no-go.md
Stop Conditions: evidence becomes sufficient; lane no longer demonstrates No-Go
Report Path: examples/phase-5-gate-hardening-drill/child-report-no-go.md
Exhaustion Output: child-report: exhausted
```

```text
Child ID: C-P5-CONFLICT
Role: generator
Goal: Record an authority conflict lane.
Allowed Changes: examples/phase-5-gate-hardening-drill/child-report-authority-conflict.md
Stop Conditions: conflict cannot be expressed without changing signed scope
Report Path: examples/phase-5-gate-hardening-drill/child-report-authority-conflict.md
Exhaustion Output: child-report: exhausted
```

```text
Child ID: C-P5-EXHAUSTED
Role: generator
Goal: Record child exhaustion and parent response.
Allowed Changes: examples/phase-5-gate-hardening-drill/child-report-exhausted.md
Stop Conditions: child has no allowed evidence path
Report Path: examples/phase-5-gate-hardening-drill/child-report-exhausted.md
Exhaustion Output: child-report: exhausted
```

## Evaluator Assignment

```text
Evaluator ID: EVAL-P5-GATE-HARDENING
Passes: evidence-first, synthesis-comparison, conditional-followup
Allowed Read: Task Instance, Dispatch Matrix, all child reports, verification summaries, Evidence Index, Parent Synthesis after evidence-first
Decision Set: Go, Conditional Go, No-Go
Blocking Rule: No-Go and unresolved Conditional Go prevent accepted.
Conflict Rule: Authority disagreement becomes blocked: authority-conflict.
```
