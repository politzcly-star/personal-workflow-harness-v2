# Evidence Audit Record: evidence integrity drill

## Header

```text
Audit ID: AUDIT-P9-EVIDENCE-INTEGRITY-001
Task Instance Ref: examples/phase-9-evidence-integrity-drill/task-instance.md
Scope Change Ref: examples/phase-9-evidence-integrity-drill/scope-change-record.md
Created At: 2026-06-18
```

## Audit Checks

```text
Check: append-only Evidence Index
Result: pass for drill artifact
Evidence Refs: P9-EV-001, P9-EV-004, P9-EV-009
Rule: old entries are never deleted, rewritten, renumbered, or silently reclassified.
```

```text
Check: duplicate Evidence ID
Result: simulated No-Go lane
Evidence Refs: P9-EV-004, P9-EV-006
Rule: duplicate Evidence ID blocks acceptance until a new correction evidence entry records the conflict and resolution.
```

```text
Check: missing evidence refs
Result: simulated No-Go lane
Evidence Refs: P9-EV-004, P9-EV-006
Rule: claims, conflicts, evaluator findings, human decisions, accepted-risk records, and scope-change records must cite Evidence IDs.
```

```text
Check: overwritten evaluator finding
Result: simulated No-Go lane
Evidence Refs: P9-EV-004, P9-EV-006, P9-EV-009
Rule: overwritten evaluator finding blocks acceptance; Parent may only append dispute or correction evidence.
```

```text
Check: uncited scope-change
Result: simulated No-Go lane
Evidence Refs: P9-EV-005, P9-EV-006
Rule: scope-change must have a new evidence entry and cannot be smuggled into existing scope.
```

## Audit Conflict Lanes

```text
Conflict: duplicate Evidence ID
Required Recovery: append new conflict evidence and evaluator follow-up; do not edit the duplicate old entry.
Blocking State: No-Go
```

```text
Conflict: missing evidence refs
Required Recovery: append correction evidence and update Parent Synthesis claims with cited Evidence IDs.
Blocking State: No-Go
```

```text
Conflict: overwritten evaluator finding
Required Recovery: restore authority through append-only evaluator-finding or conflict evidence; do not overwrite evaluator history.
Blocking State: No-Go
```

```text
Conflict: uncited scope-change
Required Recovery: append scope-change evidence, rerun evaluator evidence-first pass, and wait for Human decision when boundary changes.
Blocking State: blocked: needs-human-decision
```

