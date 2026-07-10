# Production Harness Instructions

## Authority

```text
Human instruction
> repository rules and this file
> current Task Packet or task brief
> route policy and verification evidence
> chat memory
```

Durable files explain what must survive a new task; chat supplies the current objective.

## Root Owner And Daily Default

The root thread is the stable goal owner. Use the project default `gpt-5.6-terra` with `medium` reasoning for routing, direct daily work, acceptance, and final reporting.

Before starting Goal mode, the Human may select `gpt-5.6-sol` once to freeze the route and final acceptance contract. After Goal mode starts, do not ask for phase-by-phase model switching; the root coordinates the pinned Terra and Luna roles automatically.

The normal Human loop is exactly: state the requirement, approve one route/acceptance/authorization contract with `GO`, then review final evidence. Routine implementation, tests, focused repairs, and required Luna review continue without another Human phase confirmation.

Classify S0-S4 before editing:

| Weight | Use when | Default execution |
| --- | --- | --- |
| S0 | Discussion or read-only analysis. | Root answers directly. |
| S1 | Known, narrow change. | Root edits and runs a focused check. |
| S2 | Bounded cross-file change with clear checks. | Root works directly unless delegation has a concrete benefit. |
| S3 | Hidden acceptance or boundary risk. | Root freezes scope, delegates implementation to `terra_worker`, then delegates read-only review to `luna_verifier`. |
| S4 | Roadmap-sized or multi-milestone work. | Root owns the roadmap and repeats the S3 loop one milestone at a time. |

Use a named route only if it changes guardrails or checks. Do not separately classify a derived layer for routine work. See `docs/route-policy.md` and `docs/model-routing-policy.md`.

## Automatic Delegation

- `terra_worker` is the model-pinned implementation child for bounded S2 delegation and S3/S4 milestones.
- `luna_verifier` is the model-pinned, read-only milestone verifier.
- For S0/S1 and clear S2 work, stay in the root thread to avoid subagent token overhead.
- For S3/S4, the root should spawn the required role automatically from this instruction; the Human does not switch the composer model.
- If verification returns NO-GO, send only the findings back to `terra_worker`, run a narrow repair, and re-verify the affected acceptance checks.
- Do not use `max`, `ultra`, deeper agent nesting, or parallel write agents automatically.

Custom agent files live under `.codex/agents/`. The verified desktop catalog identifiers used by this harness are `gpt-5.6-sol`, `gpt-5.6-terra`, and `gpt-5.6-luna`.

## Long-Running Goals

For Goal mode or overnight work, start from a frozen route and acceptance contract. The root thread then continues across implementation, verification, and narrow repair without pausing for routine model changes or phase confirmations. Stop only when:

- the objective or acceptance contract must materially change;
- fresh Human authority is required;
- credentials, production deployment, database mutation, destructive action, or private browser state is required;
- verification cannot continue safely;
- the same blocker remains after the allowed focused repair loop.

Use ignored `.codex/harness-state/` only for a bounded hashed contract and incremental Context Capsule. Never treat transcripts as durable state; missing or unsafe runtime state falls back to repository authority files.

## Evidence And Safety

Before claiming completion, run the smallest relevant verification and report changed files, checks, skipped checks with reason, and residual risk. S0 needs no formal report; S1 is brief; S2+ records scope and evidence.

Never read, print, store, or commit secrets. Do not perform destructive actions, database writes, deployment/restart, production remote mutation, credentialed browser work, or paid external actions without a fresh Human objective and the route-specific boundary. Hooks are guardrails, not a sandbox.

Keep strict blocks for secret-file access, embedded credentials, destructive filesystem or git commands, database mutation, deployment/restart, and unapproved remote mutation. Safe discussion, documentation edits, and read-only checks must not be blocked by workflow ceremony.

## Capabilities

- Use `rg` for fast literal search and scope checks.
- Use CodeGraph only when code relationships matter; otherwise record the `rg`/file-tree fallback.
- Use `code-audit-fix` for failures, regressions, or repair loops.
- Use `openai-docs` for current OpenAI/Codex/API uncertainty.
- Use browser/UI only for needed user-facing evidence and avoid personal logged-in state.

## Onboarding, Handoff, And Branches

Use `scripts/migrate-project-harness.ps1` to adopt or upgrade a project. It is Dry Run by default, preserves project facts and history, and requires explicit switches before replacing existing config/hooks or archiving old harness copies.

Before a long pause or compaction, save only the goal, S-level/route when relevant, decisions, changed files, evidence, residual risk, forbidden actions, and next action using `templates/handoff.md`.

Before commit, push, PR, merge, discard, or cleanup, use `branch_finish`: inspect branch/worktree state, verify relevant checks, and require explicit approval for destructive cleanup.

## Optional External Executor And Non-Claims

ClaudeCode, Qwen, and similar tools remain disabled unless the Human explicitly enables one named low-final-decision phase. This harness improves scope discipline, route choice, and verification honesty; it does not promise universal token savings, productivity gains, or pass-rate gains.
