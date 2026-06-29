# Child Task

Use this when the parent delegates non trivial work to a child executor.

```text
Task ID:
Parent Thread:
Selected Route:
Layer:
Parent Direct Execution Exception Used: no

Parent Instruction:
- Parent routes, scopes, and accepts.
- Child executes the scoped work.
- Parent should read the child report and verify, not silently redo the implementation.

Goal:
Non-Goals:

Allowed Files / Areas:
- TODO

Forbidden Files / Areas:
- secrets and `.env`
- production config unless explicitly allowed
- database dumps or private data
- browser profiles and cookies
- unrelated refactors
- TODO

Required Context To Read:
- README.md
- AGENTS.md
- docs/route-policy.md
- docs/capability-policy.md
- docs/verification-and-guardrails.md
- TODO

Capabilities Allowed:
- rg:
- CodeGraph/MCP:
- code-audit-fix:
- openai-docs:
- browser/UI:

Implementation Instructions:
- TODO

Verification Required:
- TODO

Report Required:
- changed files
- checks run and results
- checks skipped with allowed reason
- risks and assumptions
- next recommended action

Stop Conditions:
- forbidden file is needed
- secrets or credentials are needed
- production/database/destructive action is needed
- scope expands beyond packet
- verification cannot be run safely
```
