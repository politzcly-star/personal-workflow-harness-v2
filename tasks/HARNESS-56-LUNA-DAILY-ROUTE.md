# HARNESS-56 Luna Daily Route

Status: FROZEN  
Frozen: 2026-08-03  
Decision owner: root goal owner; Human approved this as the durable daily route  
S-level: S3 (routing behavior, hidden runtime identity, and daily-cost risk)  
Skills: `architecture-refactor`, then `feature-development`; final review uses a separate read-only agent

## Goal

Replace the reversible Luna pilot with the durable daily route below, without backing up the superseded route:

| Level | Durable route |
| --- | --- |
| S0 | Luna Xhigh root direct; no routine Skill, child, or review. |
| S1 | Luna Xhigh root direct plus one deterministic focused check. Luna Medium QA is triggered only when the first check fails, a narrow repair was needed, or a boundary/uncertainty appears. |
| S2 | Luna Xhigh root implements directly, runs focused checks, then one Luna Medium read-only QA pass over the compact contract, final diff, and evidence. This is same-family QA, not independent verification. |
| S3/S4 | Preserve the existing route: root freezes scope; Terra High implements; Luna Medium performs independent read-only verification. |

The route must fix two observed problems: a named verifier once ran with the wrong actual model, and some daily work used unnecessarily heavy roots/agents/tools.

## Baseline

- Freeze HEAD: `6e469b82f1cf4cb03d6f316debb5d55beeba3d53`.
- Worktree already contains user-owned HARNESS-56 capability, Luna pilot, and TaoLong adoption changes. Preserve all unrelated dirty content.
- `.codex/agents/terra-worker.toml` is pinned to `gpt-5.6-terra` / high / workspace-write.
- `.codex/agents/luna-verifier.toml` is pinned to `gpt-5.6-luna` / medium / read-only.
- Recent runtime evidence showed one role/model mismatch despite a correct role file. Therefore static names/config are necessary but not sufficient; acceptance must check actual exposed runtime identity.
- The matched route experiment showed Luna Xhigh classified 12/12 routing boundaries correctly but failed a strict output schema, while Terra Medium satisfied the same strict schema. The new route therefore requires deterministic checks and compact structured QA rather than claiming universal Luna superiority.

## Model And Role Identity Contract

1. The first progress/evidence line records S-level, selected route, expected model/effort/role/topology, and actual model/effort/role/topology when the platform exposes them.
2. Root/composer identity remains controlled by the Human/platform. Repository files cannot silently force it, and this task must not read or modify `C:\Users\32027\.codex\config.toml` or project `.codex/config.toml`.
3. Named child roles are invoked without manual model override. Before accepting a child verdict, compare the exposed runtime model/effort with the role contract.
4. If a child role/model mismatch is exposed, its verdict does not satisfy the gate. Record the drift and re-run the correct role once at the same boundary. Do not open extra agents merely to investigate an unexposed identity.
5. If an already-running root is off the desired Luna Xhigh route, do not create a replacement child solely to correct it. Record the off-route run, finish safely when possible, and correct selection at the next natural task boundary. Never claim an off-route run as route-compliant.
6. S2 Luna Medium is explicitly `luna_qa` (same-family QA). S3/S4 Luna Medium is `luna_verifier` (independent from Terra implementation). These verdicts are not interchangeable.

## Daily Weight Guard

- S0: no formal plan, Task Packet, Skill, CodeGraph, browser, child, review, or Context Capsule unless the task is reclassified.
- S1: root direct, `rg`/file read only as needed, at most one narrow Skill when it changes the check, one focused verification command, and no child on first-pass success.
- S2: no implementation worker; one compact Luna Medium QA only after root checks pass. QA receives no transcript and does not re-explore the whole repository unless the diff reveals an unclear relationship.
- S3/S4: existing one Terra writer plus one Luna verifier per milestone; no parallel writers, `max_depth=1`, and no automatic Ultra/max.
- A failed S1/S2 check permits one narrow root repair before reclassification. Repeated failure, hidden acceptance, architecture arbitration, public-contract risk, production/database/deployment, credentials/private state, destructive action, or high-stakes judgment moves out of the daily lane.

## Exact Allowlist

- `AGENTS.md`
- `README.md`
- `.codex/agents/luna-qa.toml` (new)
- `docs/model-routing-policy.md`
- `docs/route-policy.md`
- `docs/skill-routing-policy.md`
- `docs/capability-policy.md`
- `docs/autonomous-goal-workflow.md`
- `docs/developer-efficiency-mode.md`
- `docs/parent-child-execution.md`
- `templates/project-agents.md`
- `templates/project-profile.md`
- `templates/child-report.md`
- `scripts/capability-layer-self-test.ps1`
- `scripts/daily-model-routing-self-test.ps1` (new)
- `tests/fixtures/daily-model-routing-cases.json` (new)
- `tasks/HARNESS-56-LUNA-DAILY-ROUTE.md` (this frozen Packet; no edits after freeze)
- `audits/HARNESS-56-LUNA-DAILY-ROUTE-gate-report.md` (new)

The historical pilot Packet, fixture, script, and Gate Report remain evidence and are not active policy. Do not modify them in this task.

## Acceptance Matrix

| ID | Acceptance | Evidence |
| --- | --- | --- |
| A1 | Active docs consistently implement the S0/S1/S2/S3/S4 table above and contain no active candidate/pilot-default ambiguity. | Cross-document deterministic assertions and literal residue checks. |
| A2 | S1 first-pass success has no child; S1 failure/boundary has one Luna Medium QA; S2 has exactly one post-check Luna Medium QA; S3/S4 preserve Terra High plus Luna Medium verifier. | Machine-readable cases and derived-route self-test. |
| A3 | `luna_qa` and `luna_verifier` are semantically distinct and same-family S2 QA is never called independent verification. | Agent role file, docs, fixtures, and negative assertions. |
| A4 | Role/model drift is detected before a child verdict satisfies a gate. | Fixtures cover correct and mismatched runtime identities; self-test rejects mismatches and requires one bounded re-run. |
| A5 | Small work cannot silently become heavy. | Tests reject S0 ceremony, S1 first-pass child/Skill/CodeGraph/review, S2 implementation worker or repo-wide QA, Ultra/max, parallel writers, or depth >1. |
| A6 | Existing capability selection and S3/S4 safety boundaries do not regress. | Capability self-test plus route-specific negative cases. |
| A7 | Real side-effect-free smoke checks exercise S0, S1 success, S1 failure, S2 QA, S3, and runtime drift decisions. | Recorded actual model/role when exposed; no claim that static files force runtime choice. |
| A8 | Final allowlist diff and evidence receive a separate read-only agent verdict focused on usability, drift, and overweight behavior. | GO, CONDITIONAL GO, or NO-GO; authorized findings repaired narrowly and rechecked. |

## Non-goals And Forbidden Actions

- No backup of the superseded route.
- No read or modification of global/project `config.toml`, secrets, environment credentials, auth stores, browser private state, or global MCP/plugin configuration.
- No production/database/deployment/restart/remote mutation, destructive file/Git action, commit, push, branch cleanup, or paid action.
- No guarantee of price, token, latency, quality, productivity, pass rate, or safety improvement.
- No automatic parallel writers, nested agents, Ultra, max, full CodeGraph scan, heavy brainstorming, Task Packet, or Gate Report for ordinary daily work.

## Stop Conditions

Stop only for a material route-contract change, new sensitive/config authority, unsafe unverifiable behavior, or the same real blocker after the bounded repair loop. Routine implementation, deterministic checks, narrow repair, smoke tests, and the required independent final review continue under the Human's approval.

