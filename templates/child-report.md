# Child Report Template

Child Report is the standard output for every Phase 2 child thread.
It is the place where work, evidence, verification, and exhaustion are recorded.

## Header

```text
Child ID:
Role: planner | researcher | generator | evaluator
Task Instance Ref:
Dispatch Matrix Ref:
Goal:
Status: complete | blocked | exhausted | failed
Report Created At:
```

## Scope Used

```text
Allowed Read Used:
Allowed Changes Used:
Forbidden Changes Avoided:
Stop Conditions Checked:
```

## Changed Files

```text
Changed Files:
- Path:
  Change Summary:
  Evidence Ref:
```

Use `Changed Files: none` when no files were changed.

## Evidence

```text
Evidence:
- Evidence ID:
  Type: observation | diff | verification | finding | risk | external-reference
  Summary:
  Reference:
```

Evidence must be concrete enough for the Parent and Evaluator to reload it without chat memory.

## Verification

```text
Verification:
- Command:
  Exit Code:
  Output Summary:
  Evidence Ref:
```

If verification was not run:

```text
Verification Not Run:
Reason:
Risk:
Recommended Follow-up:
```

Child test results must be written here. Parent must not use chat memory as a substitute for verification evidence.

## Findings

```text
Findings:
- Severity: P0 | P1 | P2 | P3 | info
  Summary:
  Evidence Ref:
  Recommended Action:
```

## Exhaustion

```text
Exhaustion Status: none | child-report: exhausted
Exhausted Actions:
Remaining Blocker:
Needed Boundary Change:
Recommended Parent Action:
```

Use `child-report: exhausted` when the child triggers a stop condition or exhausts available actions.

## Open Questions

```text
Open Questions:
- Question:
  Needed From: parent | evaluator | human
  Blocking: yes | no
```
