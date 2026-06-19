# Execution Authorization Checklist: route-specific execution authorization drill

## Checklist Purpose

This checklist blocks execution authorization when route selection, command text, evidence, scope, evaluator state, or Human wording cannot safely bind to one route-specific execution request.

```text
Current Drill Route Decision: none
Selected Route: none
Execution Authorized: no
push / PR Authorized: no
Remote Action Executed: no
```

## Blocking Lanes

```text
Lane: missing route selection
Check: no separate valid Human route selection record exists.
Decision: block execution authorization
Recovery: capture a separate route selection decision before asking for execution authorization.
```

```text
Lane: ambiguous route
Check: route evidence names both push and PR, no route, conditional route, implied route, or unclear route preference.
Decision: block execution authorization
Recovery: require exact Human route wording naming push or PR before execution authorization.
```

```text
Lane: fake execution Go
Check: approval is inferred from Phase 18 local commit, artifact completeness, route selection, candidate command text, chat memory, local status, ahead count, or stale baseline closure.
Decision: block execution authorization
Recovery: require separate explicit Human execution Go with current evidence refs and exact command text.
```

```text
Lane: command drift
Check: candidate command text changed after evidence review or includes unreviewed flags, branch names, shell chaining, scripts, remote shell, or route-mismatched commands.
Decision: block execution authorization
Recovery: regenerate candidate command isolation record and rerun evidence-first.
```

```text
Lane: stale evidence
Check: HEAD, branch, remote URL, origin/master..HEAD, staged area, working tree, release files, local-only exclusion, evaluator state, or Evidence IDs are older than the execution authorization request.
Decision: block execution authorization
Recovery: rerun evidence refresh and append current evidence refs.
```

```text
Lane: dirty staged files
Check: git diff --cached --name-only is non-empty and staged payload is not explicitly reviewed with evidence.
Decision: block execution authorization
Recovery: clear staged area or review staged payload with evidence.
```

```text
Lane: unexpected release files
Check: files outside the reviewed release scope appear in the candidate push, PR, release, or remote-sync execution payload.
Decision: block execution authorization
Recovery: remove unexpected files or append explicit evidence and Human accepted-risk decision.
```

```text
Lane: missing evidence ref
Check: route, command, Parent Synthesis, checklist, or blocker recovery claim lacks Child Report or P19-EV-* evidence.
Decision: block execution authorization
Recovery: append evidence and rerun evidence-first.
```

```text
Lane: unresolved No-Go
Check: evaluator No-Go remains unresolved for route-specific execution authorization.
Decision: block execution authorization
Recovery: resolve finding or append explicit Human accepted-risk evidence before any execution Human Go.
```

```text
Lane: local-only state in release scope
Check: .claude/ or another local-only file is included in route, push, PR, release, or remote-sync execution scope.
Decision: block execution authorization
Recovery: exclude local-only state and record exclusion evidence.
```

## Current Checklist Result

```text
Execution Authorization: blocked for real execution
Paper Drill Completeness: ready for parent read-only review
Selected Route: none
Execution Authorized: no
push / PR Authorized: no
No Remote/Network Action Occurred: yes
```
