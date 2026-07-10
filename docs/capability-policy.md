# Capability Policy

Choose tools because they change confidence or speed for the current task, not because a checklist exists.

| Capability | Use when | Do not use when |
| --- | --- | --- |
| `rg` | Literal search, file ownership, scope inspection. | A relationship graph is actually needed. |
| CodeGraph/MCP | Callers, callees, shared ownership, or affected tests are unclear. | Docs-only or obvious local work. |
| `code-audit-fix` | A check fails, a regression is suspected, or repair loops begin. | Normal planned implementation without a failure. |
| `openai-docs` | Current OpenAI/Codex/API behavior affects the decision. | General research or stable local facts. |
| `luna_verifier` | S3/S4, hidden acceptance, or a listed boundary. | Every S1/S2 task by habit. |
| Browser/UI | Code/tests cannot prove user-facing behavior. | Personal logged-in state would be needed. |

If CodeGraph is unavailable, record the `rg` + file tree + test entry-point + manual impact fallback. It improves localization, not proof of correctness.

Do not automatically delegate, install a tool, invoke a browser, or enable an external executor because a task is large. External executors require explicit Human activation and remain subject to root-thread acceptance and any required `luna_verifier` review.
