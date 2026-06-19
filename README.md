# Agent-Native Delivery Harness v2

This repository is a markdown control plane for coordinating agent work.
It does not contain a runner, CI pipeline, browser automation, production
integration, or remote-sync automation.

The goal is to make agentic delivery auditable:

```text
Human-signed North Star
> Task State
> Evaluator Decision
> Parent Synthesis
> Child Reports / Evidence Refs
> Chat Context
```

Chat context is never the authority source. A new agent should reload task
state from artifacts before acting.

## What This Repo Is

v2 is a `goal-first / agent-orchestrated control plane`.

Use it when:

- the goal is clear but the path is uncertain
- decomposition, exploration, or parallel child work is useful
- a Parent agent must synthesize multiple reports
- an Evaluator gate should independently review evidence before Human decision

Do not treat this repo as an execution system. It only defines the artifacts
and rules for controlled agent work.

## What This Repo Is Not

This repo does not authorize or implement:

- source-code delivery by itself
- runner / CI / Docker / browser automation
- production, database, secrets, billing, or paid external actions
- push, PR, release, remote command, or remote-sync
- bypassing Human signoff or Evaluator `No-Go`

High-risk execution should fall back to the v1 workflow-first harness or to a
separate gated objective.

## Repository Layout

Start here:

- [v1 / v2 Routing](docs/route-v2.md): decide whether to use v2, v1, or blocked.
- [Architecture](docs/architecture.md): roles, layers, authority order, and guardrails.
- [Parent Agent Protocol](docs/parent-agent-protocol.md): Parent/Child/Evaluator duties and schemas.
- [Context Survival](docs/context-survival.md): context compression, handoff, and recovery.

Templates:

- [Task State](templates/task-state.md): durable task state and Evidence Index.
- [Task Instance](templates/task-instance.md): fillable task instance derived from task state.
- [Dispatch Matrix](templates/dispatch-matrix.md): child ownership, read/write scope, stop conditions.
- [Child Report](templates/child-report.md): child output, evidence, verification, exhaustion.
- [Evaluator Gate Card](templates/evaluator-gate-card.md): evidence-first and synthesis-comparison gate.
- [Parent Synthesis](templates/parent-synthesis.md): parent summary that cites evidence refs only.

Historical phase drills and review reports were intentionally removed from the
working tree. They were useful for building the harness, but they are noisy for
new-project agent onboarding.

## Minimal Operating Flow

1. Route the task with `docs/route-v2.md`.
2. Parent drafts a North Star Contract.
3. Human signs the North Star.
4. Parent creates a Task Instance and Dispatch Matrix.
5. Child agents work only within assigned read/change boundaries.
6. Child agents write Child Reports with verification results.
7. Evaluator performs `evidence-first`, then `synthesis-comparison`.
8. Parent creates Parent Synthesis using evidence refs only.
9. Human decides Go, Conditional Go, No-Go, Reject, or accepted-risk.

The Parent must not use chat memory as evidence, must not self-assign as
Generator or Evaluator, and must not override Evaluator findings.

## New Agent Quickstart

When a new agent enters this repo:

1. Read this README.
2. Read `docs/route-v2.md`.
3. Read `docs/parent-agent-protocol.md`.
4. Use the templates to create task-specific artifacts.
5. Keep all task evidence append-only.
6. Ask for Human signoff before implementation or scope expansion.

If the task cannot define a North Star, blast radius, child ownership, and
acceptance criteria, do not start v2 implementation. Route to v1 or mark the
task `blocked: needs-human-decision`.

## Non-Bypass Rules

- Human-signed North Star is the highest goal source.
- Parent cannot assign itself as Generator or Evaluator.
- Parent cannot reject or override Evaluator `No-Go`.
- `Conditional Go` requires a follow-up Evaluator pass.
- Evidence Index is append-only.
- Child exhaustion must be reported as `child-report: exhausted`.
- Authority conflicts become `blocked: authority-conflict`.
- Push, PR, release, and remote-sync require a separate fresh objective.
