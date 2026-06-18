# 个人工作流 v2 - Agent-Native Delivery Harness

本仓库用于设计 **Agent-Native Delivery Harness**：让 agent 自主组织计划、拆分、并行执行和汇总，但由人类、Evaluator 与 artifacts 共同约束它的方向和边界。

v2 不替代 v1。`D:\个人工作流` 仍保留为 Workflow-first / 稳定边界型 Harness，适合固定流程自动化、明确 bugfix、强审计任务和低创造力高稳定性场景。v2 只探索任务目标清楚但路径不确定、需要多 agent 编排和父线程合成的工作方式。

v2 是 `goal-first / agent-orchestrated control plane`：它把 North Star、Dispatch Matrix、Child Report、Evaluator Gate Card、Parent Synthesis 和 Evidence Index 组织成可审阅的控制面。Phase 2 仍然是纯文档/模板层最小闭环，不实现 runner、CI、Docker、浏览器自动化、GitHub issue tracker integration、生产系统操作或任何自动化执行框架。

## Phase 1 定位

Phase 1 只做架构和核心模板：

- 不实现 runner。
- 不接 CI。
- 不接 GitHub issue tracker。
- 不做 eval infra。
- 不做 Docker、浏览器自动化或生产环境操作。
- 不迁移 v1 文件。

## Phase 2 定位

Phase 2 增加“可执行任务控制面最小闭环”的纸面 artifacts：

- Task Instance：从 `templates/task-state.md` 派生可填写任务实例。
- Dispatch Matrix：定义 child ownership、allowed read/change、stop conditions、report contract。
- Child Report：标准化子线程输出，包含 changed files、evidence、verification、exhaustion。
- Parent Synthesis：标准化父线程汇总，只引用 evidence refs。
- Evaluator Gate Card：标准化 `evidence-first`、`synthesis-comparison`、`conditional-followup` 三类审阅记录。

这些模板只定义人工和 agent 可填写的控制面，不调度线程、不运行命令、不接外部系统。

## Documentation Navigation

v2 is a markdown control plane, not runner/CI/automation. Use these links to reload the current authority chain and examples before changing the harness.

### Start Here

- [README](README.md): repository orientation, phase boundaries, authority order, and non-bypass rules.
- [v1/v2 Routing](docs/route-v2.md): when to use v2 and when to fall back to v1.
- [Architecture](docs/architecture.md): roles, layers, and artifact authority.

### Architecture &amp; Protocol

- [Parent Agent Protocol](docs/parent-agent-protocol.md): Parent duties, schema, and Evaluator constraints.
- [Context Survival](docs/context-survival.md): handoff, compression, recovery, and conflict handling.
- [Phase 5 Gate Hardening Guide](docs/phase-5-gate-hardening-guide.md): parent responses to Conditional Go, No-Go, authority conflict, and child exhaustion.
- [Phase 6 Dispatch Discipline Guide](docs/phase-6-dispatch-discipline-guide.md): when Parent may control artifacts and when Generator/Evaluator work must be delegated.
- [Phase 7 Context Handoff Guide](docs/phase-7-context-handoff-guide.md): context compression, reload paths, and handoff recovery without chat memory authority.
- [Phase 8 Evaluator Dispute Guide](docs/phase-8-evaluator-dispute-guide.md): evaluator dispute, No-Go blocking, and human-decision recovery paths.
- [Phase 9 Evidence Integrity Guide](docs/phase-9-evidence-integrity-guide.md): append-only Evidence Index audit, scope-change records, and evidence recovery blockers.

### Templates

- [Task State](templates/task-state.md)
- [Task Instance](templates/task-instance.md)
- [Dispatch Matrix](templates/dispatch-matrix.md)
- [Child Report](templates/child-report.md)
- [Evaluator Gate Card](templates/evaluator-gate-card.md)
- [Parent Synthesis](templates/parent-synthesis.md)

### Examples &amp; Rehearsals

