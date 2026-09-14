# HARNESS-56 Luna Daily Routing Pilot

Status: FROZEN  
Frozen: 2026-08-03  
Decision owner: root goal owner; Human retains authority for permanent model/config changes  
S-level: S3 (model-routing quality, independence, and hidden-acceptance risk)  
Skills: `architecture-refactor` for the route design, then `feature-development` for the bounded policy/test slice

## Goal

Design and verify a reversible Luna-first daily-work pilot without changing permanent Codex model or agent configuration. The pilot must determine which clear S0-S2 jobs may use `gpt-5.6-luna` with `xhigh` reasoning, retain Terra for judgment-heavy implementation, keep an independent review model, and prove the routing rules with deterministic fixtures plus real read-only model runs.

This is an evidence-gathering pilot, not a claim that Luna Xhigh is already the universal replacement for Terra Medium.

## Baseline

- Repository HEAD at freeze: `6e469b82f1cf4cb03d6f316debb5d55beeba3d53`.
- The worktree was already dirty from HARNESS-56 capability-layer and project-adoption work. All pre-existing changes are user-owned and must be preserved.
- Current durable default: root `gpt-5.6-terra` / medium; S3/S4 implementation `terra_worker`; S3/S4 read-only verification `luna_verifier`.
- Observed recent tasks used Human-selected Sol roots, Terra implementation children, and predominantly Luna verification children. At least one verifier role/model mismatch and some unnecessary heavy-root work were found.
- Official Codex guidance current at 2026-08-03 describes Terra as the everyday workhorse and Luna as fast/high-volume for clear repeatable work. Pricing reductions alone do not establish equivalent task quality.

## Frozen Route

1. Add a reversible `luna_daily_pilot` candidate route for clear, repeatable, deterministically verifiable S0/S1 and selected S2 work.
2. Pilot candidate is Luna Xhigh because that is the Human's proposed comparison. Ultra is excluded because it may introduce subagents and changes the topology being measured.
3. Keep Terra Medium as the durable fallback and keep Terra High for judgment-heavy or boundary-sensitive implementation during the pilot.
4. Keep Luna Medium as verifier only when implementation was not performed by Luna. If Luna implements a reviewed change, verification must use Terra or Sol so implementation and review are model-family independent.
5. The actual root/composer model selected by the Human or platform is authoritative. Repository prose cannot silently override it; progress/evidence must record the actual model, effort, and role when exposed.
6. Do not modify global/project Codex model or agent configuration in this task. A permanent default switch requires a later Human decision based on pilot evidence.

## Eligibility Contract

Luna Xhigh pilot eligible only when all are true:

- S0, S1, or a clear bounded S2;
- ownership and intended behavior are already clear;
- acceptance is explicit and verification is deterministic or narrowly inspectable;
- no consequential ambiguity, public-contract migration, hidden acceptance, production/database/deployment action, credentials/private browser state, destructive action, or high-stakes safety/legal/financial judgment;
- the job does not need architecture arbitration or broad cross-module inference;
- no automatic child-agent topology is needed.

Any failed condition routes to Terra Medium root, Terra High implementation, or the existing S3/S4 path. A failed check or unresolved uncertainty causes a narrow retry only when safe; otherwise fall back to Terra without reopening routine Human approval.

## Non-goals

- No change to `C:\Users\32027\.codex\config.toml`, `.codex/agents/*.toml`, permanent model defaults, agent limits, or plugin/MCP configuration.
- No claim of guaranteed token, price, latency, quality, or pass-rate improvement.
- No production, database, deployment, restart, remote mutation, credentialed browser, commit, push, cleanup, or destructive Git/filesystem action.
- No parallel write agents, nested delegation, or use of Ultra for the daily pilot.
- No rewriting or reverting unrelated dirty capability-layer or TaoLong adoption work.

## Exact Allowlist

- `AGENTS.md`
- `README.md`
- `docs/model-routing-policy.md`
- `docs/route-policy.md`
- `docs/skill-routing-policy.md`
- `docs/capability-policy.md`
- `scripts/capability-layer-self-test.ps1`
- `scripts/model-routing-pilot-self-test.ps1` (new)
- `tests/fixtures/model-routing-pilot-cases.json` (new)
- `tasks/HARNESS-56-LUNA-DAILY-ROUTING-PILOT.md` (this frozen packet; no edits after freeze)
- `audits/HARNESS-56-LUNA-DAILY-ROUTING-PILOT-gate-report.md` (new)

## Acceptance Matrix

| ID | Acceptance | Required evidence |
| --- | --- | --- |
| A1 | Daily default remains low-friction and reversible. | Policy says no extra thread/skill/formal gate for eligible S0-S2; Terra Medium remains fallback; no config edits. |
| A2 | Luna Xhigh eligibility and exclusions are deterministic. | Machine-readable fixtures cover eligible and ineligible S0-S4 cases and pass a local self-test. |
| A3 | Review independence is preserved. | Policy and tests reject Luna implementation + Luna verification for the same reviewed milestone. |
| A4 | Actual model use is observable and honest. | Route evidence records model, reasoning, role, direct/delegated topology, checks, retries, and unavailable metrics; policy states static files cannot force runtime selection. |
| A5 | Real no-side-effect comparison runs succeed. | Fresh Luna Xhigh and Terra Medium agents receive the same frozen read-only cases; outputs are scored against the fixture contract. |
| A6 | Existing capability routing does not regress. | Existing capability-layer and relevant Harness self-tests pass. |
| A7 | No scope or safety drift. | Final diff is allowlist-only; no config, secret, production, deployment, database, destructive, commit, or push action. |
| A8 | Independent acceptance is completed. | A fresh Luna read-only verifier issues GO, CONDITIONAL GO, or NO-GO over the final diff and evidence; authorized NO-GO findings are narrowly repaired and rechecked. |

## Experimental Measurement

For each real comparison record: fixture version/hash, actual model and reasoning when exposed, valid/invalid output, routing accuracy, verification-plan accuracy, unsafe overreach, extra agent/tool proposals, elapsed time if exposed, and platform-reported usage if exposed. Missing usage or hidden runtime behavior must be marked unavailable rather than inferred.

The experiment establishes route-contract compliance only. It cannot by itself prove production coding quality, end-to-end cost, or long-horizon reliability. A permanent switch would require sampled live S1/S2 work with comparable acceptance checks and rollback data.

## Stop Conditions

Stop only if the acceptance contract must materially change, a permanent/config mutation is required, a real safety boundary is reached, verification cannot run without forbidden access, or the same blocker survives the allowed narrow repair loop. Routine implementation, tests, narrow repair, and independent review continue under the Human's existing GO.

