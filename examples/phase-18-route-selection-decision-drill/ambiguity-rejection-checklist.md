# Ambiguity Rejection Checklist: route selection decision drill

## Checklist Purpose

This checklist blocks route selection decision capture when Human wording, evidence, scope, or evaluator state cannot bind exactly one route.

```text
Current Drill Route Decision: none
Selected Route: none
push / PR Authorized: no
Remote Action Executed: no
```

## Blocking Lanes

```text
Lane: ambiguous route wording
Check: wording names no route, both routes, conditional route, implied route, or an unclear push-vs-PR preference.
Decision: block route decision capture
Recovery: require exact Human wording naming push or PR.
```

```text
Lane: dual-route approval
Check: wording approves push and PR together or grants whichever route the agent prefers.
Decision: block route decision capture
Recovery: select exactly one route or split into separate future decisions.
```

```text
Lane: stale evidence
Check: HEAD, branch, remote URL, origin/master..HEAD, staged area, working tree, local-only exclusion, or Evidence IDs are older than the route decision request.
Decision: block route decision capture
Recovery: rerun evidence refresh and append current evidence refs.
```

```text
Lane: fake route Go
Check: approval is inferred from Phase 17 local commit, artifact completeness, candidate command text, chat memory, local status, ahead count, or stale baseline closure.
Decision: block route decision capture
Recovery: require explicit Human route selection decision with current evidence refs.
```

```text
Lane: missing evidence ref
Check: a route decision claim, Parent Synthesis claim, or blocker recovery claim lacks Child Report or P18-EV-* evidence.
Decision: block route decision capture
Recovery: append evidence and rerun evidence-first.
```

```text
Lane: dirty staged files
Check: git diff --cached --name-only is non-empty and staged payload is not explicitly reviewed with evidence.
Decision: block route decision capture
Recovery: clear staged area or review staged payload with evidence.
```

```text
Lane: unresolved No-Go
Check: evaluator No-Go remains unresolved for route selection decision capture.
Decision: block route decision capture
Recovery: resolve finding or append explicit Human accepted-risk evidence.
```

```text
Lane: changed HEAD/range/remote
Check: HEAD, origin/master..HEAD, or origin URL changed after evidence capture.
Decision: block route decision capture
Recovery: restart capture with fresh git and remote evidence.
```

```text
Lane: local-only state in release scope
Check: .claude/ or another local-only file is included in route, push, PR, release, or remote-sync scope.
Decision: block route decision capture
Recovery: exclude local-only state and record exclusion evidence.
```

## Current Checklist Result

```text
Route Selection Decision Capture: blocked for real route selection
Paper Drill Completeness: ready for parent read-only review
Selected Route: none
push / PR Authorized: no
No Remote/Network Action Occurred: yes
```