- [Phase 2 Paper Drill](examples/phase-2-paper-drill.md)
- [Phase 3 Task Instance](examples/phase-3-docs-index-rehearsal/task-instance.md)
- [Phase 3 Dispatch Matrix](examples/phase-3-docs-index-rehearsal/dispatch-matrix.md)
- [Phase 3 Research Child Report](examples/phase-3-docs-index-rehearsal/child-report-research.md)
- [Phase 3 Proposal Child Report](examples/phase-3-docs-index-rehearsal/child-report-proposal.md)
- [Phase 3 Evaluator Gate Card](examples/phase-3-docs-index-rehearsal/evaluator-gate-card.md)
- [Phase 3 Parent Synthesis](examples/phase-3-docs-index-rehearsal/parent-synthesis.md)
- [Phase 3 Human Decision](examples/phase-3-docs-index-rehearsal/human-decision.md)
- [Phase 4 Task Instance](examples/phase-4-docs-index-implementation/task-instance.md)
- [Phase 4 Dispatch Matrix](examples/phase-4-docs-index-implementation/dispatch-matrix.md)
- [Phase 4 Docs Edit Child Report](examples/phase-4-docs-index-implementation/child-report-docs-edit.md)
- [Phase 4 Evaluator Gate Card](examples/phase-4-docs-index-implementation/evaluator-gate-card.md)
- [Phase 4 Parent Synthesis](examples/phase-4-docs-index-implementation/parent-synthesis.md)
- [Phase 4 Human Decision](examples/phase-4-docs-index-implementation/human-decision.md)
- [Phase 5 Task Instance](examples/phase-5-gate-hardening-drill/task-instance.md)
- [Phase 5 Dispatch Matrix](examples/phase-5-gate-hardening-drill/dispatch-matrix.md)
- [Phase 5 Conditional Child Report](examples/phase-5-gate-hardening-drill/child-report-conditional-followup.md)
- [Phase 5 No-Go Child Report](examples/phase-5-gate-hardening-drill/child-report-no-go.md)
- [Phase 5 Authority Conflict Child Report](examples/phase-5-gate-hardening-drill/child-report-authority-conflict.md)
- [Phase 5 Exhausted Child Report](examples/phase-5-gate-hardening-drill/child-report-exhausted.md)
- [Phase 5 Evaluator Gate Card](examples/phase-5-gate-hardening-drill/evaluator-gate-card.md)
- [Phase 5 Parent Synthesis](examples/phase-5-gate-hardening-drill/parent-synthesis.md)
- [Phase 5 Human Decision](examples/phase-5-gate-hardening-drill/human-decision.md)
- [Phase 6 Task Instance](examples/phase-6-dispatch-discipline-rehearsal/task-instance.md)
- [Phase 6 Dispatch Matrix](examples/phase-6-dispatch-discipline-rehearsal/dispatch-matrix.md)
- [Phase 6 Dispatch Discipline Child Report](examples/phase-6-dispatch-discipline-rehearsal/child-report-dispatch-discipline.md)
- [Phase 6 Evaluator Gate Card](examples/phase-6-dispatch-discipline-rehearsal/evaluator-gate-card.md)
- [Phase 6 Parent Synthesis](examples/phase-6-dispatch-discipline-rehearsal/parent-synthesis.md)
- [Phase 6 Human Decision](examples/phase-6-dispatch-discipline-rehearsal/human-decision.md)
- [Phase 7 Task Instance](examples/phase-7-context-handoff-rehearsal/task-instance.md)
- [Phase 7 Dispatch Matrix](examples/phase-7-context-handoff-rehearsal/dispatch-matrix.md)
- [Phase 7 Context Handoff Child Report](examples/phase-7-context-handoff-rehearsal/child-report-context-handoff.md)
- [Phase 7 Context Compression Snapshot](examples/phase-7-context-handoff-rehearsal/context-compression-snapshot.md)
- [Phase 7 Handoff Recovery Record](examples/phase-7-context-handoff-rehearsal/handoff-recovery-record.md)
- [Phase 7 Evaluator Gate Card](examples/phase-7-context-handoff-rehearsal/evaluator-gate-card.md)
- [Phase 7 Parent Synthesis](examples/phase-7-context-handoff-rehearsal/parent-synthesis.md)
- [Phase 7 Human Decision](examples/phase-7-context-handoff-rehearsal/human-decision.md)
- [Phase 8 Task Instance](examples/phase-8-evaluator-dispute-recovery-drill/task-instance.md)
- [Phase 8 Dispatch Matrix](examples/phase-8-evaluator-dispute-recovery-drill/dispatch-matrix.md)
- [Phase 8 Evaluator Dispute Child Report](examples/phase-8-evaluator-dispute-recovery-drill/child-report-evaluator-dispute.md)
- [Phase 8 Evaluator Gate Card](examples/phase-8-evaluator-dispute-recovery-drill/evaluator-gate-card.md)
- [Phase 8 Evaluator Dispute Record](examples/phase-8-evaluator-dispute-recovery-drill/evaluator-dispute-record.md)
- [Phase 8 Human Decision Recovery Record](examples/phase-8-evaluator-dispute-recovery-drill/human-decision-recovery-record.md)
- [Phase 8 Parent Synthesis](examples/phase-8-evaluator-dispute-recovery-drill/parent-synthesis.md)
- [Phase 8 Human Decision](examples/phase-8-evaluator-dispute-recovery-drill/human-decision.md)
- [Phase 9 Task Instance](examples/phase-9-evidence-integrity-drill/task-instance.md)
- [Phase 9 Dispatch Matrix](examples/phase-9-evidence-integrity-drill/dispatch-matrix.md)
- [Phase 9 Evidence Integrity Child Report](examples/phase-9-evidence-integrity-drill/child-report-evidence-integrity.md)
- [Phase 9 Evaluator Gate Card](examples/phase-9-evidence-integrity-drill/evaluator-gate-card.md)
- [Phase 9 Evidence Audit Record](examples/phase-9-evidence-integrity-drill/evidence-audit-record.md)
- [Phase 9 Scope Change Record](examples/phase-9-evidence-integrity-drill/scope-change-record.md)
- [Phase 9 Parent Synthesis](examples/phase-9-evidence-integrity-drill/parent-synthesis.md)
- [Phase 9 Human Decision](examples/phase-9-evidence-integrity-drill/human-decision.md)

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
- `templates/task-state.md`：Phase 1 核心模板，内嵌 North Star、child、evaluator、evidence 结构。
- `templates/task-instance.md`：Phase 2 可填写任务实例模板。
- `templates/dispatch-matrix.md`：Phase 2 派发矩阵模板。
- `templates/child-report.md`：Phase 2 子线程报告模板。
- `templates/parent-synthesis.md`：Phase 2 父线程汇总模板。
- `templates/evaluator-gate-card.md`：Phase 2 Evaluator gate 记录模板。
- `examples/phase-2-paper-drill.md`：低风险纸面演练样例。

