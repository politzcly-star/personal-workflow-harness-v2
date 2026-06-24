# Task Brief

Use this before implementation when the task is not trivial.

```text
Task ID:
User Request:
Selected Route:
Layer: lightweight | medium | review_gated | full_formal_gate
Why This Route:

Parent / Child:
- Parent direct execution:
- Child executor needed:
- Reviewer needed:

Goal:
Non-Goals:

Allowed Changes:
- TODO

Forbidden Changes:
- secrets
- unapproved production/database/deployment actions
- unrelated refactors
- browser personal profile state
- runtime artifacts

Capabilities To Consider:
- rg:
- CodeGraph/MCP:
- code-audit-fix:
- openai-docs:
- reviewer:
- browser/UI:
- lab-ai-delivery:

Verification Plan:
- TODO

Stop Conditions:
- scope becomes unclear
- credentials/secrets are required
- production/database/destructive action is requested
- personal browser logged-in state would be needed
- verification cannot be run and risk is not acceptable

Residual Risks:
- TODO
```
