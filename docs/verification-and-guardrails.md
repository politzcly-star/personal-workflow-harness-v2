# Verification And Guardrails

Verification-before-completion is the default completion rule.

The agent may finish only when it has checked the result, or when it records a narrow allowed reason verification could not be run.

## Minimum Completion Report

Use `templates/verification-report.md` or an equivalent final report.

Every final answer should know:

- selected route and four-layer tier;
- files changed;
- commands/checks run;
- result;
- skipped checks and allowed reason;
- residual risk;
- scope guard result.

## Common Verification

| Work Type | Useful Checks |
| --- | --- |
| Code | tests, build, lint, typecheck, focused reproduction. |
| Frontend | screenshot/DOM check, responsive check, no overlap, console errors. |
| Docs | required literals, link sanity, Markdown parse/render where useful, spelling where useful. |
| JSON/YAML/TOML | parse checks. |
| PowerShell/scripts | `powershell -NoProfile -Command { . <script> }`, dry-run, focused invocation. |
| Hooks | JSON parse, script syntax check, safe simulated event where possible. |
| Deployment | config-test, dry-run, smoke plan, rollback plan, operator evidence. |
| Server inspection | SSH alias resolution, BatchMode read-only command, redacted output summary, no raw credential handling. |
| Database | impact preview, transaction/dry-run, row-count, rollback evidence, redacted operator result. |

Docs-only changes still need verification: literal coverage, link sanity, parse checks, `git diff --check`, or another focused check.

## Allowed Not-Verified Reasons

Use only when true:

- dependency or service unavailable;
- credentials intentionally absent;
- verification would mutate production or private data;
- command is outside the approved scope;
- user explicitly requested no execution;
- verification requires a human/operator result;
- browser/UI verification would require unsafe personal profile or logged-in state.

Always state the residual risk.

## Secret Handling

Never print or commit:

- API keys;
- tokens;
- passwords;
- private keys;
- cookies;
- `.env` values;
- database URLs;
- raw dumps;
- private production logs;
- personal data.

Use summaries, presence maps, hashes, redacted values, and evidence references.

Safe scans should list file paths or summaries only. Do not print matched secret values.

## Destructive Action Guard

Treat these as high-risk:

- `rm -rf`, destructive filesystem moves, broad deletes;
- `Remove-Item -Recurse -Force` against broad paths;
- database `DROP`, `TRUNCATE`, broad `DELETE`, broad `UPDATE`;
- schema migrations;
- production deploy/reload/restart;
- permission or role changes;
- billing, quota, auth, secret, tenant, export/import changes;
- credentialed browser actions or external form submission.

Require explicit Human approval and often reviewer or `lab-ai-delivery`.

## Scope Guard

Before completion and before commit, inspect changed files.

Ask:

```text
Are changed files expected?
Were generated/runtime files accidentally added?
Were secrets or local profiles touched?
Did the task drift into another module?
Are hook/script changes inside the intended repo-local scope?
```

If scope drift happened, stop and report it.

Runtime artifacts to avoid:

- `.vs/`
- `.env` and `.env.*`
- local IDE settings;
- logs, dumps, build output, node_modules;
- browser profiles, cookies, screenshots with private data;
- database dumps or exports.

## Reviewer Triggers

Use reviewer when:

- hidden acceptance risk is high;
- security or permissions are affected;
- public API contract changes;
- data export/import changes;
- production deploy/config changes;
- database/schema/migration changes;
- rollback is unclear;
- verification is incomplete but acceptance is tempting.

Reviewer should be read-only unless explicitly authorized.

## Deployment Guard

Deployment work should normally produce a checklist, not execute live changes.

Required evidence:

- pre-change state;
- backup/rollback;
- dry-run/config-test;
- reload/restart risk;
- operator boundary;
- smoke verification;
- secret redaction.

Do not claim production success without operator-provided or safe smoke evidence.

## Server Inspection Guard

Server inspection is allowed only for read-only work through preconfigured no-secret access.

Allowed:

- SSH config host alias, SSH agent, or operator-prepared short-lived session;
- `ssh -o BatchMode=yes <alias> '<read-only command>'`;
- compact summaries of file presence, versions, process status, health output, and non-secret config snippets;
- redacted evidence references.

Forbidden:

- reading passwords from screenshots;
- pasting passwords/tokens into commands;
- `sshpass`;
- writing credentials to files, hooks, prompts, reports, or terminal history;
- reading `.env`, private keys, database URLs, cookies, secret manager values, or private user data;
- remote writes, deploys, reload/restart, permission changes, package installs, or destructive commands.

If server inspection needs credentials that are not already configured, stop and ask the Human to configure a no-secret access method or provide redacted operator evidence.

## Database Guard

Database work should normally produce a checklist, not execute data changes.

Required evidence for data-affecting work:

- environment/database identity;
- `SELECT preview` or equivalent impact preview;
- expected/max row count;
- backup/rollback;
- transaction/dry-run/staging/idempotency;
- destructive guard;
- privacy/secret redaction;
- permission/export/import escalation state.

Do not run SQL, migrations, import/export, backup/restore, or remote database commands by default.

## Hook Guard

Hooks are useful guardrails, not a complete security boundary.

`PreToolUse` can block obvious dangerous tool calls, including Bash, `apply_patch`, and MCP usage patterns, but it cannot prove all intent or replace human judgment. Keep hooks conservative, transparent, and easy to disable or tune if they interrupt safe work.
