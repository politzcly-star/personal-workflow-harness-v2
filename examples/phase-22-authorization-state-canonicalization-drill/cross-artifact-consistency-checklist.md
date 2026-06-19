# Cross-Artifact Consistency Checklist

## Required Canonical State

```text
Execution Authorized: no
push / PR Authorized: no
Remote Action Authorized: no
Remote Execution Authorized: no
Remote Action Executed: no
Release Authorized: no
```

## Blocking Checklist

```text
Check: missing canonical status field
Decision: blocks acceptance
Evidence Required: artifact path and missing field name
Recovery: update the Phase 22 artifact to include the canonical status field.
```

```text
Check: conflicting yes/no fields
Decision: blocks acceptance
Evidence Required: artifact path, conflicting field, and current canonical field
Recovery: keep the safest no state unless a future Human decision explicitly authorizes a separate action.
```

```text
Check: omitted non-authorization input
Decision: blocks acceptance
Evidence Required: inventory entry missing rejection, silence, stale approval, local commit, ahead count, candidate command text, chat-only wording, or artifact completeness
Recovery: add the omitted input to the Phase 22 inventory.
```

```text
Check: stale evidence
Decision: blocks acceptance
Evidence Required: outdated HEAD, branch, remote URL, origin/master..HEAD range, staged area, working tree, evaluator decision, or Human wording
Recovery: refresh evidence and rerun evaluator evidence-first and synthesis-comparison.
```

```text
Check: dirty staged files
Decision: blocks acceptance
Evidence Required: git diff --cached --name-only output
Recovery: require explicit Human instruction before any staging action; Phase 22 itself must not stage.
```

```text
Check: missing evidence ref
Decision: blocks acceptance
Evidence Required: Parent claim or evaluator finding without Child Report or P22-EV-* citation
Recovery: cite Child Report or a valid P22-EV-* Evidence ID.
```

```text
Check: unresolved No-Go
Decision: blocks acceptance
Evidence Required: evaluator or Human No-Go without recovery decision
Recovery: keep all canonical status fields at no until recovery exists.
```

```text
Check: local-only state in release scope
Decision: blocks acceptance
Evidence Required: release, publication, production, tag, distribution, or remote-sync scope relying only on local state
Recovery: treat release scope as unauthorized and require future Human Go.
```

## Consistency Drill Result

```text
Expected Result: Any mismatch blocks acceptance before Parent can claim paper completeness.
Current Result: no execution, push, PR, remote action, remote execution, or release authorization exists.
Execution Authorized: no
push / PR Authorized: no
Remote Action Authorized: no
Remote Execution Authorized: no
Remote Action Executed: no
Release Authorized: no
```
