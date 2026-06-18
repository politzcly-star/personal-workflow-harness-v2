# Phase 8 Evaluator Dispute Guide

Phase 8 keeps v2 as a markdown control plane. It does not add runner, CI, Docker, browser automation, source code, production access, secrets, paid actions, push, PR, or v1 repository changes.

## Purpose

This guide rehearses what happens when Parent disagrees with an Evaluator `No-Go`.

The rule is simple:

```text
Evaluator No-Go
> Parent Dispute Record
> blocked: needs-human-decision
> Human Decision Recovery
```

Parent cannot reject, override, delete, rewrite, or water down Evaluator findings. Parent can only record an `Evaluator Dispute`, cite Evidence IDs, and wait for Human decision.

## Non-Bypass Rules

- Parent cannot assign itself.
- Parent cannot assign itself as Generator or Evaluator.
- Parent cannot reject Evaluator `No-Go`.
- Parent disagreement becomes `Evaluator Dispute`.
- Evaluator Dispute changes the task route to `blocked: needs-human-decision`.
- Evidence Index is append-only.
- Human-signed North Star remains the highest task authority.
- Chat memory cannot serve as Human acceptance.
- A fake Human acceptance blocks acceptance.

## Evaluator Passes

Evaluator review still has two required passes:

```text
Pass Type: evidence-first
Reads: North Star, Task Instance, Dispatch Matrix, Child Report, raw evidence, diff, verification outputs, Evidence Index
Purpose: decide from evidence before reading Parent Synthesis
```

```text
Pass Type: synthesis-comparison
Reads: Parent Synthesis as a Parent claim, not as fact
Purpose: compare Parent statements against evidence-first findings
```

An optional recovery follow-up can verify a Human decision, but it must not rewrite the original Evaluator finding.

## Parent Dispute Handling

When Parent disagrees with an Evaluator finding:

1. Record an `Evaluator Dispute`.
2. Cite the Evaluator finding Evidence ID.
3. Cite the Parent basis Evidence ID.
4. State that Parent is not overriding the finding.
5. Set the recovery route to `blocked: needs-human-decision`.
6. Wait for Human Go, Reject, accepted-risk, or follow-up.

## Human Decision Recovery

Human recovery can record:

- `Go`: Human accepts the Evaluator finding is resolved or not blocking.
- `Reject`: Human rejects the task outcome.
- `accepted-risk`: Human explicitly accepts a named risk.
- `follow-up`: Human requests additional generator or evaluator work.

Recovery records must append new Evidence Index entries. They must not modify old Evaluator findings.

## Acceptance Blockers

The task remains blocked when any of these occur:

- missing `Evaluator Dispute` evidence
- overwritten Evaluator findings
- Parent claims a `No-Go` is rejected
- unresolved `Conditional Go`
- fake Human acceptance
- missing Evidence ID for Parent Synthesis claims
- missing Human-signed North Star

