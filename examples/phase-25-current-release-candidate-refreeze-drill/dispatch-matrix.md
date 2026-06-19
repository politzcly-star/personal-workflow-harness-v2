# Dispatch Matrix: current release candidate refreeze drill

## Parent Boundary

```text
Parent Thread: Phase 25 parent thread
Parent Role: orchestration and read-only acceptance synthesis only
Parent Cannot Self-Assign As Generator: yes
Parent Cannot Self-Assign As Evaluator: yes
Parent Cannot Authorize Execution: yes
Parent Cannot Authorize push / PR: yes
Parent Cannot Authorize Remote Action: yes
Parent Cannot Authorize Remote Execution: yes
Parent Cannot Authorize Release: yes
Parent Cannot Convert Chat Memory Into Evidence: yes
```

## Child Assignment

```text
Child ID: C-P25-CURRENT-RELEASE-CANDIDATE-REFREEZE
Role: Generator
Allowed Reads: current v2 repository files only; Phase 24 artifacts; templates; local git metadata through required validation commands
Allowed Changes: README.md Phase 25 navigation links only; docs/phase-25-current-release-candidate-refreeze-guide.md; examples/phase-25-current-release-candidate-refreeze-drill/*.md
Forbidden Reads: D:\personal-workflow v1 repository equivalent; D:\个人工作流 v1 repository; secrets; production; remote systems
Forbidden Changes: .claude/settings.local.json; .claude/ files; Phase 1-24 artifacts except README Phase 25 navigation additions; source code; runner; scripts; CI; Docker
Report Contract: child-report-current-release-candidate-refreeze.md must record changed files, what was implemented, validation commands and results, scope/forbidden-action confirmation, evidence/citation checks, remaining risks, and parent acceptance recommendation.
```

## Evaluator Assignment

```text
Evaluator ID: EVAL-P25-CURRENT-RELEASE-CANDIDATE-REFREEZE
Role: independent evaluator
Independence: evaluator is not the Parent and is not the Generator
Required Pass 1: evidence-first
Required Pass 2: synthesis-comparison
Decision Boundary: may allow paper package completeness only; must maintain No-Go for release, execution, push, PR, remote action, remote execution, remote-sync, route selection, remote command, and exact command execution.
```

## Stop Conditions

```text
Stop If: any need to stage, commit, push, PR, release, publish, tag, perform a remote command, perform a network remote action, remote execute, remote-sync, choose a route, or execute exact commands beyond local validation.
Stop If: any edit would touch files outside allowed Phase 25 markdown scope or README Phase 25 navigation additions.
Stop If: any edit would touch .claude/settings.local.json or any .claude/ file.
Stop If: any task requires reading or writing the v1 repository.
Stop If: any artifact implies Execution Authorized: yes, push / PR Authorized: yes, Remote Action Authorized: yes, Remote Execution Authorized: yes, Remote Action Executed: yes, or Release Authorized: yes.
Stop If: Parent Synthesis needs a claim that cannot cite Child Report or P25-EV-*.
Stop If: a missing evidence ref, dirty staged files, unresolved No-Go, local-only state in release scope, fake release approval, or remote action claim appears.
```
