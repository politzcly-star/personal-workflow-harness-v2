# 个人工作流 v2 - Agent-Native Delivery Harness

本仓库用于设计 **Agent-Native Delivery Harness**：让 agent 自主组织计划、拆分、并行执行和汇总，但由人类、Evaluator 与 artifacts 共同约束它的方向和边界。

v2 不替代 v1。`D:\个人工作流` 仍保留为 Workflow-first / 稳定边界型 Harness，适合固定流程自动化、明确 bugfix、强审计任务和低创造力高稳定性场景。v2 只探索任务目标清楚但路径不确定、需要多 agent 编排和父线程合成的工作方式。

## Phase 1 定位

Phase 1 只做架构和核心模板：

- 不实现 runner。
- 不接 CI。
- 不接 GitHub issue tracker。
- 不做 eval infra。
- 不做 Docker、浏览器自动化或生产环境操作。
- 不迁移 v1 文件。

## 权威顺序

```text
Human-signed North Star
> Task State
> Evaluator Decision
> Parent Synthesis
> Child Reports / Evidence Refs
> Chat Context
```

聊天上下文永远不是权威来源。恢复、审阅和继续执行时必须回到 artifacts。

Human-signed North Star 是最高目标源。North Star 可由 Parent 草拟，但只有 Human 签署后才生效；缺少 Human signoff 时，任务状态必须保持 `proposed` 或 `blocked: needs-human-signoff`。

## 核心文件

- `docs/architecture.md`：四层架构、角色、权威关系。
- `docs/parent-agent-protocol.md`：Parent Agent 协议、schema、Evaluator 规则。
- `docs/context-survival.md`：上下文压缩、handoff、恢复和冲突处理。
- `docs/route-v2.md`：v1/v2 路由规则和 fallback。
- `templates/task-state.md`：Phase 1 唯一核心模板，内嵌 North Star、child、evaluator、evidence 结构。

## 最小使用流程

1. 判断任务是否适合 v2，路由不确定时默认退回 v1 或 blocked。
2. Parent 草拟 North Star Contract。
3. Human 明确签署 North Star。
4. Parent 生成 Dispatch Matrix 和 Child Goals。
5. Child Agents 按角色执行并提交报告。
6. Evaluator 先做 `evidence-first` pass，再做 `synthesis-comparison` pass。
7. Parent 只能基于 evidence refs 合成结果。
8. Human 根据 artifacts 做最终接受、调整或拒绝。

## 不可绕过规则

- Parent 不得把自己列为 Generator 或 Evaluator。
- Parent cannot assign itself.
- Parent 不得直接修改受管业务文件，不能未经 Human signoff 启动 implementation。
- Parent 不得 reject Evaluator 的 `No-Go`。
- `Conditional Go` 必须经过第二次轻量 Evaluator pass。
- Evidence Index 必须是 append-only，只能追加，不能删除或改写旧条目。
- 未 Human signoff 的 North Star 不能启动 implementation。
- 高风险任务默认退回 v1 gated delivery。
