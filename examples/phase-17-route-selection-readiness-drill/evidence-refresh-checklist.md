# Evidence Refresh Checklist: route selection readiness drill

## Header

```text
Checklist ID: CHECK-P17-EVIDENCE-REFRESH-001
Task Instance Ref: examples/phase-17-route-selection-readiness-drill/task-instance.md
Route Selection Readiness Record Ref: examples/phase-17-route-selection-readiness-drill/route-selection-readiness-record.md
Created At: 2026-06-19
Checklist State: ready for future evidence refresh
Current Human Decision: pending
push / PR Authorized: no
Remote/Network Action: none
```

## Local Git Evidence Checks

These commands are local evidence checks only. They are not remote commands and do not perform network remote action.

```text
Command: git status --short --branch
Purpose: confirm current branch, tracking state, staged/unstaged/untracked state, and .claude/ local-only exclusion.
Required Before Future Route Decision: yes
Blocks If Missing: stale evidence
```

```text
Command: git remote -v
Purpose: confirm current remote URL from local git config.
Required Before Future Route Decision: yes
Blocks If Missing: stale evidence
```

```text
Command: git branch --show-current
Purpose: confirm current branch name.
Required Before Future Route Decision: yes
Blocks If Missing: stale evidence
```

```text
Command: git log --oneline --decorate origin/master..HEAD
Purpose: confirm current local commit range proposed for future route review.
Required Before Future Route Decision: yes
Blocks If Missing: stale evidence
```

```text
Command: git ls-files --modified --others --exclude-standard
Purpose: confirm current working tree paths and local-only .claude/ exclusion.
Required Before Future Route Decision: yes
Blocks If Unreviewed: stale evidence
```

```text
Command: git diff --cached --name-only
Purpose: confirm staged area is clean or explicitly reviewed.
Required Before Future Route Decision: yes
Blocks If Dirty: dirty staged files
```

```text
Command: git diff --check
Purpose: detect whitespace problems in the reviewed markdown scope.
Required Before Future Route Decision: yes
Blocks If Failing: stale evidence
```

## Artifact Evidence Checks

```text
Check: keyword search
Terms: route selection readiness; evidence refresh; push / PR Authorized: no; ambiguous push-vs-PR; fake route Go; authorization expires; dirty staged files; missing evidence ref; unresolved No-Go; local-only state; evidence-first; synthesis-comparison
Purpose: confirm required route-readiness and evaluator language is present.
Blocks If Missing: missing evidence ref
```

```text
Check: README link target check
Purpose: confirm Phase 17 README navigation links resolve to repository files.
Blocks If Missing: stale evidence
```

```text
Check: Parent Synthesis citation check
Purpose: confirm every Parent claim cites only Child Report or P17-EV-* Evidence IDs.
Blocks If Failing: missing evidence ref
```

```text
Check: P17-EV-* uniqueness check
Purpose: confirm Evidence Index IDs are unique and append-only style.
Blocks If Duplicate: missing evidence ref
```

```text
Check: scope check
Purpose: confirm changed files are limited to allowed Phase 17 files plus existing .claude/settings.local.json local-only state.
Blocks If Unexpected: stale evidence
```

## Future Human Route Review Checklist

```text
Review Item: Phase 16 boundary
Required Result: Phase 16 local commit does not authorize push/PR or select a route.
Evidence Refs: P17-EV-003, P17-EV-014
```

```text
Review Item: route wording
Required Result: exactly one of push route or PR route, unless Human explicitly splits them into separate decisions.
Evidence Refs: P17-EV-003, P17-EV-004, P17-EV-009
```

```text
Review Item: authorization expires
Required Result: route decision expires if HEAD, branch, remote URL, staged area, working tree, evidence refs, or route wording changes after review.
Evidence Refs: P17-EV-003, P17-EV-012
```

```text
Review Item: blockers
Required Result: missing route selection, stale evidence, ambiguous push-vs-PR wording, fake route Go, dirty staged files, missing evidence ref, unresolved No-Go, and local-only state in release scope block route selection.
Evidence Refs: P17-EV-004, P17-EV-007
```

```text
Review Item: Human Decision
Required Result: Human Decision remains pending; push / PR Authorized: no; no remote/network action occurred.
Evidence Refs: P17-EV-009, P17-EV-010, P17-EV-011
```
