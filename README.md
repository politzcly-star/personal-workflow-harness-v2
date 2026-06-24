# Production Harness Starter

一套开箱即用的 AI 开发工作流模板。

适合 Codex、Claude Code、Cursor、Gemini CLI 等智能体开发环境，新项目和已有项目都可以使用。

它解决的问题很简单：

- 什么时候直接改代码，什么时候先问清需求
- 哪些文件、配置、数据库、部署动作不能乱碰
- 修完或开发完以后必须怎么验证
- 什么时候该用 CodeGraph、文档查询、reviewer、debug skill
- 什么时候必须升级到正式交付流程

Production Harness Starter 把这些规则沉淀成轻量路线、护栏和检查清单。默认足够快，遇到高风险任务时自动变谨慎。

## 这是什么

这是一个面向生产使用的 Agent Harness Starter。

你可以把它复制到普通项目里，让 AI 编程智能体具备更清晰的任务路线、更安全的默认行为、更可靠的完成证据。

它不是 eval 平台、benchmark runner、dashboard、CI 系统，也不是部署工具。

核心思路：

```text
任务类型
> 路线选择
> 能力选择
> 限定范围内工作
> 完成前验证
> 轻量 trace
> 高风险时升级流程
```

## 它增加了什么能力

### Tool Orchestration

Harness 会告诉智能体什么时候该用什么能力：

- `rg`：默认快速搜索
- CodeGraph/MCP：跨文件定位、调用关系、影响范围分析
- `code-audit-fix`：bug 诊断和修复循环
- `openai-docs`：OpenAI / Codex / API 不确定时查官方文档
- reviewer child：边界、安全、权限、部署、数据库等高风险审查
- `lab-ai-delivery`：正式模块交付，包含 Task Packet、Evaluator、Gate Report

### Verification Loops

智能体不能只说“完成了”，必须先验证结果，或者说明为什么无法验证。

普通代码任务可以运行测试、build、lint、typecheck、截图检查或复现命令。

文档和策略任务也要验证，比如 JSON 解析、关键字覆盖、链接检查、`git diff --check`。

### Context And Memory

重要决策写进文件，不依赖聊天记忆。新的智能体可以按这个顺序恢复上下文：

```text
README
> AGENTS.md
> route policy
> task brief
> verification report
> handoff
```

### Guardrails

Harness 会把日常任务和危险任务分开。

数据库写入、生产部署、密钥、权限、破坏性操作、计费、认证、大范围重构，都需要更强证据，并且通常要升级到 reviewer 或 `lab-ai-delivery`。

### Observability

生产项目里的 trace 应该保持轻量，只记录有用信息：

- 选择了什么路线
- 用了哪些能力
- 改了哪些文件
- 做了哪些验证
- 跳过了哪些检查
- 还剩什么风险

benchmark 字段、对比指标、成本实验、观测平台实验，不应该默认进入普通生产项目，除非你正在明确做评估。

## 路线表

| 任务类型 | 默认路线 | 做什么 |
| --- | --- | --- |
| 小而明确的修改 | `lightweight_fix` | 直接限定范围修改，然后做 focused verification。 |
| bug / failing test | `audit_fix` | 复现、定位、修复、验证。 |
| 不熟悉的跨文件区域 | `structural_localization` | 先用 CodeGraph/MCP 理清结构，再改代码。 |
| 模糊的新功能 | `feature_discovery` | 先澄清需求、简短 brainstorm，再实现。 |
| 中型功能 | `feature_plan` | 先写短计划，再分步实现。 |
| API / 文档不确定 | `docs_assisted` | 先查官方文档，再做决策。 |
| 边界 / 安全 / 权限 | `review_gated` | 独立 reviewer 审查后再接受。 |
| 部署 / 配置 | `deployment_route` | 记录 pre-change evidence、rollback、dry-run、smoke plan。 |
| 数据库 / schema / migration | `database_route` | 做影响预览、backup/rollback、transaction/dry-run、row-count guard。 |
| 正式或高风险模块 | `lab_ai_delivery` | Task Packet、child、evaluator、Gate Report。 |

## 快速开始

1. 把这个仓库复制到你的项目里，或者把它作为工作流参考。
2. 让智能体先读 `README.md` 和 `AGENTS.md`。
3. 每个非简单任务先用 `templates/task-brief.md` 写一个短任务说明。
4. 让智能体根据 `docs/route-policy.md` 选择路线。
5. 用 `templates/verification-report.md` 记录完成前验证。
6. 高风险任务使用 `templates/risk-review.md`，必要时升级到 `lab-ai-delivery`。

可以这样对智能体说：

```text
使用这个 production harness。
先判断任务路线，选择最小但安全的流程。
完成前必须验证，风险升高时再升级流程。
```

## Hook 思路

如果你的智能体环境支持 hooks，可以参考这个生命周期：

```text
SessionStart  -> 注入 README、AGENTS.md、当前 task brief
PreToolUse    -> 拦截密钥读取、破坏性命令、不安全的生产/数据库动作
PostToolUse   -> 记录改动文件、验证结果和 warning
PreCompact    -> 写 handoff snapshot，方便下个智能体接手
Stop          -> 要求 verification report 或允许的未验证原因
```

Hooks 是可选的。即使没有 hooks，这套 harness 也可以作为纯 Markdown 规则使用。

## 不要从 eval 工作里复制什么

普通生产项目默认不要放这些东西：

- benchmark 分数
- 评估对比字段
- 成本实验
- 历史 benchmark 任务
- Langfuse credentials
- 很长的 trace payload
- 研究阶段 caveat

生产 trace 应该小而有用。

## 设计理念

好的 Agent 工作流不是“永远使用最大的流程”。

它应该是：

```text
默认足够快
风险升高时变谨慎
对验证诚实
对证据清楚
需要时能升级
```

目标不是拖慢智能体，而是让它知道什么时候该快、什么时候该问、什么时候该验证、什么时候该停。
