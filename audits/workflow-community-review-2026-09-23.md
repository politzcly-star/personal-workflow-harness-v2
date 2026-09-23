# 工作流与 GPT-6 Sol / Luna 调研备忘

日期：2026-09-23。状态：建议保留，未实施模型迁移。

## 范围与边界

用户要求保留上一轮建议，并参考官方说明、社区科技博客。仅新增本备忘；不改角色、AGENTS、Skills、登录、代理、业务项目或生产；不执行付费探针、自动化、提交或推送。公开网页采用有限样本，不代表整个开发圈的统计共识。

## 保留上一轮本地评估

- v6.1 的按风险执行、最小必要上下文、独立审查和区分实现/验证/部署等原则继续保留。
- WeToken 历史中独立子任务发现 SQLite 兼容性回归，实施与复审形成闭环。抽查创建请求为旧 Luna 一次、Astra 四次；那次 Luna 执行59次命令后被中断，无最终报告。请求模型不证明代理后端身份，样本也不能量化节约。
- 实际规范源码 `D:\jinsha\git-migration\20260818-dual-private-baseline\wetoken-source-r2\AGENTS.md` 仍保留 v2.1 的强制父路由/子执行条款；AI直聘已采用 v6.1。源工作流更新不意味着每个业务源码目录均已同步。
- 四个源角色仍绑定旧 GPT-5.6 系列。运行清单主要查旧式注册，不能把未注册等同于当前客户端无法发现独立角色文件。
- 后续候选范围：新角色映射、有限降级规则、运行检查与离线测试、业务目录 dry-run；保持既有 Skill 正文和项目专属安全契约。

上述为上一轮观察留档，本轮未重新检查业务状态。

## 官方依据与适用方式

1. [模型选择](https://developers.openai.com/api/docs/guides/model-selection)：按质量需求、频率、延迟和输出用途选择模型与档位，而不是只比较 token 单价。对我们：按完整验收结果评价路由，账单未知就保持未知。
2. [Codex 子智能体](https://learn.chatgpt.com/docs/agent-configuration/subagents)：一般 Codex 工作从 Sol 开始；Luna 适合窄范围、清楚、可重复的任务。显式子任务配置起点为 Sol medium、Luna high。读密集任务适合先并行，写密集任务需要控制冲突。对我们：少量独立子任务，不固定多层接力；这些档位是起点，不是所有任务的最佳值。
3. [Skills 与提示词复盘，2026-09-11](https://developers.openai.com/blog/rethinking-skills-and-prompts-for-gpt-6-astra)：简短而准确的触发描述、按需加载资料，避免把过度过程指导施加给所有模型；不同模型可能需要不同详细程度。对我们：保留已经完成的描述精简，在委派消息补足具体边界，不为 Luna 把全局 AGENTS 膨胀成长清单。
4. [GPT-6 使用指南](https://developers.openai.com/api/docs/guides/latest-model)：工具推理使用 Responses；Sol/Luna 的 Chat Completions 函数调用限 none。对我们：代理模型目录可见不证明工具协议兼容；模型名、协议、档位、实际调用应分别记录。指南中的部分提示针对 Astra 观察，不能宣称已验证同样适用于 Sol/Luna。

## 社区信号及证据强度

- [Ravi：How I route work in Codex，2026-09-17](https://ravi.sh/writing/how-i-route-work-in-codex/)：第一手个人实践，Astra 协调、旧5.6 Sol集成、旧Luna做窄任务。作者自述用量下降，但没有同任务对照。借鉴职责划分与带证据升级，不照搬固定三层接力、max档位或定时唤醒。
- [Vercel 上线公告，2026-09-22](https://vercel.com/changelog/gpt-6-sol-and-luna-now-available-on-ai-gateway)：其网关已提供两模型；这是该平台的接入事实与产品定位，不是独立效率评测，也不证明用户当前代理兼容。
- [Reddit：Give Luna 6 a shot，本日检索](https://www.reddit.com/r/codex/comments/1wnsg05/give_luna_6_a_shot/)：作者在非Codex harness中报告Luna编排体验良好，评论同时报告工具超时单位错误。都是个体初期经验，不能推广到我们的环境；提醒评估工具正确性，而非只看文字答案。
- [Reddit：GPT-6 Sol in Model Selector，本日检索](https://www.reddit.com/r/codex/comments/1wngg9r/gpt6_sol_in_model_selector/)：有用户报告模型可见但请求失败。仅作为发布初期可用性信号，不据此判断官方当前普遍不可用，也不外推到指定第三方代理。
- [Supercode，2026-09-23](https://supercode.sh/en/blog/guides/gpt-6-sol-luna-codex)：定向搜索可读文章内容，但原站打开失败；含发布数据综述与产品推广，未见同仓库对照。不作为性能或收益结论依据。

## 对当前工作流的判断（综合推断）

方向与抽查的官方实践和开发者案例一致：简短入口、职责分离、局部上下文、可验证交付。没有代表性样本，不能声称领先多少开发者。主要缺口在规则覆盖一致性、实际路由可见性、代理兼容，以及总交付成本的观察，不在缺少更多 Skills 或更多子任务。

## 待后续选择的最小方案

| 工作 | 候选模型与档位 | 范围 |
| --- | --- | --- |
| 正常开发、集成、诊断 | GPT-6 Sol medium | 根模型仍由用户选择，不自动切换 |
| 检索、日志归类、测试证据、明确小修 | GPT-6 Luna high 起步 | 清楚输入、范围、输出、验收和停止条件 |
| 支付/权限/跨模块独立审查 | GPT-6 Sol high，必要时用户所选 Astra | 不把便宜审核当作高风险充分保障 |
| 模型或角色不支持 | 当前渠道获授权的替代或继承模型子任务 | 不切换认证/provider；整体子任务不可用时保留审查缺口 |

补充建议：

- 角色命名逐步与职责对应（如 scoped_worker、reviewer），模型映射单独维护；不为了改名制造一次全局迁移。
- 每个 Luna 委派只描述目标、允许范围、验收证据和停止/升级条件；不要交付“把整个项目审完”这种开放任务。
- 工具返回相同失败且无新证据时，不通过反复换模型继续撞错。升级应携带失败命令、结果、已排除原因和未决问题。
- 在接下来的正常任务中被动记录：渠道类别、请求模型/档位、是否完成验收、返工、人工干预、耗时和可获得用量。优先利用现有日志，不引入额外监控或付费A/B。
- 首先修复实际业务目录的旧规则漂移，再实施源角色更新与降级；执行迁移前 dry-run，并保留业务契约。

本备忘不构成部署授权、模型可用性证明或迁移执行记录。
