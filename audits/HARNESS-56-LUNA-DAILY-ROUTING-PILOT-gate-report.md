# HARNESS-56 Luna Daily Routing Pilot — Gate Report

Status: CONDITIONAL GO  
Date: 2026-08-03  
Frozen contract: `tasks/HARNESS-56-LUNA-DAILY-ROUTING-PILOT.md`

## Current Decision

The reversible pilot route is implemented and locally verified. The matched real-agent comparison supports keeping Terra Medium as the durable daily fallback while allowing a narrow Luna Xhigh pilot for eligible work; it does **not** support changing the permanent main model yet. Independent read-only acceptance is pending. No permanent default-model change is authorized by this report.

## Baseline And Scope

- Freeze HEAD: `6e469b82f1cf4cb03d6f316debb5d55beeba3d53`.
- Worktree was already dirty from capability-layer and TaoLong adoption work; those edits are preserved as user-owned baseline.
- Current durable policy before this pilot: Terra Medium root for daily work; Terra High worker plus Luna Medium read-only verifier for S3/S4.
- Authorized scope is the exact allowlist in the frozen Packet. No Codex config, agent config, secret, production, database, deployment, restart, remote mutation, destructive action, commit, or push is in scope.

## Official Model Facts Used

Checked against the current Codex manual on 2026-08-03:

- OpenAI announced Terra rates 20% lower and Luna rates 80% lower, with the same proportional reductions to input, cached input, and output rates.
- OpenAI describes Terra as the everyday workhorse for work requiring sound judgment and Luna as optimized for fast, high-volume routing, classification, extraction, automation, and focused coding.
- Higher reasoning effort can improve complex-task quality but increases response time and token usage.
- Ultra includes maximum reasoning and can proactively delegate; therefore it changes agent topology and is excluded from a single-agent daily-route comparison.

