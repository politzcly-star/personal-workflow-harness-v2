# Task Instance: docs navigation/index improvement proposal

## Instance Header

```text
Task ID: phase-3-docs-index-rehearsal
Task Title: docs navigation/index improvement proposal
Parent Thread: 019ed8e6-1595-7140-9292-f61b30c3dbfb delegated Phase 3 child thread
North Star Version: v1
Current State: review_ready
Blocked Reason: none
Next Action: Human reviews artifacts and records Go, Reject, or Request Follow-up in human-decision.md
Last Updated: 2026-06-18
```

## North Star Contract

Human-signed North Star is the highest task authority.

```text
Intent: Rehearse the v2 Parent/Child/Evaluator/Human artifact loop using a low-risk docs-only task.
Task Name: docs navigation/index improvement proposal
Non-goals: No README edit, no docs index edit, no source code change, no runner, no CI, no Docker, no browser automation, no GitHub issue tracker integration, no production action, no database action, no secrets, no paid external action.
Acceptance Criteria:
- The task records a Human-signed North Star, Dispatch Matrix, two Child Reports, Evaluator Gate Card, Parent Synthesis, and Human Decision placeholder.
- The proposal suggests documentation navigation/index improvements only as artifact text.
- Child Reports record Changed Files: none for the child work.
- Evaluator review records both evidence-first and synthesis-comparison passes.
- Evidence Index remains append-only and includes child-report, verification, evaluator-finding, parent-synthesis, and human-decision placeholder refs.
Quality Bar: All factual Parent Synthesis claims cite child reports or Evidence IDs.
Forbidden Outcomes: Implementing the proposed README/docs navigation changes, touching v1, staging, committing, pushing, opening a PR, modifying .claude/settings.local.json, or changing files outside the Phase 3 allowed list.
Allowed Changes: docs/phase-3-rehearsal-guide.md and examples/phase-3-docs-index-rehearsal/*.md listed in the Phase 3 delegation.
Forbidden Changes: .claude/settings.local.json, v1 repository path, source code, runner, scripts, CI, Docker, browser automation, GitHub issue tracker integration, production, database, secrets, paid external actions.
Human GO Required For: Any implementation of the proposed navigation/index change, any scope expansion, any Conditional Go follow-up that is not already satisfied, and final acceptance.
```

## Human Signoff

```text
Human Signoff: signed
Confirmation Text: Delegation requested Phase 3 live process rehearsal for a docs navigation/index improvement proposal, docs-only/no implementation.
Confirmed At: 2026-06-18
Recorded By: Codex Phase 3 child thread
```

## Runtime Boundaries

```yaml
ports: []
databases: []
network: []
secrets: []
production: false
browser_state: []
external_paid_actions: false
```

## Control Plane Refs

```text
Dispatch Matrix Ref: examples/phase-3-docs-index-rehearsal/dispatch-matrix.md
Parent Synthesis Ref: examples/phase-3-docs-index-rehearsal/parent-synthesis.md
Evaluator Gate Card Refs: examples/phase-3-docs-index-rehearsal/evaluator-gate-card.md
Context Snapshot Refs: none
Human Decision Ref: examples/phase-3-docs-index-rehearsal/human-decision.md
```

## Children

```text
Active Children: none

Completed Children:
- Child ID: C-P3-RESEARCH
  Role: researcher
  Status: complete
  Report Ref: examples/phase-3-docs-index-rehearsal/child-report-research.md
  Evidence Refs: EV-002, EV-003
- Child ID: C-P3-PROPOSAL
  Role: planner
  Status: complete
  Report Ref: examples/phase-3-docs-index-rehearsal/child-report-proposal.md
  Evidence Refs: EV-004, EV-005
```

## Evaluator State

```text
Evaluator Assigned: EVAL-P3-DOCS
Current Pass: synthesis-comparison
Decision: Go
Decision Ref: examples/phase-3-docs-index-rehearsal/evaluator-gate-card.md
Dispute: NONE
```

Evaluator `No-Go` blocks the task. Evaluator `Conditional Go` requires a second lightweight pass before acceptance. Parent cannot override Evaluator findings.

## Conditional Go Conditions

```text
Conditions: none
```

## Open Conflicts

```text
Open Conflicts: none
Authority Conflict Rule: use blocked: authority-conflict if signed North Star, task state, Evaluator decision, allowed scope, evidence status, or Human decision disagree.
```

## Evidence Index

Evidence Index is append-only. Do not delete or rewrite old entries.

```text
Evidence ID: EV-001
Source: task-instance.md
Type: human-decision
Status: open
Summary: Human-signed North Star authorizes a Phase 3 docs-only rehearsal and forbids implementation.
Reference: examples/phase-3-docs-index-rehearsal/task-instance.md#human-signoff
Created At: 2026-06-18
Updated By: Codex Phase 3 child thread
Update Reason: Initial rehearsal task creation.
```

```text
Evidence ID: EV-002
Source: child-report-research.md
Type: child-report
Status: open
Summary: Researcher inspected existing README, docs, templates, and examples file list.
Reference: examples/phase-3-docs-index-rehearsal/child-report-research.md
Created At: 2026-06-18
Updated By: C-P3-RESEARCH
Update Reason: Child report recorded.
```

```text
Evidence ID: EV-003
Source: child-report-research.md
Type: verification
Status: open
Summary: Researcher verification used rg --files and summarized repository markdown artifacts.
Reference: examples/phase-3-docs-index-rehearsal/child-report-research.md#verification
Created At: 2026-06-18
Updated By: C-P3-RESEARCH
Update Reason: Verification evidence recorded.
```

```text
Evidence ID: EV-004
Source: child-report-proposal.md
Type: child-report
Status: open
Summary: Proposal Writer drafted a docs navigation/index improvement proposal without editing README or docs index.
Reference: examples/phase-3-docs-index-rehearsal/child-report-proposal.md
Created At: 2026-06-18
Updated By: C-P3-PROPOSAL
Update Reason: Child report recorded.
```

```text
Evidence ID: EV-005
Source: child-report-proposal.md
Type: verification
Status: open
Summary: Proposal Writer verification confirms changed files are none for child work and proposal is artifact-only.
Reference: examples/phase-3-docs-index-rehearsal/child-report-proposal.md#verification
Created At: 2026-06-18
Updated By: C-P3-PROPOSAL
Update Reason: Verification evidence recorded.
```

```text
Evidence ID: EV-006
Source: evaluator-gate-card.md
Type: evaluator-finding
Status: open
Summary: Evaluator completed evidence-first and synthesis-comparison passes with Go decision for artifact completeness.
Reference: examples/phase-3-docs-index-rehearsal/evaluator-gate-card.md
Created At: 2026-06-18
Updated By: EVAL-P3-DOCS
Update Reason: Evaluator finding recorded.
```

```text
Evidence ID: EV-007
Source: parent-synthesis.md
Type: parent-synthesis
Status: open
Summary: Parent Synthesis cites child reports and Evidence IDs, then recommends a human decision.
Reference: examples/phase-3-docs-index-rehearsal/parent-synthesis.md
Created At: 2026-06-18
Updated By: Parent
Update Reason: Parent synthesis recorded.
```

```text
Evidence ID: EV-008
Source: human-decision.md
Type: human-decision
Status: open
Summary: Human Decision placeholder records that no final user acceptance has been claimed.
Reference: examples/phase-3-docs-index-rehearsal/human-decision.md
Created At: 2026-06-18
Updated By: Parent
Update Reason: Placeholder recorded pending Human Go, Reject, or Request Follow-up.
```
