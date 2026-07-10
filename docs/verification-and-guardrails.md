# Verification And Guardrails

Completion requires the smallest relevant evidence or a narrow, recorded reason evidence cannot be run.

## Common Evidence

| Change | Useful check |
| --- | --- |
| Docs | required terms, link sanity when relevant, `git diff --check`. |
| JSON/YAML/TOML | parse check. |
| PowerShell | parser check and safe fixture/direct invocation. |
| Hooks | JSON parse plus safe and blocked simulated events. |
| Code | focused test/build/lint or reproduction. |
| Deployment/database | dry-run, impact preview, rollback/checklist, and operator boundary. |

Before acceptance, inspect actual changed paths for scope drift, runtime artifacts, local profiles, and secrets. Record skipped checks and residual risk.

## Strict Boundaries

Never read, print, commit, or request raw secrets, `.env` values, private keys, cookies, database URLs, raw production logs, or private data.

Require a fresh Human objective before destructive actions, database mutation or migration, deployment/restart, production remote mutation, credentialed browser work, or paid external action. Prefer read-only previews, redacted evidence, and checklists.

Hooks can block obvious unsafe calls but cannot prove intent. They must remain strict at these boundaries and quiet for discussion, documentation, and safe inspection.
