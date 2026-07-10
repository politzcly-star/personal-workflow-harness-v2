# Codex Production Harness

A lightweight, role-routed workflow for daily development and long-running Goal tasks.

## Operating Model

```text
one gpt-5.6-terra Medium daily root
> optional one-time gpt-5.6-sol planning before Goal mode
> direct work for clear S0-S2 tasks
> terra_worker for bounded implementation when delegation helps
> luna_verifier for S3/S4 milestone review
> root accepts, repairs narrowly, and reports
```

The Human normally states a requirement, approves one route/acceptance/authorization contract with `GO`, then reviews final evidence. The Human may choose Sol once before Goal mode to freeze that contract, but does not switch models between implementation and verification phases. The root owns progress, automatic focused repair, acceptance, and Goal continuity. Subagents are conditional so daily work does not pay multi-agent cost by default.

See `AGENTS.md`, `docs/model-routing-policy.md`, and `docs/route-policy.md`.

## Project Activation

Project-scoped model routing lives in:

```text
.codex/config.toml
.codex/agents/terra-worker.toml
.codex/agents/luna-verifier.toml
```

New or old projects should be migrated with a Dry Run first:

```powershell
.\scripts\migrate-project-harness.ps1 -ProjectPath "D:\path\to\project"
```

Apply when the plan is correct:

```powershell
.\scripts\migrate-project-harness.ps1 -ProjectPath "D:\path\to\project" -Apply
```

Existing project config or hooks are never overwritten implicitly. Use `-ReplaceConfig` or `-ReplaceHooks` only after reviewing the Dry Run; the script backs up replaced files. Use `-ArchiveLegacyHarness` to move known old harness policy copies into an inert backup while preserving project facts, profiles, tasks, audits, and history.

If the project root contains an unmarked legacy Harness-only `AGENTS.md`, or a recognized v2.1 workflow preamble above `Project Conventions`, review it and add `-ReplaceLegacyAgents`. The file is backed up; recognized project conventions are preserved while the old workflow preamble is removed. Other mixed project-specific `AGENTS.md` content is appended to and preserved.

After migration, trust the project in Codex so project-scoped configuration can load.

## Verification And Safety

Run:

```powershell
.\scripts\harness-self-test.ps1
.\scripts\health-check.ps1 -Strict
```

Hooks block secret exposure, embedded credentials, destructive filesystem/git actions, database mutation, deployment/restart, and unapproved remote mutation. They do not replace Human judgment or a real sandbox.

Long-running Goals use ignored `.codex/harness-state/` for a hashed contract and a bounded incremental Context Capsule. Hooks never parse transcripts or block Codex compaction. See `docs/autonomous-goal-workflow.md`.

External ClaudeCode/Qwen execution remains an explicit Human-enabled adapter, never the default path.

## Version

`v5.6.2 verified 5.6 role routing`
