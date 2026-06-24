# Capability Policy

Capabilities are tools the agent may use to improve route quality. Select them by trigger, not by habit.

## Default Capability Map

| Capability | Default | Use For | Guardrail |
| --- | --- | --- | --- |
| `rg` | On | Fast local search, config lookup, docs lookup, literal coverage. | Prefer focused searches. Avoid ignored secret/data folders. |
| verification | On | Tests, build, lint, parse, screenshot, docs coverage, smoke evidence. | Required before completion unless a narrow not-verified reason is recorded. |
| scope_guard | On | Changed files, generated artifacts, secrets, profile/runtime drift. | Run before final report and before commit. |
| CodeGraph/MCP | Medium+ and on demand | Cross-file relationships, callers/callees, route ownership, impact radius, new project onboarding. | Context only; not proof of correctness. |
| `code-audit-fix` | On demand | Bugs, failing tests, verification failures, regressions, repair loops, suspicious behavior. | Verify locally before completion. |
| `openai-docs` | On demand | OpenAI / Codex / API / SDK / current docs uncertainty. | Official docs only; not a general web search replacement. |
| reviewer child | High-risk only | Boundary, security, permissions, data export, deployment/database risk, API contract, hidden acceptance. | Read-only by default; scoped packet only. |
| browser/UI | On demand or eval/manual only | UI inspection, screenshot, DOM, local app reproduction when needed. | Use dedicated profile; avoid credential leakage and personal logged-in state. |
| `lab-ai-delivery` | Formal only | Task Packet, evaluator, Gate Report, audit-grade delivery. | Do not use for every small task. |

## Capability Trigger Rules

Use `rg` when:

- searching known strings, file names, command names, config keys, docs literals, or errors;
- checking required terms in docs/templates;
- doing fast scope inspection.

Use CodeGraph/MCP when:

- a project is being onboarded for the first time;
- route is `medium` or heavier and code structure matters;
- ownership, callers, callees, routes, tests, or impact radius are unclear;
- a cross-file feature or bug may affect shared behavior.

Fallback when CodeGraph is unavailable:

```text
rg
> file tree
> package/test entry points
> dependency imports
> manual caller/callee notes
> focused verification
```

Use `code-audit-fix` when:

- a test or verification command fails;
- a regression or runtime error needs diagnosis;
- the root cause is unclear after local inspection;
- a repair loop needs faster localization.

Use `openai-docs` when:

- the task depends on current OpenAI/Codex/API/SDK behavior;
- hook, MCP, skill, model, or Codex configuration details are uncertain;
- official docs can change the implementation decision.

Use reviewer when:

- boundary/security/permission/API/deployment/database/scope risk is present;
- hidden acceptance risk is high;
- the change alters public contracts, auth, export/import, billing, production config, or persistent data;
- formal delivery already requires review.

Use browser/UI only when:

- UI or browser behavior cannot be verified safely by code/tests alone;
- a local app screenshot or DOM check is needed;
- the Human explicitly asks for browser verification.

Do not use a personal browser profile or logged-in state by default.

Use `lab-ai-delivery` when:

- the task is a formal module;
- a Task Packet, Evaluator, or Gate Report is required;
- high-risk work needs audit-grade delivery.

## Evidence Boundaries

- CodeGraph/MCP improves structural localization, not correctness.
- `code-audit-fix` improves diagnosis, not guaranteed repair.
- reviewer improves high-risk accept/reject quality, not all small-task quality.
- `openai-docs` improves current OpenAI/Codex/API specificity, not general research.
- browser/UI evidence can be useful but may expose private state; keep payloads and profiles controlled.
- Local trace/evidence is useful, but hosted Langfuse is optional and credential-dependent.

## Recommended Patterns

### Small Known Edit

```text
rg
> edit
> focused verification
> scope guard
```

### Cross-File Bug

```text
rg
> CodeGraph/MCP
> code-audit-fix if diagnosis is unclear
> fix
> verification
> scope guard
```

### Vague Feature

```text
feature_discovery
> short brainstorm
> optional feature_plan
> implementation
> verification-before-completion
```

### Docs/API Uncertainty

```text
local repo facts
> official docs
> decision note
> scoped implementation
```

### High-Risk Boundary

```text
scoped packet
> implementation or checklist
> reviewer
> verification
> residual-risk note
```

### Formal Module

```text
Task Packet
> generator child
> parent gates
> evaluator
> Gate Report
> commit
```

### Branch Finish

```text
verification
> scope guard
> branch/worktree detection
> integration options
> explicit chosen action
```

Use this only when work is complete and the next action is commit, push, PR, merge, keep, discard, or cleanup.

## Lightweight Trace Fields

Production traces and reports should stay compact:

```text
task_id:
route:
layer:
capabilities_considered:
capabilities_used:
capabilities_skipped:
changed_files:
verification:
reviewer:
scope:
residual_risk:
```

Do not include benchmark-only comparison metrics unless the task is explicitly an evaluation.

## What To Avoid

- Do not run every capability on every task.
- Do not use CodeGraph output as proof.
- Do not use reviewer as decoration after the decision is already made.
- Do not ask external docs to override repo facts without evidence.
- Do not let browser tools use personal logged-in state without explicit approval.
- Do not install tools, MCP servers, plugins, or hooks just to expand inventory.
- Do not hide failed tools; record fallback and residual risk.
