# Dispatch Matrix: docs navigation/index improvement proposal

## Header

```text
Dispatch ID: D-P3-DOCS-001
Task Instance Ref: examples/phase-3-docs-index-rehearsal/task-instance.md
North Star Version: v1
Human Signoff Ref: examples/phase-3-docs-index-rehearsal/task-instance.md#human-signoff
Parent Thread: 019ed8e6-1595-7140-9292-f61b30c3dbfb delegated Phase 3 child thread
Created At: 2026-06-18
```

## Parent Boundary

Parent Responsibilities:

- Draft child goals.
- Maintain Phase 3 control-plane artifacts.
- Synthesize reports from evidence refs.
- Escalate conflicts and scope changes.

Parent Forbidden:

- Parent cannot assign itself.
- Parent cannot assign itself as generator or evaluator.
- Parent cannot modify README, docs index, source code, runner, scripts, CI, Docker, or v1 files.
- Parent cannot replace child verification evidence with chat memory.
- Parent cannot stage, commit, push, or open a PR.

## Child Ownership Rows

### C-P3-RESEARCH

```text
Child ID: C-P3-RESEARCH
Role: researcher
Goal: Inspect current README/docs/templates/examples file inventory and report what navigation inputs exist.
Owned Files: none
Allowed Read: README.md, docs/*.md, templates/*.md, examples/*.md, examples/phase-3-docs-index-rehearsal/*.md after creation
Allowed Changes: none
Forbidden Changes: Any file modification, .claude/settings.local.json, v1 path, source code, runner, scripts, CI, Docker, browser automation, production, database, secrets, paid external actions
Expected Evidence: File inventory, relevant existing docs/templates/examples, verification command summary
Required Verification: rg --files
Stop Conditions: Required evidence outside allowed read; any needed change outside allowed changes; verification cannot run; authority conflict; unsafe side effect; child exhausts available actions
Report Contract: Include Changed Files: none, evidence refs, verification command/exit/output summary, stop conditions, exhaustion status, and recommended parent action
Report Path: examples/phase-3-docs-index-rehearsal/child-report-research.md
Exhaustion Output: child-report: exhausted
```

### C-P3-PROPOSAL

```text
Child ID: C-P3-PROPOSAL
Role: planner
Goal: Draft a docs navigation/index improvement proposal as artifact text only, using Researcher evidence.
Owned Files: none
Allowed Read: examples/phase-3-docs-index-rehearsal/child-report-research.md, README.md, docs/*.md, templates/*.md, examples/*.md
Allowed Changes: none
Forbidden Changes: README edit, docs index edit, template edit, .claude/settings.local.json, v1 path, source code, runner, scripts, CI, Docker, browser automation, production, database, secrets, paid external actions
Expected Evidence: Proposal options, evidence refs, implementation non-action statement, verification summary
Required Verification: Confirm proposal is artifact-only and child changed files are none
Stop Conditions: Proposal requires implementation; evidence refs are missing; scope expands beyond docs-only/no implementation; authority conflict; child exhausts available actions
Report Contract: Include Changed Files: none, evidence refs, verification command/exit/output summary or explicit no-run reason, stop conditions, exhaustion status, and recommended parent action
Report Path: examples/phase-3-docs-index-rehearsal/child-report-proposal.md
Exhaustion Output: child-report: exhausted
```

## Merge And Conflict Rules

```text
Merge Rule: Parent may synthesize child reports only through Evidence IDs and report refs.
Conflict Rule: Conflicts enter Evidence Index and become evaluator input; authoritative artifact disagreement becomes blocked: authority-conflict.
Shared File Rule: No child owns changed files in this rehearsal.
Evaluator Assignment: EVAL-P3-DOCS
Human GO Required For: Final acceptance, scope expansion, and any actual navigation/index implementation.
```
