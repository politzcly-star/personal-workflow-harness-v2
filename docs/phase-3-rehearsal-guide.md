# Phase 3 Rehearsal Guide

Phase 3 starts a live process rehearsal for the v2 control plane, but it still produces markdown artifacts only. It is not a runner, CI job, browser automation, Docker flow, GitHub issue tracker integration, production action, database action, secret action, or paid external action.

## Rehearsal Flow

1. Human provides or signs the Human-signed North Star.
2. Parent records the task instance and append-only Evidence Index.
3. Parent drafts the Dispatch Matrix and assigns child work.
4. Child threads execute inside their allowed read/change boundaries and submit Child Reports.
5. Evaluator reviews evidence-first, then performs synthesis-comparison after Parent Synthesis exists.
6. Parent writes Parent Synthesis using only child report refs, verification refs, Evaluator Gate Card refs, and Evidence IDs.
7. Human records a final decision or leaves a Human Decision placeholder.

Parent cannot assign itself. Parent also cannot replace child verification evidence with chat memory, reject Evaluator findings, or rewrite previous Evidence Index entries.

## Evidence Rules

Evidence refs should point to artifact paths and stable Evidence IDs. Verification summaries belong in Child Reports first, then Parent Synthesis may cite those report refs. Evidence Index updates are append-only: new status changes are appended as update records instead of editing old entries.

If artifacts disagree on North Star content, task state, Evaluator decision, scope, evidence status, or Human decision, the task becomes `blocked: authority-conflict` until Human resolves it.

If a child exhausts allowed actions or hits a stop condition, its report must include `child-report: exhausted` and the Parent must not re-dispatch the same goal unchanged.

## Phase 3 Boundary

This phase rehearses dispatch, reports, evaluator review, synthesis, and human decision capture with real markdown files. It does not implement a docs index, edit README navigation, launch automation, stage files, commit, push, or open a PR.
