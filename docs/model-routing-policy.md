# Model Routing Policy

The root thread is the stable goal owner. Project configuration defaults daily work to `gpt-5.6-terra` with `medium` reasoning. Before Goal mode, the Human may select `gpt-5.6-sol` once to freeze the route and final acceptance contract; the Goal then proceeds without phase-by-phase model switching.

## Default Path

| Situation | Owner | Model / reasoning | Handoff |
| --- | --- | --- | --- |
| S0/S1 and clear S2 work | Root goal owner | `gpt-5.6-terra` / medium | None. Work directly. |
| Bounded delegated implementation | `terra_worker` | `gpt-5.6-terra` / high | Return a compact implementation report. |
| S3/S4 milestone verification | `luna_verifier` | `gpt-5.6-luna` / medium / read-only | Return GO, CONDITIONAL GO, or NO-GO. |
| Goal route and acceptance freeze | Human-selected root | `gpt-5.6-sol` / high as needed | One planning stage before Goal mode. |

These identifiers were verified against the current Codex desktop model catalog. Do not substitute a generic `gpt-5.6` identifier that is absent from the catalog.

## Routing Rules

1. Keep clear S0/S1 and low-context S2 work in the root thread to avoid extra model calls. Delegate S2 only when exploration, logs, retries, or context isolation materially preserve throughput; reuse a worker only for consecutive same-subsystem work.
2. Before Goal mode, freeze scope and acceptance in Sol; do not reopen the plan merely to change models after Goal mode starts.
3. For S3/S4, root spawns `terra_worker`, then spawns `luna_verifier` after local checks pass.
4. A Luna NO-GO returns a narrow finding list to Terra; it does not restart the workflow.
5. Do not ask the Human to switch the composer model between execution and verification phases.
6. Keep `agents.max_threads = 2` and `agents.max_depth = 1`; no recursive delegation or parallel writers by default.
7. A handoff contains only the task contract, relevant files, final diff, compact evidence, and unresolved decisions. No Human model switch or phase confirmation is requested after `GO`.

## Configuration Files

- `.codex/config.toml`: root model/reasoning and thread limits.
- `.codex/agents/terra-worker.toml`: implementation child.
- `.codex/agents/luna-verifier.toml`: independent read-only verifier.

Project-scoped configuration activates only after the project is trusted in Codex. Live parent permission overrides still apply to spawned agents.
