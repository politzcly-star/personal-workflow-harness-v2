# Phase 6 Dispatch Discipline Guide

Phase 6 keeps v2 as a markdown control plane. It does not add runner, CI, Docker, browser automation, source code, production access, secrets, paid actions, push, PR, or v1 repository changes.

## Purpose

This guide corrects workflow drift from parent-direct implementation by separating parent control-plane duties from child generator work and evaluator review.

## Parent-Allowed Control Work

Parent may:

- draft North Star and dispatch artifacts for Human signoff
- create or update task-state, dispatch, synthesis, handoff, and acceptance artifacts
- commit after explicit Human Go
- record accepted-risk only when Human explicitly accepts a named risk

Parent must not:

- assign itself as generator or evaluator
- directly perform generator-owned implementation
- replace child verification with chat memory
- reject Evaluator No-Go or unresolved Conditional Go
- re-dispatch child-report: exhausted unchanged

Parent cannot assign itself.

## Delegation Rules

Generator work must be delegated when a task changes product docs, examples, templates, source code, or any user-facing artifact outside parent-only control records. The child must report changed files, verification, evidence refs, stop conditions, and exhaustion status.

Evaluator work must be independent from Parent and Generator. The Evaluator performs `evidence-first` before reading Parent Synthesis, then performs `synthesis-comparison` against Parent claims. Evaluator outputs `Go`, `Conditional Go`, or `No-Go`.

## Parent-Direct Attempt Handling

If Parent directly performs generator implementation without Human accepted-risk, record the attempt as `blocked: authority-conflict` and stop acceptance.

If Human explicitly accepts the risk, record `accepted-risk` in the Evidence Index and add a follow-up control. For Phase 6, the follow-up control is child-thread execution of the dispatch discipline rehearsal.

## Acceptance Checklist

- Parent prepared dispatch but did not self-assign as generator or evaluator.
- Child verification results live in Child Reports.
- Evaluator recorded `evidence-first` and `synthesis-comparison`.
- Parent Synthesis cites only Child Reports and Evidence IDs.
- Human Decision remains pending until explicit Human Go.
