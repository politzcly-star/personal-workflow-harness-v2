# Authorization Expiry Checklist: execution Human Go capture drill

This checklist proves future execution authorization expires if any reviewed binding changes after review.

## Expiry Lanes

```text
Lane: route
Expires If: selected route changes, becomes ambiguous, or is inferred from memory
Decision: block execution capture
```

```text
Lane: command text
Expires If: command text changes by any character, flag, option, branch, title, body, shell wrapper, or route-specific argument
Decision: block execution capture
```

```text
Lane: HEAD
Expires If: HEAD differs from reviewed evidence
Decision: block execution capture
```

```text
Lane: branch
Expires If: current branch differs from reviewed evidence
Decision: block execution capture
```

```text
Lane: remote URL
Expires If: origin fetch or push URL differs from reviewed evidence
Decision: block execution capture
```

```text
Lane: commit range
Expires If: origin/master..HEAD differs from reviewed evidence
Decision: block execution capture
```

```text
Lane: staged area
Expires If: git diff --cached --name-only returns any path not reviewed in evidence
Decision: block execution capture
```

```text
Lane: working tree
Expires If: changed or untracked release-relevant files differ from reviewed evidence
Decision: block execution capture
```

```text
Lane: release scope
Expires If: unexpected release files appear or local-only state enters release scope
Decision: block execution capture
```

```text
Lane: evidence refs
Expires If: any required evidence ref is missing, stale, duplicated, renumbered, or contradicted
Decision: block execution capture
```

```text
Lane: evaluator decision
Expires If: evaluator decision changes, remains No-Go, or is not cited
Decision: block execution capture
```

```text
Lane: Human wording
Expires If: Human wording changes, becomes conditional, omits exact command text, omits selected route, or is inferred from chat memory
Decision: block execution capture
```

## Blocker Matrix

```text
missing execution Go: blocks execution capture
ambiguous command wording: blocks execution capture
fake execution Go: blocks execution capture
command drift: blocks execution capture
stale evidence: blocks execution capture
dirty staged files: blocks execution capture
unexpected release files: blocks execution capture
missing evidence ref: blocks execution capture
unresolved No-Go: blocks execution capture
local-only state: blocks execution capture
```