## 最小使用流程

1. 判断任务是否适合 v2，路由不确定时默认退回 v1 或 blocked。
2. Parent 草拟 North Star Contract。
3. Human 明确签署 North Star。
4. Parent 生成 Dispatch Matrix 和 Child Goals。
5. Child Agents 按角色执行并提交 Child Report，测试结果必须写入 report。
6. Evaluator 先做 `evidence-first` pass，再做 `synthesis-comparison` pass。
7. Parent 只能基于 evidence refs 合成 Parent Synthesis，不得用聊天记忆替代验证证据。
8. Human 根据 artifacts 做最终接受、调整或拒绝。

## 不可绕过规则

- Parent 不得把自己列为 Generator 或 Evaluator。
- Parent cannot assign itself.
- Parent 不得直接修改受管业务文件，不能未经 Human signoff 启动 implementation。
- Parent 不得 reject Evaluator 的 `No-Go`。
- `Conditional Go` 必须经过第二次轻量 Evaluator pass。
- Evidence Index 必须是 append-only，只能追加，不能删除或改写旧条目。
- Child 报告若触发停止条件或耗尽可行动作，必须写入 `child-report: exhausted`。
- 未 Human signoff 的 North Star 不能启动 implementation。
- 高风险任务默认退回 v1 gated delivery。
