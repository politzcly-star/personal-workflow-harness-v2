# Phase 2 Paper Drill

This is a low-risk paper exercise that proves the control-plane loop:

```text
North Star -> Dispatch -> Child Report -> Evaluator -> Parent Synthesis -> Human Decision
```

No runner, CI, Docker, browser automation, GitHub issue tracker integration, production system, database, secret, paid external action, commit, push, or PR is used.

## 1. Human-signed North Star

```text
Task ID: paper-drill-doc-index
Intent: Add a documentation index proposal for the v2 harness without editing product code.
Non-goals: No automation, no scripts, no CI, no external systems.
Acceptance Criteria:
- A proposed index lists the core control-plane artifacts.
- The proposal cites exact evidence refs.
- The Evaluator can review it evidence-first.
Allowed Changes: docs/*.md, templates/*.md, examples/*.md
Forbidden Changes: source code, runner, CI, Docker, v1 repository
Human Signoff: signed
Confirmation Text: Human says Go for the paper drill only.
```

Evidence entry to append:

```text
Evidence ID: E-001
Type: human-decision
Summary: Human-signed North Star for paper drill.
Reference: examples/phase-2-paper-drill.md#1-human-signed-north-star
```

## 2. Dispatch Matrix

```text
Dispatch ID: D-001
Task Instance Ref: paper-drill-doc-index
North Star Version: v1
Children:
- Child ID: C-research-001
  Role: researcher
  Goal: Inspect existing docs list and propose index entries.
  Owned Files: none
  Allowed Read: README.md, docs/*.md, templates/*.md
  Allowed Changes: none
  Stop Conditions: missing docs, scope request outside markdown
  Report Contract: Child Report with evidence and verification
  Report Path: examples/phase-2-paper-drill.md#3-child-report
Evaluator Assignment: EVAL-001
```

Parent cannot assign itself.

## 3. Child Report

```text
Child ID: C-research-001
Role: researcher
Status: complete
Changed Files: none
Evidence:
- E-002: README lists architecture, parent protocol, context survival, route, and task-state.
- E-003: templates/task-state.md contains Task State, North Star, Evaluator State, and Evidence Index sections.
Verification:
- Command: rg --files
  Exit Code: 0
  Output Summary: Repository contains README.md, docs/*.md, templates/task-state.md.
Exhaustion Status: none
Recommended Parent Action: Draft Parent Synthesis that proposes adding Phase 2 templates.
```

If the child had exhausted its allowed actions, it would report `child-report: exhausted` here.

## 4. Evaluator Gate Card

```text
Gate Card ID: G-001
Pass Type: evidence-first
Input Artifacts: E-001, E-002, E-003, child report C-research-001
Decision: Conditional Go
Findings:
- P2: Proposal is acceptable only if Parent Synthesis cites evidence refs and preserves append-only Evidence Index rules.
Conditions:
- Add evidence refs to the synthesis.
- Preserve append-only Evidence Index wording.
```

```text
Gate Card ID: G-002
Pass Type: conditional-followup
Input Artifacts: G-001, parent synthesis S-001
Decision: Go
Findings: Conditions are satisfied by evidence refs E-001 through E-003.
```

## 5. Parent Synthesis

```text
Synthesis ID: S-001
Input Child Reports: C-research-001
Accepted Findings:
- Existing docs already define base control plane. Evidence refs: E-002, E-003.
Evaluator State: Conditional Go in G-001, follow-up Go in G-002.
Evidence Refs: E-001, E-002, E-003, G-001, G-002
Remaining Uncertainty: none for the paper drill.
Recommended Human Decision: accept the Phase 2 template baseline as documentation-only.
```

Parent uses evidence refs only; no claim depends on chat memory.

## 6. Human Decision

```text
Decision: accept
Reason: The loop demonstrates North Star -> Dispatch -> Child Report -> Evaluator -> Parent Synthesis -> Human Decision.
Evidence Refs: E-001, C-research-001, G-001, G-002, S-001
```

The Evidence Index remains append-only through the full drill.
