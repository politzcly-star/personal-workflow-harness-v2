# Production Harness Starter

一套开箱即用的 AI 开发工作流模板。

适合 Codex、Claude Code、Cursor、Gemini CLI 等智能体开发环境。新项目和已有项目都可以使用。

它解决的问题很简单：

- 什么时候直接改代码，什么时候先问清需求
- 哪些文件、配置、数据库、部署动作不能乱碰
- 修完或开发完以后必须怎么验证
- 什么时候该用 CodeGraph、docs、reviewer、debug skill
- 什么时候必须升级到正式交付流程

Production Harness Starter 把这些规则沉淀成轻量路线、护栏和检查清单。默认足够快，遇到高风险任务时自动变谨慎。

## What This Is

This repo is a production-ready agent harness starter. It is a small control layer you copy into a project so an AI coding agent can work with better routing, safer defaults, and clearer completion evidence.

It is not an eval platform, benchmark runner, dashboard, CI system, or deployment tool.

The core idea:

```text
Task type
> route
> capability choice
> scoped work
> verification-before-completion
> lightweight trace
> high-risk escalation when needed
```

## What It Adds

### Tool Orchestration

The harness tells the agent when to use each capability:

- `rg`: default fast search
- CodeGraph/MCP: cross-file localization and impact understanding
- `code-audit-fix`: bug diagnosis and repair loop
- `openai-docs`: current OpenAI/Codex/API uncertainty
- reviewer child: boundary, security, permission, deployment, or database risk
- `lab-ai-delivery`: formal module delivery with Task Packet, evaluator, Gate Report

### Verification Loops

The agent should not say "done" until it has verified the relevant behavior, or has recorded why verification could not be run.

For normal code this may be tests, build, lint, typecheck, screenshot, or focused reproduction.

For docs and policy it may be JSON parse, required literal coverage, link checks, and `git diff --check`.

### Context And Memory

Important decisions live in files, not chat memory. A new agent can reload:

```text
README
> AGENTS.md
> route policy
> task brief
> verification report
> handoff
```

### Guardrails

The harness separates everyday work from dangerous work.

Database writes, production deployment, secrets, permissions, destructive changes, billing, auth, and broad refactors require stronger evidence and often reviewer or `lab-ai-delivery` escalation.

### Observability

Production use should keep trace records lightweight. Record route, capabilities used, verification, changed files, skipped checks, and residual risk.

Detailed benchmark fields, comparison metrics, cost studies, and observability experiments belong outside normal project work unless you are explicitly running an evaluation.

## Routes

| Task type | Default route | What changes |
| --- | --- | --- |
| Small clear edit | `lightweight_fix` | Direct scoped edit plus focused verification. |
| Bug / failing test | `audit_fix` | Reproduce, localize, fix, verify. |
| Cross-file unknown area | `structural_localization` | Use CodeGraph/MCP before editing. |
| Vague new feature | `feature_discovery` | Ask/assume, brainstorm briefly, then implement. |
| Mid-size feature | `feature_plan` | Short plan before implementation. |
| API/docs uncertainty | `docs_assisted` | Use official docs before deciding. |
| Boundary/security/permission | `review_gated` | Independent reviewer before acceptance. |
| Deployment/config | `deployment_route` | Pre-change evidence, rollback, dry-run, smoke plan. |
| Database/schema/migration | `database_route` | Impact preview, backup/rollback, transaction/dry-run, row-count guards. |
| Formal/high-risk module | `lab_ai_delivery` | Task Packet, child, evaluator, Gate Report. |

## Quick Start

1. Copy this repo into a project or keep it as a workflow reference.
2. Ask the agent to read `README.md` and `AGENTS.md`.
3. For each task, create a short task brief from `templates/task-brief.md`.
4. Let the agent choose a route from `docs/route-policy.md`.
5. Require completion evidence from `templates/verification-report.md`.
6. For risky work, use `templates/risk-review.md` or escalate to `lab-ai-delivery`.

Example prompt:

```text
Use this production harness. Route the task first, keep the smallest safe workflow,
verify before completion, and escalate only if the risk triggers require it.
```

## Hook Ideas

If your agent environment supports hooks, use these lifecycle ideas:

```text
SessionStart  -> inject README, AGENTS.md, current task brief
PreToolUse    -> block secrets, destructive commands, unsafe production/db actions
PostToolUse   -> record changed files, verification, and warnings
PreCompact    -> write a handoff snapshot
Stop          -> require verification report or allowed not-verified reason
```

Hooks are optional. The harness still works as plain Markdown rules.

## What Not To Copy From Eval Work

Do not put these in normal production projects by default:

- benchmark scores
- evaluation comparison fields
- cost experiments
- marked task histories
- Langfuse credentials
- long trace payloads
- research-only caveats

Keep production traces small and useful.

## Philosophy

Good agent workflow is not "always use the biggest process".

It is:

```text
fast by default
cautious when risk rises
honest about verification
clear about evidence
able to escalate when needed
```

The goal is not to slow the agent down. The goal is to help it know when to move fast, when to ask, when to verify, and when to stop.
