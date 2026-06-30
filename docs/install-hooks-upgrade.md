# Install, Hooks, And Upgrade

This harness works as plain Markdown. Hook integration is optional and repo-local.

## Install Into A New Project

Important: a chat instruction such as "refer to `D:\个人工作流-v2`" is not a durable install. New Codex windows keep the protocol only when the target project has a root `AGENTS.md` harness block, or an equivalent project rule, plus the project profile.

Copy these files:

```text
README.md
AGENTS.md
docs/
templates/
scripts/
.codex/hooks.json
.codex/hooks/
```

Then ask Codex:

```text
Read README.md and AGENTS.md. Use this production harness for the next task.
Route first, verify before completion, and escalate only when risk requires it.
```

Run:

```powershell
.\scripts\health-check.ps1
.\scripts\init-project-profile.ps1 -ProjectPath "D:\path\to\project" -ProjectName "my-project" -InstallAgents
.\scripts\check-codegraph.ps1
.\scripts\server-inspection-check.ps1 -HostAlias "my-prod-alias"
```

## Adapt Into An Existing Project

1. Keep the project's existing `AGENTS.md` or rules as highest local authority.
2. Merge `templates/project-agents.md` into the target project root `AGENTS.md`, or run `scripts/init-project-profile.ps1 -ProjectPath <project> -InstallAgents`.
3. Keep project-specific commands, tests, ports, and deployment rules in the project repo.
4. Add or update a project profile from `templates/project-profile.md`.
5. Confirm parent-router / child-executor availability. Non-trivial work should use child task / child report by default.
6. Check whether a server SSH alias exists. If yes, record it in the project profile and use `server_inspection`; if no, ask the Human to configure the alias once.
7. Remove eval-only examples that do not help daily work.
8. Add one task brief and one verification report for the first real task.

## Codex Hook Status

Codex official hooks support repo-local hook configuration under `.codex/hooks.json` or `.codex/config.toml`. Project-local hooks are reviewed and trusted by Codex before they run.

v2.1 provides hook-ready files:

```text
.codex/hooks.json
.codex/hooks/harness-hook.ps1
```

This repository does not modify global Codex configuration and does not claim hooks are automatically active. After copying or editing hooks, open the project in Codex and review/trust the local hook configuration when prompted.

Official reference used for this implementation: `https://developers.openai.com/codex/hooks`.

## Hook Lifecycle

| Hook | Behavior |
| --- | --- |
| SessionStart | Checks key files and returns onboarding context. |
| PreToolUse | Blocks or warns on `.env`, secrets, broad delete, database writes, remote deploy, production commands, and personal browser profile patterns. |
| PostToolUse | Summarizes changed files and warnings for runtime artifacts or suspected secret files. |
| SubagentStart | Adds child task expectations: allowed files, forbidden files, verification, report shape. |
| SubagentStop | Requires child report fields: changed files, verification, skipped checks, risks, next step. |
| PreCompact | Asks for `templates/handoff.md` snapshot before compaction. |
| Stop | Requires verification evidence or an allowed not-verified reason before final stop. |

## Hook Boundary

Hooks are guardrails, not a complete security boundary.

`PreToolUse` can intercept Bash, `apply_patch`, and MCP guardrail patterns, but it cannot understand every safe or unsafe intent. Keep human approval, route policy, and verification discipline as the real safety model.

## Health Check

Run this quick check after install:

```powershell
.\scripts\health-check.ps1
```

It checks:

- required files;
- parent-child execution protocol;
- project AGENTS addendum template;
- project profile template;
- branch finish template;
- server inspection template;
- hook-ready files;
- script syntax;
- `.env` / private key / secret keyword file-name risk;
- `.vs/`, IDE, and runtime artifact risk;
- CodeGraph availability fallback;
- server inspection script syntax;
- verification template availability.

## Upgrade Policy

Keep upgrades boring:

1. Read the current README and AGENTS.md.
2. Compare route policy changes.
3. Preserve project-specific commands and safety rules.
4. Do not overwrite local secrets or profiles.
5. Do not install global hooks without explicit Human approval.
6. Run health, scope, stop, branch-finish, and syntax checks.
7. Commit with a clear message.

## Version

Current production version:

```text
v2.1 production freeze
```

One-week rule: after upgrading, use `docs/production-pilot.md` to record real friction and value. Do not keep expanding the harness during the freeze unless hooks break normal development or a safety issue appears.
