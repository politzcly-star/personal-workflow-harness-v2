# Evaluator Gate Card Template

Evaluator Gate Card records review decisions for the v2 control plane.
Supported pass types are `evidence-first`, `synthesis-comparison`, and `conditional-followup`.

## Header

```text
Gate Card ID:
Evaluator ID:
Task Instance Ref:
North Star Version:
Pass Type: evidence-first | synthesis-comparison | conditional-followup
Created At:
```

## Inputs

```text
Input Artifacts:
- Human-signed North Star:
- Task Instance:
- Dispatch Matrix:
- Child Reports:
- Verification Outputs:
- Diff / Changed Files:
- Evidence Index:
- Parent Synthesis: only for synthesis-comparison or conditional-followup
```

Rules:

- `evidence-first` must review source artifacts before Parent Synthesis.
- `synthesis-comparison` treats Parent Synthesis as a parent claim, not source truth.
- `conditional-followup` checks only listed Conditional Go conditions.

## Decision

```text
Decision: Go | Conditional Go | No-Go
Summary:
Blocking:
```

Evaluator `No-Go` blocks the task. Parent cannot reject or override it.

## Findings

```text
Findings:
- Severity: P0 | P1 | P2 | P3 | info
  Summary:
  Evidence Refs:
  Required Action:
```

## Evidence Gaps

```text
Evidence Gaps:
- Missing Evidence:
  Why It Matters:
  Required Follow-up:
```

## Conditional Go Conditions

```text
Conditions:
- Condition:
  Required Evidence:
  Follow-up Pass Required: yes | no
  Status: open | satisfied | failed
```

`Conditional Go` must trigger a second lightweight Evaluator pass before acceptance.

## Synthesis Comparison

Use only when `Pass Type` is `synthesis-comparison`.

```text
Parent Claim:
Evidence Refs Cited:
Matches Evidence: yes | no | partial
Evaluator Note:
```

## Append-Only Evidence Updates

```text
Evidence Updates To Append:
- Evidence ID:
  New Status:
  Reason:
```

Evidence Index is append-only. Gate Cards can request appended updates, not rewrites.
