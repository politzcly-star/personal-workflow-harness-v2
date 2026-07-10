# Install, Hooks, And Upgrade

Use the migration script for both new adoption and upgrades from the older harness.

## Safe Migration

Dry Run is the default:

```powershell
.\scripts\migrate-project-harness.ps1 -ProjectPath "D:\path\to\project"
```

The plan reports the managed AGENTS block, root model config, custom agents, hooks, profile state, and old harness candidates. It does not modify the project.

Apply the non-conflicting plan:

```powershell
.\scripts\migrate-project-harness.ps1 -ProjectPath "D:\path\to\project" -Apply
```

If existing project config or hooks must be replaced, review them first and use:

```powershell
.\scripts\migrate-project-harness.ps1 -ProjectPath "D:\path\to\project" -Apply -ReplaceConfig -ReplaceHooks
```

An unmarked legacy Harness-only `AGENTS.md`, or a recognized v2.1 workflow preamble above `Project Conventions`, is also a blocker. After review, replace it explicitly. The migration backs up the full file and preserves recognized project conventions while removing the old workflow preamble:

```powershell
.\scripts\migrate-project-harness.ps1 -ProjectPath "D:\path\to\project" -Apply -ReplaceLegacyAgents
```

Replacement files are backed up under `.codex/legacy-harness-backup/<timestamp>/`. To make old copied policy files inert without deleting them:

```powershell
.\scripts\migrate-project-harness.ps1 -ProjectPath "D:\path\to\project" -Apply -ArchiveLegacyHarness
```

Project facts, architecture, project profile, tasks, audits, tests, and history are never archived by this option.

## Installed Runtime

- `.codex/config.toml`: `gpt-5.6-terra` Medium daily root, max two threads, depth one.
- `.codex/agents/terra-worker.toml`: implementation role.
- `.codex/agents/luna-verifier.toml`: read-only review role.
- `.codex/hooks.json` and `.codex/hooks/harness-hook.ps1`: strict boundary guards.
- managed block in root `AGENTS.md`: automatic routing and Goal-mode behavior.
- `docs/project-profile.md`: created only when missing.

Project-scoped Codex configuration loads only after the project is trusted. This harness does not modify global configuration.

## Hook Lifecycle

| Event | Purpose |
| --- | --- |
| SessionStart | Compact routing reminder. |
| PreToolUse | Block clearly unsafe tool calls at strict boundaries. |

Post-tool snapshots and natural-language stop blocking remain intentionally absent.

## Verification

After migration, inspect `git diff`, open the project in Codex, review/trust local configuration, and run the project's own tests. In this harness repository run:

```powershell
.\scripts\harness-self-test.ps1
.\scripts\health-check.ps1 -Strict
git diff --check
```
