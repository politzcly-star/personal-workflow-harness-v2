# Dispatch Matrix: execution denial / abort and recovery drill

## Parent Boundary

```text
Parent Role: Orchestrator and final synthesis drafter only
Parent May: assign child generator, assign evaluator, compare reports, request Human decision later
Parent Must Not: act as Generator, act as Evaluator, select route, authorize execution, stage, commit, push, PR, remote command, network remote action, release, edit .claude/, read or write v1 repository
Parent Conversion Rule: Parent cannot convert rejection, silence, stale approval, local commit, ahead count, candidate command text, or chat-only wording into execution permission.
```

## Child Assignments

```text
Child ID: C-P21-EXECUTION-DENIAL-ABORT-RECOVERY
Role: Generator
Mission: create markdown-only Phase 21 control-plane artifacts for execution denial, abort trigger, and recovery decision handling.
Allowed Read: README.md; docs/phase-20-execution-human-go-capture-guide.md; examples/phase-20-execution-human-go-capture-drill/*; allowed Phase 21 files.
Allowed Change: README.md Phase 21 navigation links only; docs/phase-21-execution-denial-abort-recovery-guide.md; examples/phase-21-execution-denial-abort-recovery-drill/*.md.
Stop Conditions: need to edit outside Allowed Changes; need to stage, commit, push, PR, execute remote command, perform network remote action, select route, authorize execution, alter .claude/, access v1 repository, or rewrite Phase 1-20 artifacts beyond README Phase 21 navigation links.
Report Contract: changed files, guide/artifacts summary, validation command results, forbidden-scope confirmation, Human Decision state, Evidence ID uniqueness, Parent Synthesis citation result, remaining risks, parent acceptance recommendation.
```

```text
Evaluator ID: EVAL-P21-EXECUTION-DENIAL-ABORT-RECOVERY
Role: Independent execution denial and recovery evaluator
Must Inspect Before Parent Synthesis: Task Instance, Dispatch Matrix, Phase 21 Guide, Execution Denial Record, Abort Trigger Checklist, Recovery Decision Matrix, Child Report, Human Decision placeholder, README navigation, and P21 Evidence Index.
Required Passes: evidence-first; synthesis-comparison
No-Go Rule: Human No-Go, expired authorization, ambiguous abort wording, stale approval, silence, chat-only approval, changed HEAD/range/remote, dirty staged files, unexpected release files, missing evidence ref, unresolved No-Go, or local-only state in release scope blocks execution.
```

## Current Execution State

```text
Selected Route: none
Execution Human Go: missing
Execution Authorized: no
push / PR Authorized: no
Remote Action Authorized: no
Remote Action Executed: no
Human Decision: pending
```