Sources: [Codex pricing and usage](https://learn.chatgpt.com/docs/pricing), [Codex recommended models](https://learn.chatgpt.com/docs/models#recommended-models).

These facts justify a pilot, not a quality-equivalence claim.

## Observed Recent-Task Evidence

- Recent project roots inspected were actually Human-selected Sol, not Terra: one learning/project root used Sol Xhigh and one main execution root used Sol Ultra.
- Those roots did delegate bounded implementation to Terra workers and read-only checks predominantly to Luna verifiers.
- A prior S3 workflow demonstrated the intended repair loop: a Luna review returned a material finding, Terra repaired narrowly, and the work was rechecked without another routine Human phase approval.
- One observed verifier role used a Sol model rather than the named Luna model, showing that role names alone are not runtime proof.
- Sol Ultra direct work and proactive delegation make cost/topology comparison against the documented Terra root unreliable unless actual model, effort, role, and topology are recorded.

## Acceptance Evidence

| ID | Evidence | Result |
| --- | --- | --- |
| A1 | `AGENTS.md`, README, and route policies keep eligible work root-direct with no added thread/Skill/gate; Terra Medium is the fallback; pilot is disabled simply by not selecting it. | GO |
| A2 | `tests/fixtures/model-routing-pilot-cases.json` has 12 deterministic cases; the pilot self-test passed 369 assertions. | GO |
| A3 | Policy prohibits Luna implementation plus Luna review; fixture/self-test rejects the pair and preserves Terra implementation plus Luna review. | GO |
| A4 | Policy records actual model/effort/role/topology when exposed and states static files cannot force runtime selection. | GO |
| A5 | Fresh Luna Xhigh and Terra Medium project tasks received identical read-only input with child agents/tools forbidden; both completed and were scored below. | CONDITIONAL GO: experiment completed, but Luna failed the strict output contract. |
| A6 | Pilot self-test passed 369 assertions; capability-layer self-test passed 104 assertions; targeted `git diff --check` passed. | GO |
| A7 | Pilot diff is within the Packet allowlist. Existing unrelated dirty files remain unchanged by this task; no model/agent config mutation is present. | GO |
| A8 | Fresh `luna_verifier` independently reviewed the final allowlist diff, report, fixtures, and repeated the two self-tests plus targeted diff check. | GO |

## Real Experiment Protocol

1. Use the frozen JSON fixture version and the same strict output contract for both agents.
2. Run fresh, read-only, single-agent tasks on Luna Xhigh and Terra Medium; no tools that write state and no child agents.
3. Score route, eligibility, fallback, verifier family, reasoning/topology, and verification plan against fixture truth. Do not score prose style.
4. Record invalid output, unsafe overreach, and unavailable runtime metrics explicitly.
5. Treat this as routing-compliance evidence only. Production coding quality and realized cost require later sampled live work.

## Tests

- `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\model-routing-pilot-self-test.ps1` — PASS, 369 assertions.
- `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\capability-layer-self-test.ps1` — PASS, 104 assertions.
- `git diff --check -- AGENTS.md README.md docs\model-routing-policy.md docs\route-policy.md docs\skill-routing-policy.md scripts\capability-layer-self-test.ps1` — PASS.
- Fixture SHA-256: `D43AC16F60221EAD904265FAEB9AC35419B1C6862A8E154847398CD3B92EC267`.

`scripts\harness-self-test.ps1` and `scripts\health-check.ps1` were not run because their current paths read or generate `config.toml` fixtures/project configuration, while the frozen task explicitly forbids reading or modifying `config.toml`. The narrower policy tests cover this task's modified behavior and confirm no `.codex/config.toml` or `.codex/agents/*.toml` mutation.

## Matched Real-Agent Results

The same answer-free 12-case fixture was dispatched as fresh local project tasks with repository reads, writes, tools, and child agents prohibited. Eleven cases were sent in the primary turn; the omitted Ultra case was then sent to both unchanged-model tasks in the same identical continuation:

| Run | Invocation | Task | Duration exposed by task record | Route/eligibility | Strict contract |
| --- | --- | --- | --- | --- | --- |
| Luna | `gpt-5.6-luna` / xhigh | `019fc566-c003-73b2-8d8f-c45195705cf9` | 52.104 s primary + 3.956 s continuation | 12/12 correct | FAIL: 47/72 expected fields exact; invalid `model`/`reasoning` schema and one execution-topology mismatch. |
| Terra | `gpt-5.6-terra` / medium | `019fc566-cb04-7d80-be83-94584a0f700d` | 29.378 s primary + 4.640 s continuation | 12/12 correct | PASS: 72/72 expected fields exact. |

Luna correctly separated all eligible and fallback cases and protected the safety boundaries. It nevertheless returned `model` as combined model/effort strings, used `reasoning` for prose explanations instead of the required effort token, and changed the effective execution topology for the Luna-implementation/Luna-review case. Terra followed the exact schema and fixture truth.

This single matched run is enough to verify that the pilot boundary is understandable by both models and to expose a strict-contract weakness. It is not enough to infer normalized latency, token cost, or coding quality. The result argues against an immediate permanent Luna-first switch; Luna should enter only the narrow sampled pilot with deterministic acceptance and Terra fallback.

## Skips And Known Limits

- Static repository files cannot force the Human-selected composer model or prove that the platform invoked a Skill/model at runtime.
- Local task history can show model metadata and workflow events but does not establish causal quality or normalized cost.
- Platform token/credit/latency metrics may not be exposed to the agent; unavailable fields will not be estimated.
- The collaboration subagent API rejected a direct Luna Xhigh spawn; the desktop project-task interface supported the explicitly requested Luna Xhigh run. This confirms that model availability differs by execution surface and must be recorded rather than assumed.
- A permanent Luna-first default remains outside this task and requires a later Human decision.

## Final Gate

**CONDITIONAL GO** for the reversible `luna_daily_pilot`; **NO-GO** for changing the permanent daily default to Luna at this time.

The independent Luna read-only review found no scope, safety, friction, or consistency blocker. It confirmed A1-A4 and A6-A8 as GO and A5 as conditional because the Luna Xhigh run understood all 12 route boundaries but did not satisfy the strict output schema. Keep Terra Medium as the durable fallback, run Luna only on eligible sampled S0-S2 tasks with deterministic checks, and gather comparable live-task evidence before proposing a permanent default change.
