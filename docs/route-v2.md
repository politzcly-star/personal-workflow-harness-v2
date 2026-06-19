# v1 / v2 Routing

Use this file before starting any task. v2 is powerful, but it is not the safe
default for every kind of work.

## Use v1

Use the v1 workflow-first harness when the task is:

- fixed-process automation
- known bugfix
- low-creativity, high-stability work
- custom webpage operation agent
- strong audit / strong boundary work
- auth, permissions, secrets, billing, database, migration, quota, production,
  or destructive-write related
- narrow enough for a gated Task Packet, Scope Gate, Local Gate, and Gate Report

When in doubt on high-risk work, choose v1 or block for Human decision.

## Use v2

Use v2 when:

- the goal is clear but the path is uncertain
- exploration, decomposition, or parallel research is valuable
- multiple agents can improve speed or quality
- Parent synthesis across multiple reports is useful
- the work is architecture, migration planning, option comparison, or complex
  discovery before implementation

v2 may be used only when the task can define:

- North Star
- blast radius
- child ownership
- allowed reads and allowed changes
- stop conditions
- acceptance criteria
- verification evidence

## Do Not Use v2 Directly

Do not start v2 implementation when:

- North Star required fields cannot be defined
- blast radius cannot be bounded
- acceptance criteria cannot be verified
- child ownership cannot be split
- the task is high-risk and lacks a v1 gated Task Packet
- the route is uncertain

Fallback:

```text
do not use v2 directly
> use v1 gated delivery
> or blocked: needs-human-decision
```

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

If a task includes both open-ended design and stable implementation:

- Use v2 for exploration or design.
- Convert accepted design into a v1 gated Task Packet before high-risk
  implementation.
- Do not let v2 child agents modify high-risk production code directly.
