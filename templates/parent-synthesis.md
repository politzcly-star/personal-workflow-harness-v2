# Parent Synthesis Template

Parent Synthesis summarizes child work for Human decision.
It must cite evidence refs only; it must not treat chat memory as source truth.

## Header

```text
Synthesis ID:
Task Instance Ref:
North Star Version:
Dispatch Matrix Ref:
Input Child Reports:
Evaluator Gate Card Refs:
Created At:
```

## North Star Alignment

```text
Acceptance Criterion:
Evidence Refs:
Status: satisfied | partially-satisfied | not-satisfied | disputed
Notes:
```

## Child Report Summary

```text
Child ID:
Role:
Status:
Changed Files:
Evidence Refs:
Verification Refs:
Exhaustion: none | child-report: exhausted
```

## Accepted Findings

```text
Finding:
Source Child Report:
Evidence Refs:
Parent Treatment: accepted | escalated | unresolved
```

Parent cannot reject Evaluator findings. Disputes must be recorded as blocked human decisions.

## Conflicts And Scope Changes

```text
Conflicts:
- Conflict ID:
  Evidence Refs:
  Evaluator State:
  Parent Action:

Scope Changes:
- Requested Change:
  Evidence Refs:
  State: blocked: needs-human-decision | approved-by-human
```

Use `blocked: authority-conflict` when authoritative artifacts disagree.

## Evaluator State

```text
Latest Evaluator Pass: evidence-first | synthesis-comparison | conditional-followup
Decision: PENDING | Go | Conditional Go | No-Go
Decision Ref:
Conditions:
Disputes:
```

Evaluator `No-Go` and unresolved `Conditional Go` conditions are blocking.

## Recommended Human Decision

```text
Recommended Decision: accept | reject | request-followup | change-scope | block
Reason:
Evidence Refs:
Remaining Uncertainty:
```

## Evidence Ref Checklist

- Every factual claim has an Evidence ID or report ref.
- Every child verification result is cited from a Child Report.
- No claim depends only on chat memory.
- Evidence Index updates remain append-only.
