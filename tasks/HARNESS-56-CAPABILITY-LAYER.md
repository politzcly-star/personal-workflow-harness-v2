# HARNESS-56 Capability Layer Task Packet

Status: `FROZEN - Human GO received 2026-07-12`

Task ID: `HARNESS-56-CAPABILITY-LAYER`

## Goal

Strengthen the Harness capability-selection layer and autonomous Goal workflow while keeping daily work low-friction. Treat cost bands as measurable structural design targets relative to the prior GPT-5.5 workflow, never as guarantees of token use, productivity, pass rate, or safety.

## Route And Execution Exception

- S-level: `S4` because this is a multi-batch formal delivery spanning repository policy, user-level Skills, fixtures, and final independent review.
- Skills: `lab-ai-delivery` for this Packet/Gate delivery and `skill-creator` for user-level Skills.
- One-task exception: the Human authorized the current root to use `gpt-5.6-sol` for planning, implementation, tests, focused repair, and final read-only self-review. Do not invoke Terra, Luna, Claude, or require phase confirmations for this task.
- This exception does not change the delivered daily default: root Terra Medium; direct S0/S1 and clear S2; Terra worker plus one read-only Luna verifier for S3/S4.
- Human interaction is already complete until final evidence review unless a stop condition below occurs.

## Dirty Baseline

Repository HEAD at freeze: `6e469b82f1cf4cb03d6f316debb5d55beeba3d53` on `master`.

