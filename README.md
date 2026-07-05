# Codex Production Harness

A lightweight production workflow harness for Codex in real projects.

It helps Codex choose the right amount of process for each task: small work stays fast, medium work gets enough structure to be reliable, and high-risk work still gets strict guardrails. It is not an evaluation platform; the production flow stays lightweight by default.

## What This Solves

Use this harness when you want Codex to:

- classify work before editing;
- avoid turning small tasks into formal deliveries;
- keep medium tasks moving when scope and verification are clear;
- force extra care for security, permission, database, deployment, server, and public API boundaries;
- leave enough verification evidence that the next thread can trust what happened;
- use hook-ready reminders without treating hooks as a complete safety boundary.

## S0-S4 Task Weight

S-level decides execution weight. Route and four-layer tier decide capabilities and acceptance strictness.

| Level | Use When | Default Execution |
| --- | --- | --- |
| `S0` | Discussion, prompts, explanation, read-only analysis, no code changes. | Direct answer. No full route/report required; mention `discussion / no code changes` when useful. |
| `S1` | Known file, small fix, single-point doc/code change. | Parent may execute directly with focused verification. |
| `S2` | Medium but bounded feature/fix, clear files or clear verification path. | Parent may plan then implement directly; child is recommended, not mandatory. |
| `S3` | Cross-module, unfamiliar risky area, hidden acceptance, security, permission, deployment, database, public API, production server. | Child/reviewer is required or strongly required; use review-gated evidence. |
| `S4` | Long product line, multi-stage delivery, formal module, sustained roadmap. | Parent splits stages; child executes; reviewer as needed. |

The goal is simple: do not spend S3 energy on S1 work, and do not treat S3 work like S1.

## Routes And Four Layers

Route first, then scale the execution tier.

| Route | Layer | Use When |
| --- | --- | --- |
| `lightweight_fix` | `lightweight` | Clear small edit. |
| `audit_fix` | `medium` | Bug, failing test, regression. |
| `structural_localization` | `medium` | Unfamiliar cross-file area. |
| `feature_discovery` | `medium` | Vague feature or competing approaches. |
| `feature_plan` | `medium` | Mid-size feature with clear boundaries. |
| `docs_assisted` | `medium` | API/docs uncertainty. |
| `review_gated` | `review_gated` | Security, permission, boundary, hidden acceptance, public API. |
| `deployment_route` | `review_gated` | Deployment/config/reload/restart/CI. |
| `server_inspection` | `review_gated` | Read-only server inspection through a configured no-secret alias. |
| `database_route` | `review_gated` | Schema, migration, SQL, data repair/import/export. |
| `branch_finish` | `medium` or higher | Commit, push, PR, merge, keep, discard, cleanup. |
| `lab_ai_delivery` | `full_formal_gate` | Formal/high-risk module delivery. |

Daily preference:

```text
S0/S1 lightweight
> S2 medium
> S3 review_gated
> S4 staged/full_formal_gate when needed
```

## Parent And Child Execution

The parent thread remains the router and acceptor, but v2.2 avoids forcing every medium task into a child.

| Decision | Applies To |
| --- | --- |
| `parent_allowed` | S0/S1, plus S2 tasks with clear boundaries and an obvious verification path. |
| `child_recommended` | S2 cross-file but bounded work, medium new features, structural localization. |
| `child_required` | S3/S4, high-risk or hidden acceptance work, deployment, database, security/permission/public API, unfamiliar cross-module work. |

If child capability is unavailable:

- S0-S2: state that child is unavailable or not worth opening, then continue in-parent.
- S3-S4: stop, explain the risk, and ask the Human to authorize parent-only execution or create/authorize child/reviewer support.

See `docs/parent-child-execution.md`.

## Developer Efficiency Mode

v2.2 adds explicit efficiency rules:

- build the fastest local or isolated feedback path first;
- run the smallest relevant test before broader regression;
- avoid refactors that do not reduce real risk or complexity;
- use read-only inspection and dry-run/config-test before remote or deployment action;
- batch model calls, browser checks, and builds instead of repeating them mechanically.

See `docs/developer-efficiency-mode.md`.

## Product Acceptance

For artifacts such as PPTs, dashboards, documents, pages, agent products, and scripts, use `templates/product-acceptance.md` when quality matters. It checks whether the output matches user intent, opens/runs/downloads, looks or reads professionally, avoids noise and leaks, improves on the prior version, and has minimal reproducible evidence.

## Hooks

Hook files live under:

```text
.codex/hooks.json
.codex/hooks/harness-hook.ps1
```

Hooks are guardrails, not a sandbox. They classify results as:

- `info`: context or reminder;
- `warn`: proceed, but record the concern;
- `block`: stop unsafe action unless the Human gives a fresh objective and the route permits it.

Strict blocks remain for secrets, private keys, raw credentials, dangerous deletion, database writes/migrations, remote deployment/restart, and production mutations. Discussion, read-only checks, and doc-only work should receive fewer false positives. See `docs/hook-tuning.md` and `docs/install-hooks-upgrade.md`.

## Context Survival

Use Codex's built-in compaction plus parent/child isolation. The repository only defines what must survive compaction:

- current goal and real user constraints;
- route and S-level;
- decisions made;
- files changed;
- verification results;
- unresolved risk and next step;
- forbidden actions;
- key commands;
- server alias status.

`templates/handoff.md` is the human-readable state anchor before compaction or handoff. See `docs/context-compression-policy.md`.

## New Project Adoption

Chat-only references are not durable. Install the harness into a project by merging the project addendum into the target root `AGENTS.md` and creating a project profile.

```powershell
.\scripts\init-project-profile.ps1 -ProjectPath "D:\path\to\project" -ProjectName "my-project" -InstallAgents
```

Then run the local checks:

```powershell
.\scripts\health-check.ps1
.\scripts\check-codegraph.ps1
.\scripts\server-inspection-check.ps1 -HostAlias "my-prod-alias"
```

If CodeGraph is unavailable, record the fallback: `rg` + file tree + test entry points + manual dependency/call notes. If no server alias exists, ask the Human to configure a Windows SSH alias once; do not ask for raw passwords.

## Completion Evidence

Use the report weight that matches the task:

- S0: direct answer, usually no report.
- S1: lightweight report: what changed and what was verified.
- S2: standard report: route/files/checks/residual risk.
- S3-S4: formal report with child/reviewer/checklist evidence where needed.

See `docs/reporting-policy.md` and `templates/verification-report.md`.

## Quick Self-Check

```powershell
.\scripts\health-check.ps1
.\scripts\branch-finish-check.ps1
```

Before pushing or making a PR, use `branch_finish`: check tests, branch, remote, worktree state, changed files, and residual risk.

## Version

Current production version: `v2.2 efficiency tuning`.
