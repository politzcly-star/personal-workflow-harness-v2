# Recovery Decision Matrix: execution denial / abort and recovery drill

## Recovery Boundary

```text
Recovery Decision State: pending
Execution Authorized: no
push / PR Authorized: no
Remote Action Authorized: no
Remote Action Executed: no
Human Decision: pending
```

Recovery is a new decision path, not a continuation of stale approval.

## Parent Non-Conversion Rule

Parent cannot convert any of the following into execution permission:

```text
rejection
silence
stale approval
local commit
ahead count
candidate command text
chat-only wording
artifact completeness
```

## Recovery Path

```text
Step: stop execution
Required Evidence: execution-denial-record.md
Result Until Complete: Execution Authorized: no
```

```text
Step: refresh evidence
Required Evidence: current HEAD, branch, remote URL, origin/master..HEAD, staged area, working tree, release scope, local-only exclusion, Evidence ID uniqueness
Result Until Complete: Execution Authorized: no
```

```text
Step: rerun evaluator evidence-first
Required Evidence: evaluator-gate-card.md evidence-first pass after refresh
Result Until Complete: Execution Authorized: no
```

```text
Step: rerun evaluator synthesis-comparison
Required Evidence: evaluator-gate-card.md synthesis-comparison pass after Parent Synthesis
Result Until Complete: Execution Authorized: no
```

```text
Step: require new explicit Human Go
Required Evidence: human-decision.md updated by Human with current evidence refs
Result Until Complete: Execution Authorized: no; push / PR Authorized: no
```

## Recovery Outcomes

```text
Outcome: Human No-Go persists
Control Result: remain blocked
Execution Authorized: no
```

```text
Outcome: evidence drift remains unresolved
Control Result: remain blocked
Execution Authorized: no
```

```text
Outcome: new explicit Human Go missing
Control Result: remain blocked
Execution Authorized: no
```

```text
Outcome: refreshed evidence, evaluator passes, and new explicit Human Go all present
Control Result: future parent may request separate execution handling under the then-current task boundary
Execution Authorized: not granted by Phase 21 artifact alone
```
