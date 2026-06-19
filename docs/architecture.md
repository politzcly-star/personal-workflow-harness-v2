# v2 Architecture

v2 is an Agent-Native Delivery Harness. It is a markdown control plane for
coordinating agent work under explicit Human goals, bounded permissions,
evidence, independent evaluation, and final Human judgment.

v2 is not a runner, CI system, Docker workflow, browser automation harness,
production integration, database tool, or remote-sync system.

## Relationship To v1

v1 remains the workflow-first, gated-delivery harness. Use v1 when stability,
repeatability, audit strength, or high-risk execution matters more than
exploration.

v2 is for goal-first work where the destination is clear but the path needs
exploration, decomposition, parallel research, or Parent synthesis across
multiple child reports.

v2 does not replace v1. High-risk implementation should fall back to v1 gated
delivery or to `blocked: needs-human-decision`.

## Authority Order

```text
Human-signed North Star
> Task State
> Evaluator Decision
> Parent Synthesis
> Child Reports / Evidence Refs
> Chat Context
```

Chat context can explain intent, but it is never authority. If chat and
artifacts disagree, the artifacts win and the task may enter
`blocked: authority-conflict`.

## Core Layers

### Task Control Plane

The task is represented by artifacts, not by chat memory. The durable task
state records the North Star, Human signoff, child work, evaluator state,
conflicts, next action, and append-only Evidence Index.

The minimum control-plane loop is:

```text
Task Instance
> Dispatch Matrix
> Child Report
> Evaluator Gate Card
> Parent Synthesis
> Human Decision
```

### Agent Orchestration

Parent drafts goals, dispatches child work, reads reports, and synthesizes
evidence. Child agents research, implement, verify, or review inside assigned
boundaries. Evaluator is an independent quality gate, not a normal child.

Parent cannot assign itself as Generator or Evaluator. Parent cannot replace
child verification with chat memory.

### Guardrails

Every task must declare file scope, runtime boundaries, network assumptions,
secret handling, production access, browser state, and paid external actions.

If blast radius, acceptance criteria, or child ownership cannot be defined,
the task must not start v2 implementation.

### Evidence And Decision

Parent Synthesis may cite only evidence refs and child reports. Scope changes,
conflicts, evaluator findings, verification output, and Human decisions must
enter the Evidence Index.

The Evidence Index is append-only. Do not delete, rewrite, renumber, or silently
reclassify old entries.

## Roles

### Human

- Signs the North Star.
- Approves scope expansion, high-risk action, final acceptance, or accepted-risk.
- Resolves evaluator disputes and authority conflicts.

### Parent Agent

- Drafts North Star, Dispatch Matrix, and child goals.
- Maintains task-state artifacts and Evidence Index.
- Synthesizes Child Reports into Parent Synthesis.
- Prepares Human Acceptance Summary.

Parent cannot start implementation before Human signoff, self-assign as
Generator/Evaluator, override Evaluator findings, expand scope, modify signed
North Star, or rewrite Evidence Index entries.

### Child Agents

- Planner: clarifies approach, risk, and decomposition.
- Researcher: investigates code, APIs, docs, or environment.
- Generator: implements within explicit allowed changes.
- Evaluator: independently reviews evidence and blocks unsafe acceptance.

If a child exhausts available actions or hits a stop condition, it must report
`child-report: exhausted`. Parent must not re-dispatch the same goal unchanged.

### Evaluator

Evaluator reads the signed North Star, task state, dispatch matrix, changed
files, full diff, child reports, verification output, relevant project facts,
and Evidence Index.

Evaluator must use two passes:

1. `evidence-first`: review raw evidence before Parent Synthesis.
2. `synthesis-comparison`: compare Parent Synthesis against evidence.

Evaluator decisions are:

- `Go`
- `Conditional Go`
- `No-Go`

`No-Go` blocks acceptance. `Conditional Go` requires a follow-up evaluator pass
before the task can become `accepted`.

## Minimal Artifact Set

- `templates/task-state.md`
- `templates/task-instance.md`
- `templates/dispatch-matrix.md`
- `templates/child-report.md`
- `templates/evaluator-gate-card.md`
- `templates/parent-synthesis.md`

These templates are the active surface for new projects.
