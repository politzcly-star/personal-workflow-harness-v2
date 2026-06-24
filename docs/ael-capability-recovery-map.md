# AEL Capability Recovery Map

This file records what v2.1 migrated from AEL P66-P78, what stays optional, and what is explicitly not migrated.

## Source Documents Reviewed

- `D:\Agent 效率测试平台项目\docs\workflow-effectiveness-audit.md` (P66)
- `D:\Agent 效率测试平台项目\docs\production-harness-trace-contract.md` (P67)
- `D:\Agent 效率测试平台项目\docs\lightweight-workflow-router.md` (P68)
- `D:\Agent 效率测试平台项目\docs\production-harness-capability-proof-report.md` (P70)
- `D:\Agent 效率测试平台项目\docs\production-harness-layering.md` (P71)
- `D:\Agent 效率测试平台项目\docs\production-capability-routing.md` (P73)
- `D:\Agent 效率测试平台项目\docs\production-harness-sample-proof-report.md` (P74)
- `D:\Agent 效率测试平台项目\docs\feature-development-route.md` (P75)
- `D:\Agent 效率测试平台项目\docs\production-config-deployment-route.md` (P76)
- `D:\Agent 效率测试平台项目\docs\database-schema-migration-route.md` (P77)
- `D:\Agent 效率测试平台项目\docs\route-evaluation-proof-report.md` (P78)

## Migrated Into v2.1 Runtime

| AEL Capability | v2.1 Location | Notes |
| --- | --- | --- |
| Four-tier route model: lightweight, medium, review_gated, full_formal_gate. | `README.md`, `AGENTS.md`, `docs/route-policy.md` | Mapped to v2 route names. |
| Route-first operating rule. | `AGENTS.md`, `docs/route-policy.md` | Required before edits. |
| Default `rg`, verification, scope guard. | `AGENTS.md`, `docs/capability-policy.md` | Daily default. |
| CodeGraph/MCP for structural localization. | `docs/capability-policy.md`, `templates/project-profile.md` | Medium+ and new project onboarding. |
| `code-audit-fix` triggers. | `AGENTS.md`, `docs/capability-policy.md` | Bugs, verification failure, repair loop, regression. |
| `openai-docs` trigger rules. | `docs/capability-policy.md` | OpenAI/Codex/API/SDK uncertainty only. |
| Reviewer high-risk-only policy. | `docs/capability-policy.md`, `docs/verification-and-guardrails.md` | Read-only by default. |
| Browser/UI not default-on. | `README.md`, `docs/capability-policy.md` | Dedicated profile or explicit approval. |
| Feature discovery and feature plan. | `docs/route-policy.md`, `templates/feature-plan.md` | Lightweight brainstorm and short plan only. |
| Deployment route checks. | `docs/route-policy.md`, `templates/deployment-checklist.md` | Pre-change, rollback, dry-run, smoke, operator boundary. |
| Database route checks. | `docs/route-policy.md`, `templates/database-checklist.md` | Environment identity, SELECT preview, row-count, rollback, destructive guard. |
| Evidence redaction and compact reporting. | `docs/verification-and-guardrails.md`, `templates/verification-report.md` | Summaries and refs, no raw secrets. |
| Parent-router / child-executor. | `README.md`, `AGENTS.md`, `templates/child-task.md`, `templates/child-report.md` | Default for non trivial work. |
| Hook lifecycle as guardrail layer. | `.codex/hooks.json`, `.codex/hooks/harness-hook.ps1`, `docs/install-hooks-upgrade.md` | Hook-ready; local trust required. |

## Kept Optional Or On-Demand

| Capability | v2.1 Status | Boundary |
| --- | --- | --- |
| Local trace style fields | Optional lightweight evidence fields in templates. | No large trace payload. |
| Langfuse upload | Optional observability adapter only. | No credentials, no default dependency. |
| Reviewer | High-risk-only. | Not used for tiny fixes. |
| Browser/UI automation | On-demand or eval/manual only. | No personal profile by default. |
| Full `lab-ai-delivery` | Retained for formal/high-risk delivery. | Not daily default. |

## Explicitly Not Migrated

v2.1 does not migrate:

- AEL benchmark runner;
- marked calibration;
- P58-P63 external proof platform heavy flow;
- baseline/enhanced per-task comparison;
- Langfuse credentials;
- token cost experiment fields;
- large trace payloads;
- complete Gate Report as default daily flow;
- full harness-core state machine;
- Docker/VM/Langfuse platform deployment logic.

## Evidence Limits

The AEL proof set is useful but narrow:

- CodeGraph/MCP improved structural localization on controlled tasks; it does not prove correctness or broad productivity uplift.
- `code-audit-fix` improved diagnosis on controlled verification failures; it does not guarantee repair.
- reviewer improved high-risk accept/reject quality in controlled boundary work; it should not become default overhead.
- `openai-docs` improved current Codex/OpenAI specificity; it is not general search.
- P78 route proof improved route-quality evidence for feature/deployment/database scenarios; it does not prove live deployment or database safety.

## v2.1 Product Decision

v2.1 is the daily Codex production harness:

```text
runtime harness + on-demand capabilities + hook/script guardrails
```

It intentionally avoids becoming the AEL test platform.
