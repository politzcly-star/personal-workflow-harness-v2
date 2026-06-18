# v2 Architecture

v2 是一个本地轻量版 Agent-Native SDLC 设计。它不追求让 agent 完全自由，而是把自由放在明确的任务系统、权限边界、验证系统和最终人工判断之内。

v2 的 Phase 2 形态是 `goal-first / agent-orchestrated control plane`。它只用 markdown artifacts 表达任务控制面，让 Parent、Child、Evaluator 和 Human 围绕同一组证据工作；它不是 runner、CI、Docker、浏览器自动化、GitHub issue tracker integration 或生产执行系统。

## v1 与 v2 的关系

v1 是 Workflow-first Harness：流程更固定，边界控制更强，适合稳定自动化和高审计任务。

v2 是 Agent-Native Delivery Harness：任务目标清楚但执行路径不确定时，由 Parent Agent 组织子 agent 并行探索、实现、验证和汇总。

v2 不修改 v1，不削弱 v1 的边界价值。v1 保持 Workflow-first / 稳定边界型 Harness 定位。真实任务涉及高风险领域时，v2 必须退回 v1 gated delivery 或进入 human decision。

## 四层架构

### Task Control Plane

任务不是聊天记录，而是一组 artifacts。最小控制面由 `templates/task-state.md` 和 `templates/task-instance.md` 表达，记录任务状态、North Star、Human Signoff、active/completed children、Evaluator state、conflicts、next action 和 Evidence Index。

Phase 2 的控制面闭环由这些 artifacts 组成：Task Instance、Dispatch Matrix、Child Report、Evaluator Gate Card、Parent Synthesis 和 append-only Evidence Index。

### Agent Orchestration

Parent Agent 负责草拟目标、拆分工作、派发 child goals、读取报告和生成 synthesis。Child Agents 负责研究、实现、验证或审阅，并把测试结果写入 Child Report。Evaluator 是独立质量 gate，不是普通 child。

Parent 可以草拟 North Star、Dispatch Matrix、Child Goals，汇总 Child Reports，生成 Parent Synthesis，并准备 Human Acceptance Summary。Parent 不能自派为 Generator/Evaluator，Parent cannot assign itself。

Parent Synthesis 只能引用 Child Report 和 Evidence Index 中的 evidence refs；Parent 不得用聊天记忆替代 child verification 或测试证据。

### Guardrails / Containment

边界包括文件、运行时和外部副作用。Phase 1 不实现机械隔离，但必须在 artifacts 中显式记录 ports、databases、network、secrets、production、browser state 和 external paid actions。

### Evidence / Decision

Parent Synthesis 只能引用 evidence refs。Gate、review、human decision、scope change、conflict 都必须进入 Evidence Index。Evidence Index append-only，不能删除或重写旧证据。

Evaluator Gate Card 记录 `evidence-first`、`synthesis-comparison` 或 `conditional-followup` pass。Evaluator `No-Go`、未复验的 `Conditional Go` 条件和 Evidence Index 违规都保持阻断性。

## 权威顺序

```text
Human-signed North Star
> Task State
> Evaluator Decision
> Parent Synthesis
> Child Reports / Evidence Refs
> Chat Context
```

聊天上下文永远不是权威来源。如果 artifacts 之间冲突，任务进入 `blocked: authority-conflict`。Parent 不得用聊天记忆解释或覆盖 artifact 冲突。

## 角色

### Human

- 签署 North Star Contract。
- 批准扩大范围、高风险动作和最终接受。
- 裁定 Evaluator dispute、authority conflict、scope ambiguity。

### Parent Agent

- 草拟 North Star、Dispatch Matrix 和 Child Goals。
- 维护 Task State 和 Evidence Index。
- 合成 Child Reports。
- 准备 Human Acceptance Summary。

Parent 不能直接成为 Generator 或 Evaluator，不能自行覆盖 Evaluator 结论，不能自行扩大 Allowed Changes，不能未经 Human signoff 启动 implementation，不能直接修改受管业务文件，不能修改已签署的 North Star，不能删除或改写 Evidence Index 既有条目。

Parent 只能修改 v2 控制面 artifacts，例如 task-state、goal、dispatch、synthesis、handoff。

### Child Agents

- Planner：澄清方案、风险和拆分。
- Generator：在边界内实现。
- Researcher：探索代码、接口、文档或运行环境。
- Evaluator：独立质量 gate，拥有否决权。

### Evaluator

Evaluator 默认可读 Human-signed North Star、Task State、Dispatch Matrix、所有 Generator 修改文件、完整 diff、所有 Child Reports、verification outputs、relevant project facts、Evidence Index，并在第二阶段读取 Parent Synthesis draft。Evaluator 的 `No-Go` 阻断任务，Parent 只能记录 `Evaluator Dispute` 并进入 `blocked: needs-human-decision`，不能 reject 或覆盖 findings。

Evaluator 必须先做 `evidence-first`，再做 `synthesis-comparison`。`synthesis-comparison` 读取 Parent Synthesis draft 时，只把它作为 Parent 陈述，不作为事实来源。`Conditional Go` 必须触发第二次轻量 Evaluator pass，条件未复验前任务不得进入 `accepted`。

## Phase 1 Non-goals

- 不做 runner。
- 不接 CI。
- 不接远程 issue tracker。
- 不做 Docker 或浏览器自动化。
- 不做 metrics/eval/failure-case 模板。
- 不把 v1 迁移进 v2。

## Phase 2 Artifacts

- `templates/task-instance.md`：从 Task State 派生的可填写任务实例。
- `templates/dispatch-matrix.md`：child ownership、allowed read/change、stop conditions、report contract。
- `templates/child-report.md`：changed files、evidence、verification、exhaustion 的子线程输出。
- `templates/parent-synthesis.md`：只引用 evidence refs 的父线程汇总。
- `templates/evaluator-gate-card.md`：`evidence-first`、`synthesis-comparison`、`conditional-followup` 审阅记录。
- `examples/phase-2-paper-drill.md`：North Star -> Dispatch -> Child Report -> Evaluator -> Parent Synthesis -> Human Decision 的纸面闭环。
