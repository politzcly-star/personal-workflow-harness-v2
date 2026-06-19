# Abort Trigger Checklist: execution denial / abort and recovery drill

## Abort Trigger Matrix

Each abort trigger blocks execution and records `Execution Authorized: no` and `push / PR Authorized: no`.

```text
Trigger: Human No-Go
Result: abort before execution
Recovery: return to recovery decision matrix; require new decision path only if Human later changes decision explicitly.
```

```text
Trigger: expired authorization
Result: abort before execution
Recovery: refresh evidence and rerun evaluator evidence-first and synthesis-comparison before requesting a new explicit Human Go.
```

```text
Trigger: ambiguous abort wording
Result: abort before execution
Recovery: clarify Human intent; treat ambiguous stop, hold, wait, pause, or abort wording as No-Go until clarified.
```

```text
Trigger: stale approval
Result: abort before execution
Recovery: discard stale approval and request a new explicit Human Go only after refreshed evidence and evaluator passes.
```

```text
Trigger: silence
Result: abort before execution
Recovery: wait for explicit Human decision; silence is not consent.
```

```text
Trigger: chat-only approval
Result: abort before execution
Recovery: require artifact-backed Human Go with current evidence refs.
```

```text
Trigger: changed HEAD/range/remote
Result: abort before execution
Recovery: refresh HEAD, branch, remote URL, and origin/master..HEAD evidence; rerun evaluator passes.
```

```text
Trigger: dirty staged files
Result: abort before execution
Recovery: clear staged area or capture staged payload in reviewed evidence before requesting Human Go.
```

```text
Trigger: unexpected release files
Result: abort before execution
Recovery: remove unexpected files from release scope or record explicit accepted-risk decision with evidence before any future execution request.
```

```text
Trigger: missing evidence ref
Result: abort before execution
Recovery: append missing P21-EV-* evidence and rerun evidence-first.
```

```text
Trigger: unresolved No-Go
Result: abort before execution
Recovery: resolve evaluator No-Go; Parent cannot override it.
```

```text
Trigger: local-only state in release scope
Result: abort before execution
Recovery: exclude .claude/ and other local-only state from push, PR, release, and remote-sync execution scope.
```
