# Phase 5 Gate Hardening Guide

Phase 5 keeps v2 as a markdown control plane. It does not add runner, CI, Docker, browser automation, source code, production access, secrets, paid actions, push, PR, or v1 repository changes.

## Purpose

This guide tells a Parent thread how to respond when v2 evidence is not clean enough for acceptance. It complements the Phase 5 drill in `examples/phase-5-gate-hardening-drill/`.

## Parent Response Rules

Use these rules in order:

1. Preserve the Human-signed North Star and current Task Instance as the highest local task artifacts.
2. Keep Evidence Index append-only; add update records instead of deleting or rewriting old evidence.
3. Treat Evaluator findings as gate decisions, not suggestions.
4. Keep child verification in Child Reports; Parent Synthesis may cite reports but must not replace them with chat memory.

For `Conditional Go`:

- Do not move the task to `accepted`.
- Dispatch only the narrow follow-up condition.
- Require a `conditional-followup` Evaluator pass before acceptance.
- Record both the original condition and the follow-up result as Evidence IDs.

For `No-Go`:

- Block the task.
- Parent cannot reject or override the finding.
- If Parent disagrees, record an Evaluator Dispute and move to `blocked: needs-human-decision`.
- Do not rewrite Parent Synthesis to hide the finding.

For `blocked: authority-conflict`:

- Stop merging or accepting the task.
- Identify the conflicting authoritative artifacts.
- Ask Human to resolve the conflict.
- Append the conflict and final Human resolution to the Evidence Index.

For `child-report: exhausted`:

- Do not re-dispatch the same goal unchanged.
- Either block for Human decision or draft narrower scope and wait for Human signoff.
- Preserve the exhausted child report as evidence.

## Verification Checklist

- Every Parent Synthesis factual claim cites a Child Report or Evidence ID.
- `No-Go` and unresolved `Conditional Go` prevent `accepted`.
- Authority conflict uses `blocked: authority-conflict`.
- Child exhaustion uses `child-report: exhausted` and no unchanged re-dispatch.
- Push and PR remain forbidden unless separately authorized.
