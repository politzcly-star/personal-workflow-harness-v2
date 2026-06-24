# Capability Policy

Capabilities are tools the agent may use to improve route quality. They should be selected by need, not enabled blindly.

## Default Capability Map

| Capability | Default | Use For | Guardrail |
| --- | --- | --- | --- |
| `rg` | On | Fast local search, config lookup, docs lookup. | Prefer focused searches. Avoid ignored secret/data folders. |
| CodeGraph/MCP | On demand | Cross-file relationships, callers/callees, impact radius, ownership. | Context only; not proof of correctness. |
| `code-audit-fix` | On demand | Bugs, failing tests, regressions, suspicious behavior. | Verify locally before completion. |
| official docs | On demand | Current API/SDK/platform uncertainty. | Prefer official docs; record uncertainty. |
| reviewer child | High-risk only | Boundary, security, permissions, data export, deployment/database risk. | Read-only by default. |
| browser control | Eval/manual only by default | UI inspection or reproduction when explicitly needed. | Use dedicated profile; avoid credential leakage. |
| `lab-ai-delivery` | Formal only | Task Packet, evaluator, Gate Report, audit-grade delivery. | Do not use for every small task. |

## Tool Orchestration

The harness should make the agent ask:

```text
Do I know the target?
Do I need code relationships?
Do I need current docs?
Do I need a reviewer?
Do I need formal gates?
```

Then choose the smallest useful capability set.

## Recommended Patterns

### Small Known Edit

```text
rg
> edit
> focused verification
```

### Cross-File Bug

```text
rg
> CodeGraph/MCP
> code-audit-fix
> verification
```

### Vague Feature

```text
feature_discovery
> optional writing-plans
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

## What To Avoid

- Do not run every capability on every task.
- Do not use CodeGraph output as proof.
- Do not use reviewer as decoration after the decision is already made.
- Do not ask external docs to override repo facts without evidence.
- Do not let browser tools use personal logged-in state without explicit approval.
- Do not hide failed tools; record failed capability spans or notes.

## Lightweight Trace Fields

Production traces should stay compact:

```text
task_id:
route:
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
