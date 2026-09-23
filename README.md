# Personal Delivery Harness
**Current version: v6.2 — efficient daily work and portable model roles (2026-09-23).**

用于服务器部署、前后端修改和新需求开发。Human 提供目标及关键授权；Agent 负责理解、实现、测试、修复、集成和清晰汇报。

## 本版改变
- 日常 S1/S2 默认主任务直接完成：最小有效检查及差异复核，不例行开规划/双重审核、不无变化重复全量测试。
- 子任务首选 GPT-6 Sol medium 实施、Luna high 窄范围辅助；高风险仅审查实际变化边界。保留旧角色 ID 兼容引用，不保留旧模型配置副本。
- 首选模型不可用时使用当前渠道允许的替代或继承模型子任务；不自动切换登录、代理或根模型。
- 运行清单区分独立角色定义与旧式注册；静态配置不是实际调用证明。
- 恢复有价值的子任务并发和上下文隔离，不固定模型接力、不强制开满。
- 固定任务起始 Git 基线，网络失败只阻塞相关步骤。
- 区分授权合同与进度摘要；摘要损坏可在原范围内恢复。
- 本地测试证据绑定源码内容与环境，避免阶段切换导致无变化重测。
- 报告已验证结果、当前工作、并行任务、阻塞及下一节点。
- 加入实际运行能力的只读盘点与外部签名请求传递入口，不把配置文件存在当作接通。
- 新项目完整安装当前活动政策；升级保留项目自定义内容、业务合同与 API/MCP 配置。

## 入口与按需政策
AGENTS.md 是精简的当前契约，不要求每个任务读完整仓库。
- docs/parent-child-execution.md / docs/model-routing-policy.md：调度与运行时角色。
- docs/context-compression-policy.md：上下文控制与恢复。
- docs/git-network-policy.md：基线与网络退避。
- docs/reporting-policy.md / docs/cost-efficiency-policy.md：进度与整任务性价比。
- docs/runtime-readiness-policy.md / docs/verification-and-guardrails.md：运行能力与授权。
- docs/install-hooks-upgrade.md：明确授权后的原位迁移。

## 检查
```powershell
.\scripts\harness-self-test.ps1
python -B scripts/runtime-inspect.py
```
需要 PowerShell、Python 3.11+、Git；隔离签名测试使用 cryptography。测试只操作临时夹具，不调用付费模型、不连接生产。静态检查/夹具通过不证明客户端实际调用 Hook、角色路由、真实发布接通或速度/费用改善。

## 生效边界
此仓库是规范源，不自动覆盖业务项目或全局技能。项目迁移必须明确授权，预检后原位替换；保留项目源目录、Git/生产合同和自定义规则。用户批准的有界委派在适用权限内执行，不把复制文件当新授权。已有运行任务不会因文件更新自动刷新上下文。
仅保留一套当前活动工作流；不生成旧版备份。历史 tasks/audits/验证报告与 Git 历史是证据，不是活动规则，保留。不得自动 commit/push、修改 provider/auth/MCP 或安装 harness-upgrade 技能/自动任务。
真实提速与成本结论需要后续正常任务的可比数据；本版不预先宣称更快更便宜。
