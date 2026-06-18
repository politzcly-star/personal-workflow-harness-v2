# v1 / v2 Routing

This repository is v2, but v2 is not the default for every task. Route conservatively.

## Use v1

Use `D:\个人工作流` v1 Workflow-first Harness when the task is:

- fixed-process automation
- known bugfix
- low-creativity high-stability work
- custom webpage operation agent
- strong audit / strong boundary work
- auth, permissions, secrets, billing, database, migration, production, quota, or destructive-write related
- narrow enough for Task Packet, Scope Gate, Local Gate, and Gate Report

v1 is the safe default when the task values stability more than exploration.

## Use v2

Use v2 only when:

- the goal is clear but the path is uncertain
- exploration, decomposition, or parallel research is valuable
- multiple agents can improve speed or quality
- Parent must synthesize reports from several agents
- the work is architectural design, migration planning, or option comparison
- North Star fields can be defined before implementation
- blast radius can be bounded
- acceptance criteria can be verified

## Do Not Use v2 Directly

Do not route directly to v2 when:

- North Star required fields cannot be defined
- blast radius cannot be bounded
- acceptance criteria cannot be verified
- child ownership cannot be split
- the task is high-risk and lacks a v1 gated Task Packet
- the route is uncertain

These blockers mean v2 must not start implementation directly.

## Fallback

```text
禁止直接用 v2
→ 退回 v1 gated delivery
→ 或 blocked: needs-human-decision
```

Route uncertainty defaults to v1 or blocked. Do not choose v2 because it is newer or more interesting.

## Routing Checklist

```text
Task:
Can define North Star? YES | NO
Can bound blast radius? YES | NO
Can verify acceptance? YES | NO
Can split child ownership? YES | NO
High-risk domain? YES | NO
Needs exploration or synthesis? YES | NO
Recommended route: v1 | v2 | blocked
Reason:
```

## Mixed Tasks

If a task contains both stable implementation and open-ended architecture:

- Use v2 for exploration or design only.
- Convert the accepted design into a v1 gated Task Packet before implementation.
- Do not let v2 child agents modify high-risk production code directly.
