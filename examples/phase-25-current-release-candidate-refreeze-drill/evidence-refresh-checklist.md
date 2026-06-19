# Evidence Refresh Checklist

## Required Current Inputs

```text
Current HEAD: 32e8c207783b46c67ac32693748bdb3694a3960a
Current Branch: master
Current Remote URL: https://github.com/politzcly-star/personal-workflow-harness-v2.git
Current Commit Range: origin/master..HEAD
Current Staged Area: clean
Working Tree Allowlist: README.md Phase 25 navigation; docs/phase-25-current-release-candidate-refreeze-guide.md; examples/phase-25-current-release-candidate-refreeze-drill/*.md
Excluded Local State: .claude/ and .claude/settings.local.json
Human Decision: pending
Execution Authorized: no
push / PR Authorized: no
Remote Action Authorized: no
Remote Execution Authorized: no
Remote Action Executed: no
Release Authorized: no
```

## Snapshot Invalidation Checks

```text
Check: later change to HEAD
Decision: invalidates the refreshed evidence snapshot
Evidence Required: git rev-parse HEAD compared to 32e8c207783b46c67ac32693748bdb3694a3960a
Recovery: create a new refreshed snapshot before any future release or remote decision.
```

```text
Check: later change to branch
Decision: invalidates the refreshed evidence snapshot
Evidence Required: git branch --show-current compared to master
Recovery: refresh repository binding and rerun evidence-first and synthesis-comparison.
```

```text
Check: later change to remote URL
Decision: invalidates the refreshed evidence snapshot
Evidence Required: git remote -v compared to origin https://github.com/politzcly-star/personal-workflow-harness-v2.git
Recovery: refresh remote binding evidence before any future remote action discussion.
```

```text
Check: later change to commit range
Decision: invalidates the refreshed evidence snapshot
Evidence Required: git log --oneline --decorate origin/master..HEAD compared to the Phase 25 snapshot
Recovery: refresh commit range evidence.
```

```text
Check: later change to staged area
Decision: invalidates the refreshed evidence snapshot
Evidence Required: git diff --cached --name-only
Recovery: require explicit Human instruction before staging; Phase 25 itself must not stage.
```

```text
Check: later change to working tree
Decision: invalidates the refreshed evidence snapshot
Evidence Required: git ls-files --modified --others --exclude-standard
Recovery: review scope, preserve .claude/ exclusion, and refresh evidence.
```

```text
Check: later change to release scope
Decision: invalidates the refreshed evidence snapshot
Evidence Required: changed artifact wording that expands from paper package completeness into release, distribution, publication, tag, push, PR, production, remote-sync, or remote action scope
Recovery: reset to paper scope or require a separate Human release decision with current evidence.
```

```text
Check: later change to canonical status fields
Decision: invalidates the refreshed evidence snapshot
Evidence Required: compare Execution Authorized, push / PR Authorized, Remote Action Authorized, Remote Execution Authorized, Remote Action Executed, and Release Authorized fields across decision-bearing artifacts
Recovery: preserve safest no state unless a future Human decision explicitly authorizes a separate action.
```

```text
Check: later change to evidence refs
Decision: invalidates the refreshed evidence snapshot
Evidence Required: compare complete P25-EV-* list and uniqueness
Recovery: add append-only style P25-EV-* evidence and rerun citation checks.
```

```text
Check: later change to evaluator state
Decision: invalidates the refreshed evidence snapshot
Evidence Required: compare Evaluator Gate Card decision and evidence-first / synthesis-comparison pass state
Recovery: rerun independent evaluator review.
```

```text
Check: later change to Human wording
Decision: invalidates the refreshed evidence snapshot
Evidence Required: compare Human Decision wording and authorization fields
Recovery: treat changed wording as a new decision input and refresh evidence.
```

## Blocker Checks

```text
Check: dirty staged files
Decision: blocks acceptance
Evidence Required: git diff --cached --name-only output
Current Result: no staged files during Phase 25 validation
Recovery: stop; do not stage in Phase 25.
```

```text
Check: missing evidence ref
Decision: blocks acceptance
Evidence Required: required refreeze, snapshot, authorization, evaluator, Human, README, or validation evidence not represented in P25 Evidence Index
Current Result: P25 Evidence Index includes refreeze packet, refreshed snapshot, authorization snapshot, checklist, evaluator, Human, README, and validation refs
Recovery: add append-only style P25-EV-* evidence entry.
```

```text
Check: unresolved No-Go
Decision: blocks release and remote acceptance
Evidence Required: evaluator or Human No-Go without recovery decision
Current Result: release, execution, push, PR, remote action, remote execution, remote-sync, route selection, remote command, and exact command execution remain No-Go
Recovery: keep all canonical status fields at no until a separate Human decision and fresh evidence exist.
```

```text
Check: local-only state
Decision: blocks release and remote acceptance
Evidence Required: release, publication, production, tag, distribution, remote-sync, push, or PR scope relying only on local state
Current Result: Phase 25 is local paper state only
Recovery: treat release scope as unauthorized and require future Human Go with current evidence.
```

```text
Check: fake release approval
Decision: blocks acceptance
Evidence Required: artifact or chat wording implying release authorization without Human decision
Current Result: no release approval exists; Release Authorized: no
Recovery: remove approval implication and preserve Release Authorized: no.
```

```text
Check: remote action claim
Decision: blocks acceptance
Evidence Required: any claim that a push, PR, release, remote command, network remote action, remote execution, or remote-sync occurred
Current Result: no remote/network action occurred
Recovery: remove unsupported claim or require independently verifiable remote evidence in a separately authorized workflow.
```

## Checklist Result

```text
Expected Result: Any later change to HEAD, branch, remote URL, commit range, staged area, working tree, release scope, canonical status fields, evidence refs, evaluator state, or Human wording invalidates the refreshed evidence snapshot.
Expected Result: dirty staged files, missing evidence ref, unresolved No-Go, local-only state, fake release approval, or remote action claim blocks acceptance.
Current Result: Phase 25 can support paper package completeness review only.
Execution Authorized: no
push / PR Authorized: no
Remote Action Authorized: no
Remote Execution Authorized: no
Remote Action Executed: no
Release Authorized: no
```
