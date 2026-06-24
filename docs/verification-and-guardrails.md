# Verification And Guardrails

Verification-before-completion is the default completion rule.

The agent may finish only when it has checked the result, or when it records a narrow allowed reason verification could not be run.

## Minimum Completion Report

Use `templates/verification-report.md`.

Every final answer should know:

- selected route
- files changed
- commands/checks run
- result
- skipped checks and reason
- residual risk

## Common Verification

| Work Type | Useful Checks |
| --- | --- |
| Code | tests, build, lint, typecheck, focused reproduction. |
| Frontend | screenshot/DOM check, responsive check, no overlap, console errors. |
| Docs | required literals, link sanity, spelling where useful. |
| JSON/YAML | parse checks. |
| Shell/scripts | dry-run, help output, shellcheck/lint when available. |
| Deployment | config-test, dry-run, smoke plan, rollback plan. |
| Database | impact preview, transaction/dry-run, row-count, rollback evidence. |

## Allowed Not-Verified Reasons

Use only when true:

- dependency or service unavailable
- credentials intentionally absent
- verification would mutate production or private data
- command is outside the approved scope
- user explicitly requested no execution
- verification requires a human/operator result

Always state the residual risk.

## Secret Handling

Never print or commit:

- API keys
- tokens
- passwords
- private keys
- cookies
- `.env` values
- database URLs
- raw dumps
- private production logs
- personal data

Use summaries, presence maps, hashes, redacted values, and evidence references.

## Destructive Action Guard

Treat these as high-risk:

- `rm -rf`, destructive filesystem moves, broad deletes
- database `DROP`, `TRUNCATE`, broad `DELETE`, broad `UPDATE`
- schema migrations
- production deploy/reload/restart
- permission or role changes
- billing, quota, auth, secret, tenant, export/import changes

Require explicit Human approval and often reviewer or `lab-ai-delivery`.

## Scope Guard

Before completion, inspect changed files.

Ask:

```text
Are changed files expected?
Were generated/runtime files accidentally added?
Were secrets or local profiles touched?
Did the task drift into another module?
```

If scope drift happened, stop and report it.

## Reviewer Triggers

Use reviewer when:

- hidden acceptance risk is high
- security or permissions are affected
- public API contract changes
- data export/import changes
- production deploy/config changes
- database/schema/migration changes
- rollback is unclear
- verification is incomplete but acceptance is tempting

Reviewer should be read-only unless explicitly authorized.