Inherited dirty paths and SHA-256 values at freeze (preserve; exclude from this task's edits):

- `docs/install-hooks-upgrade.md`: `1ce95e335b26ee012caebe34b67954c00b0715c44e2994c79210884aa3e570cb`
- `scripts/harness-self-test.ps1`: `5210c713598d7bec4c25aca0ee89a9da9383595adc541d971eec6c10b193988c`
- `scripts/migrate-project-harness.ps1`: `916c63d63b50016d8029ec34f915a623c8de3113afd8538634946e0995b63fd5`
- `audits/TAOLONG-HARNESS-LATEST-ADOPTION-gate-report.md`: `fcd2216f3c9a597a7ae3139f41208b743caf3a17e46d0614d96ccc63b2d6625c`
- `tasks/TAOLONG-HARNESS-LATEST-ADOPTION.md`: `61b8e64037af97a41edf2fa47e575154cb7d1c657342a679094fa23b346e0d70`

The existing `code-audit-fix` and `lab-ai-delivery` file hashes were captured in the Gate Report baseline before modification. They are authorized inputs and outputs, not inherited repository dirt.

## Exact Allowlist

Repository files:

- `AGENTS.md`
- `README.md`
- `docs/route-policy.md`
- `docs/capability-policy.md`
- `docs/model-routing-policy.md`
- `docs/autonomous-goal-workflow.md`
- `docs/skill-routing-policy.md` (new)
- `templates/task-brief.md`
- `templates/feature-plan.md`
- `templates/handoff.md`
- `templates/context-capsule.md`
- `scripts/capability-layer-self-test.ps1` (new)
- `tests/fixtures/capability-routing-cases.json` (new)
- `tasks/HARNESS-56-CAPABILITY-LAYER.md` (frozen after this write)
- `audits/HARNESS-56-CAPABILITY-LAYER-gate-report.md` (new)

User-level Skills under `C:\Users\32027\.codex\skills`:

- `code-audit-fix/SKILL.md`
- `code-audit-fix/agents/openai.yaml`
- `lab-ai-delivery/SKILL.md`
- `lab-ai-delivery/agents/openai.yaml`
- `lab-ai-delivery/references/task-packet-template.md`
- `lab-ai-delivery/references/gate-report-template.md`
- `lab-ai-delivery/references/risk-levels.md`
- deletion of `lab-ai-delivery/references/claude-review-template.md`
- `lab-ai-delivery/scripts/scope-gate.ps1`
- `lab-ai-delivery/scripts/codegraph-gate.ps1`
- `lab-ai-delivery/scripts/local-gate.ps1`
- `lab-ai-delivery/scripts/review-module.ps1`
- deletion of `lab-ai-delivery/scripts/claude-review.ps1`
- new `feature-discovery/{SKILL.md,agents/openai.yaml}`
- new `feature-development/{SKILL.md,agents/openai.yaml}`
- new `architecture-refactor/{SKILL.md,agents/openai.yaml}`
- new `community-research/{SKILL.md,agents/openai.yaml}`
- new `last30days-public/{SKILL.md,agents/openai.yaml}`

No file outside this list may be modified.

## Non-goals And Forbidden Actions

- Do not modify old frozen Packets or reports, `.codex/config.toml`, model/agent configuration, global MCP configuration, or the inherited dirty files listed above.
- Do not install or copy `mvanhorn/last30days-skill`, dependencies, plugins, a multi-agent framework, or any cookie/API-key/Watchlist runtime.
- Do not read, print, store, or modify secrets; do not use private browser state, paid services, production/database/deployment/restart/remote mutation, destructive cleanup, commit, push, PR, merge, stash, reset, or discard.
- Do not promise actual token, productivity, pass-rate, or safety improvements.

## Acceptance Contract

1. `code-audit-fix` retains evidence -> root cause -> minimal fix -> focused verification, dirty-worktree protection, review-only behavior, and a bounded repair loop; it removes file/layer-count escalation and phase stops, classifies S-level by risk/uncertainty/hidden acceptance, and continues after existing GO.
2. `lab-ai-delivery` triggers only for explicit formal/audit-grade delivery or S4. It uses the current Packet, exact scope, native verification, narrow repair, one-GO semantics, and independent read-only review; it has no Plan Mode, Claude dependency, second GO, `master` default, or fail-immediately ceremony.
3. Five small composable Skills exist with valid minimal frontmatter/UI metadata and the requested safety/trigger boundaries. `last30days-public` is explicit-only.
4. Harness policy progressively selects direct handling, a narrow Skill, or formal delivery after S0-S4 classification. S0/S1 are non-ceremonial; clear S2 stays root-direct; only S3/S4 delegates by daily default.
5. CodeGraph, browser/UI, and similar capabilities are job-shaped and conditional. Context Capsules are limited to long/overnight/compaction/multi-milestone Goals. Handoffs are exact; no parallel writers; `max_depth=1`; daily `max_threads=2`; model routing changes only at natural boundaries.
6. After one GO, normal planning, implementation, tests, narrow repair, and required review run continuously. Stop only for authorization expansion, unsafe/unverifiable work, or the same real blocker after the allowed bounded repair loop.
7. Deterministic checks detect legacy workflow residue, dangerous public-research behavior, bad daily triggers, invalid Skill metadata, and documentation/template inconsistencies.
8. Five side-effect-free Sol routing smoke cases cover a small bug, clear feature, ambiguous requirement, architecture refactor, and explicit 30-day public research. Evidence records expected S-level, Skill, and verification; it does not claim static files mechanically enforce runtime Skill selection.
9. Existing Harness self-test, `health-check.ps1 -Strict`, all modified-scope checks, Skill Creator validation, parser checks, and `git diff --check` pass. Inherited dirty hashes remain unchanged.
10. Final Sol-only read-only review evaluates daily friction, safety boundaries, cross-artifact consistency, scope drift, unsupported claims, and real test evidence, producing `GO`, `CONDITIONAL GO`, or `NO-GO`; packet-scoped findings receive one narrow repair/recheck loop.

## Cost Design And Measurement

Estimated structural targets versus the old GPT-5.5 workflow: S0/S1 `0.5-0.8x`, S2 `0.6-1.1x`, S3 `1.3-1.8x`, S4 `1.5-2.0x` per milestone. These are hypotheses, not guarantees. Measure per S-level using sampled tasks: root turns, spawned agents, Skill bodies loaded, graph/browser invocations, verification commands, repair loops, elapsed time, and actual usage when the platform exposes it. Compare medians and outliers without claiming causality from static policy alone.

## Verification Commands

```powershell
.\scripts\harness-self-test.ps1
.\scripts\health-check.ps1 -Strict
.\scripts\capability-layer-self-test.ps1
python C:\Users\32027\.codex\skills\.system\skill-creator\scripts\quick_validate.py <each changed/new skill directory>
git diff --check
```

Also parse every changed PowerShell file, verify inherited hashes, inspect final repository and user-Skill diffs against this allowlist, and record skipped checks with reasons.

## Stop Conditions

Stop only if the acceptance contract or allowlist must materially change, fresh authority is required, a forbidden boundary is reached, verification cannot proceed safely, or the same concrete blocker persists after the bounded focused repair loop.
