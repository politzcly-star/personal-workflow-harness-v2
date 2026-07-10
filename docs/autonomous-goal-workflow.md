# Autonomous Goal Workflow

The normal Human loop is: state a requirement, approve one compact route/acceptance/authorization card with `GO`, then review final evidence. Progress messages never request a routine phase confirmation.

After `GO`, the Terra root moves through `IMPLEMENTING`, `VERIFYING`, bounded `REPAIRING`, required `REVIEWING`, then `COMPLETE` or `BLOCKED`. It automatically selects root-direct work for cheap S1/clear S2 changes, a bounded Terra worker when exploration/logs/retries would pollute the root, and Luna only for S3/S4 or a listed boundary trigger.

Before an overnight Goal, Sol may freeze the route once. Thereafter the Human does not switch models for implementation, tests, repairs, or review. A new Human decision is needed only for a material contract change, an out-of-scope action, protected authority, unsafe verification, three failed focused repairs of the same blocker, or an unrepairable independent-review contradiction.

Runtime state is local and ignored under `.codex/harness-state/`. `scripts/goal-state.ps1` stores a contract hash and a bounded incremental Capsule; it never stores transcripts, source dumps, raw logs, secrets, or private state. Compaction remains Codex-owned: hooks may warn about invalid state but never block compaction or parse `transcript_path`.

During an active Goal, `Checkpoint` remains available so the Capsule can persist. `Close` requires a concrete completion report that passes the report fields check and the explicit `harness:goal-close` marker at the Hook boundary. Closing a Goal removes only its local active state; it does not authorize a replacement Goal. The next Goal still requires a new Human-requested lifecycle under the durable root instructions. Hooks are guardrails rather than a sandbox, so this lifecycle rule is enforced by the root protocol and evidence review as well as the Hook.
