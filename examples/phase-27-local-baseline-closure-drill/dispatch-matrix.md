# Dispatch Matrix: local baseline closure drill

## Header

```text
Task ID: phase-27-local-baseline-closure-drill
Dispatch Version: v1
Created At: 2026-06-19
Parent Role: Orchestrator only
Parent Self-Assignment Allowed: no
```

## Role Assignments

```text
Role: Generator
Assigned To: C-P27-LOCAL-BASELINE-CLOSURE
Parent Can Self-Assign: no
Purpose: Create allowed Phase 27 markdown/control-plane artifacts, run local checks, and add README Phase 27 navigation links only.
Allowed Reads: README.md; docs/phase-1 through phase-26 guide artifacts where present; examples/phase-1 through phase-26 drill artifacts where present; templates/*; current local git metadata.
Allowed Changes: README.md Phase 27 navigation links only; docs/phase-27-local-baseline-closure-guide.md; examples/phase-27-local-baseline-closure-drill/*.md.
Forbidden Changes: .claude/settings.local.json; .claude/ files; v1 repository reads or writes; source code; runner; scripts; CI; Docker; browser automation; GitHub issue tracker integration; production; database; secrets; paid external actions; stage; commit; push; PR; remote command; network remote action; remote execution; release; Phase 1-26 artifacts except README Phase 27 navigation additions.
Report Contract: Child Report must record changed files, Phase 27 artifact summary, validation commands/results, scope status, Human Decision pending state, canonical authorization no-state, forbidden-action confirmation, remaining risks, and parent acceptance recommendation.
```

```text
Role: Evaluator
Assigned To: EVAL-P27-LOCAL-BASELINE-CLOSURE
Parent Can Self-Assign: no
Independence Required: yes
Purpose: Review Phase 27 artifacts using evidence-first and synthesis-comparison passes.
Allowed Reads: Phase 27 guide, task instance, dispatch matrix, child report, local baseline closure record, stop condition declaration, future work handoff, evaluator gate card, parent synthesis, human decision, README navigation, and P27-EV-* Evidence Index.
Allowed Changes: examples/phase-27-local-baseline-closure-drill/evaluator-gate-card.md only.
Forbidden Authority: Evaluator cannot authorize release, execution, push, PR, remote action, remote execution, remote-sync, route selection, remote command, exact command execution, stage, commit, Phase 28 continuation, or stale release packet reuse.
Decision Scope: review_ready paper package completeness only.
Decision Options: Go; Conditional Go; No-Go.
```

## Stop Conditions

```text
Stop If: scope drift outside allowed Phase 27 files or README Phase 27 navigation additions.
Stop If: staged files exist.
Stop If: any remote action, network remote action, remote execution, push, PR, release, route selection, execution authorization, exact command execution, stage, commit, source-code change, runner change, scripts change, CI change, Docker change, browser automation, production touch, secrets access, paid action, v1 repository read/write, .claude/ edit, or Phase 1-26 artifact edit is needed.
Stop If: any canonical authorization field is set to yes, including Execution Authorized, push / PR Authorized, Remote Action Authorized, Remote Execution Authorized, or Release Authorized.
Stop If: required citations are missing from Parent Synthesis Claim, Finding, or Recommended Decision blocks.
Stop If: duplicate P27-EV-* Evidence IDs exist.
Stop If: Parent attempts to self-assign as Generator or Evaluator.
Stop If: Parent attempts to continue into Phase 28 based on inertia, chat wording, ahead count, paper completeness, local commit, evaluator pass, or parent recommendation.
```

## Canonical Authorization State

```text
Execution Authorized: no
push / PR Authorized: no
Remote Action Authorized: no
Remote Execution Authorized: no
Remote Action Executed: no
Release Authorized: no
Human Decision: pending
No Remote/Network Action Occurred: yes
No Local Commit Acceptance Yet: yes
```
