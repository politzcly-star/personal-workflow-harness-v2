# Child Report: Authority Conflict Lane

## Header

```text
Child ID: C-P5-CONFLICT
Role: generator
Status: complete
Task Instance Ref: examples/phase-5-gate-hardening-drill/task-instance.md
Evidence Refs: P5-EV-005
```

## Conflict Evidence

```text
Conflict Type: authority conflict
Signed North Star Scope: markdown-only drill artifacts.
Conflicting Dispatch Scope: hypothetical source-code edit request.
Required State: blocked: authority-conflict
Parent Allowed Response: stop, preserve both refs, ask Human to resolve.
Parent Forbidden Response: silently expand scope or treat chat context as higher authority.
```

## Resolution Path

```text
Needed Human Decision: choose markdown-only scope, approve a new signed scope, or reject the conflicting request.
Evidence Index Action: append conflict and final Human decision records.
```
