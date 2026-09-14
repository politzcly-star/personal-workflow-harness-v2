# HARNESS-56 Luna Daily Route — Gate Report

Status: GO  
Date: 2026-08-03  
Frozen contract: `tasks/HARNESS-56-LUNA-DAILY-ROUTE.md`

## Route Decision

The Human approved the new durable daily route without a backup:

- S0: Luna Xhigh root direct, no routine review.
- S1: Luna Xhigh root direct plus one focused deterministic check; Luna Medium QA only after first-check failure, a narrow repair, or a boundary.
- S2: Luna Xhigh root implementation plus one compact Luna Medium read-only QA pass after checks.
- S3/S4: existing Terra High implementation plus Luna Medium independent verification.

S2 Luna-on-Luna is same-family QA, not independent verification. Repository policy cannot force the root/composer model; actual runtime identity must be reported when exposed, and off-route work cannot be claimed as route-compliant.

## Baseline

- Freeze HEAD: `6e469b82f1cf4cb03d6f316debb5d55beeba3d53`.
- Worktree was already dirty from HARNESS-56 capability/pilot and TaoLong adoption work; unrelated edits remain user-owned.
- Existing `terra_worker` role file: Terra High, workspace-write.
- Existing `luna_verifier` role file: Luna Medium, read-only.
- Observed issue 1: one named verifier run used an actual Sol model, so role name/config alone did not prove runtime identity.
- Observed issue 2: some recent daily roots ran Sol Xhigh/Ultra and used unnecessary direct heavy work or delegation, despite the intended low-friction policy.
- Prior matched experiment: Luna Xhigh understood 12/12 route boundaries but did not satisfy a strict output schema; Terra Medium satisfied it. This motivates deterministic checks and structured QA, not a universal quality claim.

## Acceptance Evidence

| ID | Evidence | Result |
| --- | --- | --- |
| A1 | Active AGENTS/README/policies/workflow/templates consistently define the durable Luna S0-S2 route and preserved Terra→Luna S3/S4 route; active-residue search found no pilot/candidate or Terra-daily-default conflict. | GO |
| A2 | `daily-model-routing-cases.json` covers all required levels and triggers; the self-test derives actions from inputs and passed 319 assertions. | GO |
| A3 | New `.codex/agents/luna-qa.toml` pins Luna Medium/read-only and labels same-family QA; active docs/templates reserve `luna_verifier` for independent Terra implementation review. | GO |
| A4 | Derived cases reject Luna-QA-as-Sol, Luna-verifier-as-Sol, and Terra-worker-as-Luna verdicts and require one correct-role rerun; child report records expected/actual identity when exposed. | GO |
| A5 | Negative cases reject S0 ceremony, S1 first-pass child/heavy tools, S2 Terra writer/repo-wide QA/transcript/parallel writers, Ultra/max, and depth >1. | GO |
| A6 | Capability-layer self-test passed 106 assertions; changed PowerShell parses; targeted diff check passed. | GO |
| A7 | Fresh Luna Xhigh root smoke returned the strict 7-case contract exactly; a fresh Luna Medium QA then passed all 37 field checks and explicitly reported `independent=false`. | GO |
| A8 | Separate `luna_verifier` reviewed the original implementation, raised the active migration inconsistency, and returned GO after the frozen narrow follow-up and full recheck. | GO |

## Test Evidence

- `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\daily-model-routing-self-test.ps1` — PASS, 319 assertions.
- `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\capability-layer-self-test.ps1` — PASS, 106 assertions.
- Targeted `git diff --check` over the Packet implementation allowlist — PASS; only Git LF→CRLF notices, no whitespace errors.
- Active-policy residue search for `luna_daily_pilot`, candidate/reversible pilot, Terra daily default, and S2 Terra-worker routing — no matches.
- Agent-contract checks passed for `luna_qa` (Luna Medium/read-only), `luna_verifier` (Luna Medium/read-only), and `terra_worker` (Terra High/workspace-write).
- `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\harness-self-test.ps1` — PASS, including migration dry-run/apply, config replacement, all three roles, legacy AGENTS preservation, hooks, safety, and scope fixtures.
- `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\health-check.ps1 -Strict` — PASS, including Luna Xhigh project root, `max_threads=2`, `max_depth=1`, and all three role contracts.

## Real Side-Effect-Free Smoke

| Role | Dispatch | Task | Result |
| --- | --- | --- | --- |
| Daily root | `gpt-5.6-luna` / xhigh, explicit desktop project task | `019fc57d-fd3b-7c62-ade0-b15573f37409` | PASS in 24.147 s: strict JSON, 7/7 cases; no tools/children; rejected overweight S1 and invalidated exposed Luna-QA/Sol drift. |
| S2 QA | `gpt-5.6-luna` / medium, explicit read-only project task | `019fc57e-cd14-70d1-8d11-a8d7ca9a4a65` | GO in 8.736 s: 37/37 fields, `qa_role=luna_qa`, `independent=false`, no findings. |

These tasks validate that the route contract and same-family QA can be followed on this surface. They do not prove automatic composer selection, long-horizon coding quality, or normalized cost.

## Independent Review Follow-up

The first independent review returned CONDITIONAL GO because active onboarding still described Terra Medium as the daily root. A frozen narrow follow-up then:

- changed only the project-scoped `.codex/config.toml` `model` and `model_reasoning_effort` keys to Luna Xhigh while preserving thread/depth limits and every other field;
- added `luna_qa` to migration dry-run/apply, strict health, and Harness fixtures;
- aligned the migration guide with S2 same-family QA and S3/S4 independent Terra-to-Luna review;
- reran all route, capability, Harness, strict health, and targeted diff checks successfully.

The user-level `C:\Users\32027\.codex\config.toml` was never read or modified.

## Skips And Limits

- The user-level `C:\Users\32027\.codex\config.toml` remains out of scope. The project-scoped root template now selects Luna Xhigh, but the Human/platform-selected actual composer remains authoritative at runtime.
- Static files and role TOML can pin intended child identities but cannot prove the actual runtime model. A gate checks actual identity only when the platform exposes it; otherwise it records identity as unavailable rather than inventing proof.
- No token, price, latency, quality, pass-rate, productivity, or safety improvement is guaranteed.
- Historical pilot Packet/report/fixture/script remain evidence and are not active policy.
- Full Harness and strict health checks passed after the narrow project-scoped runtime follow-up.

## Final Gate

**GO.** A1-A8 passed. The first independent review's Terra-daily-root migration finding was repaired and closed by the same read-only reviewer.

- Model-role drift: **resolved at the Harness acceptance layer**. When actual identity is exposed, a mismatched child verdict is rejected, drift is recorded, and the correct named role may rerun once. Static files cannot guarantee the platform never drifts, so unexposed identity remains honestly unavailable.
- Overweight daily work: **resolved by route limits**. S0 has no routine ceremony; S1 first-pass success has no child and one focused check; S2 uses no implementation worker and exactly one compact same-family QA; S3/S4 preserve Terra High implementation plus independent Luna Medium verification.
- Runtime consistency: project root template, migration plan/apply, strict health, Harness fixtures, active documentation, and role TOML now agree on Luna Xhigh daily root and the three role contracts.

No commit or push was performed.
