# HARNESS-56 Capability Layer Gate Report

Task ID: `HARNESS-56-CAPABILITY-LAYER`

Status: `GO - LOCAL GATES AND FINAL SOL READ-ONLY REVIEW PASS`

Decision: `GO`

## Baseline

- Packet: `tasks/HARNESS-56-CAPABILITY-LAYER.md`
- Frozen Packet SHA-256: `3ade4a21dde652fb70d4be461613151d7ee6fd726ca96d2ab0a86dccea5e6450`
- Repository baseline: `6e469b82f1cf4cb03d6f316debb5d55beeba3d53` on `master`.
- Inherited repository dirt: `docs/install-hooks-upgrade.md`, `scripts/harness-self-test.ps1`, `scripts/migrate-project-harness.ps1`, `audits/TAOLONG-HARNESS-LATEST-ADOPTION-gate-report.md`, and `tasks/TAOLONG-HARNESS-LATEST-ADOPTION.md`.
- A final SHA-256 comparison confirmed all five inherited dirty files remain byte-identical to the frozen baseline.
- Existing user-Skill inputs were hashed before modification. The durable before/after manifest is below.

| User-Skill path | Baseline SHA-256 | Final SHA-256 / state |
| --- | --- | --- |
| `code-audit-fix/SKILL.md` | `a739cc3c08d239b8f17e629ba7820d837e8079f01f24c66ca2b16a6e7490ad81` | `5909e97bb4d82538fe65eca4c888ae471c466b03e8ee7f0b10e147ad5112ffb2` |
| `code-audit-fix/agents/openai.yaml` | `11a2f0cca05895f84ce3323d460fd42bddbb92702f3f3bd9f931dbe84259b844` | `d9aaa717aabf51157761cf4f9e2246102656b536a8dfb7f519a144eb19ef1980` |
| `lab-ai-delivery/SKILL.md` | `6f38537a4579ed7efd6f26ed524ee0a7a48797c6f78206974c8292b72e2e66c3` | `92435fe85bd0b1aa409009339a84bbd2db18280ba7431e8670be1dae1a810be0` |
| `lab-ai-delivery/agents/openai.yaml` | `87efe36ebeda075f70f06d2e591cb84f7c42bca8c58def040d6e1a607a22b392` | `45107c6e2c7da108c5773c61c4f3f6d66ddb1fc5d051884e56ee2830c1f09531` |
| `lab-ai-delivery/references/task-packet-template.md` | `6d5405305eaf55112bf41dcfb25de0cde3cfaf2289d9d825f4ca86521460128d` | `bab02f3e686b758cb0c45dd2d39bd1e601d517308bb7d7b5d21b232dca7b42f7` |
| `lab-ai-delivery/references/gate-report-template.md` | `9ac8bd822aca52075ef5a5609c0c531af292a27f06dad9ecca46b68c590eeadb` | `c3bdd20f3bd91d2f918af6701093a214bd6b8da7c40b9bbdc04c898604a1c72a` |
| `lab-ai-delivery/references/risk-levels.md` | `bb3374509fae12024da4a45c42422ac523ebe7449f043c96aceb130eb19f4185` | `7eeae6bd4d829c8c1e81529d37181e8d2c2350a982aaf0d85ab8efa005c6756f` |
| `lab-ai-delivery/references/claude-review-template.md` | `ca9679daa16c9598ed33550d431fbc3c0a731656709d59e87aed9ea517c18bf0` | removed |
| `lab-ai-delivery/scripts/scope-gate.ps1` | `3cf81f4fe63ceaee99150950453ce0d2cf15055256236fa449e6efd249ca3070` | `aeeafd6149e8f190d112c665573d2771d8b6d7194c49cb6c57419ab58d49bbfa` |
| `lab-ai-delivery/scripts/codegraph-gate.ps1` | `be17bcd82c5e3fe77b0f7181223764169e4a7b8edc800ddf670a2aaaa4d59781` | `8262f470625f6616713f6163219e3572d16094ef5abe60ce06ee6d117326a39f` |
| `lab-ai-delivery/scripts/local-gate.ps1` | `76c969cc467a6a1521320e4f8ac9a816a3fca6553ba165ac78c3e4e67679b8c6` | `6ccefe463eab5ad4f585e763df991ffed92dc9d77a4f8e476371ca626a339266` |
| `lab-ai-delivery/scripts/review-module.ps1` | `4a37635490cd1c4c240d3ab128c20dd804bd7834d7144e3c6ec1054d0fb62103` | `8869dc6a31266511be61c8f1a776069f672d53d17f2d6ac8c637d3e113f95529` |
| `lab-ai-delivery/scripts/claude-review.ps1` | `64ed1068a1fda3df458635a920a88e7b594a0e2902102f5b0eb75690ab5917f9` | removed |

## Changed Files

Repository module delta:

- `AGENTS.md`
- `README.md`
- `docs/autonomous-goal-workflow.md`
- `docs/capability-policy.md`
- `docs/model-routing-policy.md`
- `docs/route-policy.md`
- `docs/skill-routing-policy.md` (new)
- `templates/context-capsule.md`
- `templates/feature-plan.md`
- `templates/handoff.md`
- `templates/task-brief.md`
- `scripts/capability-layer-self-test.ps1` (new)
- `tests/fixtures/capability-routing-cases.json` (new)
- `tasks/HARNESS-56-CAPABILITY-LAYER.md` (new and frozen)
- this Gate Report

User-level Skill delta under `C:\Users\32027\.codex\skills`:

- revised `code-audit-fix/{SKILL.md,agents/openai.yaml}`;
- revised `lab-ai-delivery` Skill, UI metadata, three references, and four optional helper scripts;
- removed the old external-executor review script/template;
- added `feature-discovery`, `feature-development`, `architecture-refactor`, `community-research`, and explicit-only `last30days-public`, each with `SKILL.md` and `agents/openai.yaml`.

No configuration, Hook, model/agent config, old Packet/report, inherited dirty path, production/database/deployment state, secret, browser profile, or Git history operation was changed by this task.

## Acceptance Evidence

1. `code-audit-fix` now starts with S-level/Skill/verification, preserves review-only and dirty-worktree boundaries, uses evidence -> root cause -> minimal repair -> focused verification, allows three bounded focused attempts, and has no file-count/layer-count escalation.
2. `lab-ai-delivery` now triggers only for explicit formal delivery or S4. It uses a current frozen Packet, exact scope, project-native checks, automatic narrow repair, one-GO continuity, and independent read-only review. Plan Mode, Claude dependency, second GO semantics, default `master`, and fail-immediately orchestration were removed.
3. All five requested composable Skills were initialized with Skill Creator, kept resource-minimal, and passed the official validator. `last30days-public` sets `policy.allow_implicit_invocation: false`.
4. Harness policy now selects S-level first, then direct work, a narrow Skill, or formal delivery. It preserves no-ceremony S0/S1, root-direct clear S2, and default Terra worker + Luna review only for S3/S4.
5. Policies define job-shaped `rg`/CodeGraph/`node_repl`/browser use, limited Context Capsules, exact handoffs, no parallel writers, `max_depth=1`, daily `max_threads=2`, and stable root models routed only at natural boundaries.
6. The one-GO lifecycle explicitly continues through normal implementation, checks, focused repair, and review. Stop conditions are authority expansion, unsafe/impossible verification, or the same blocker after three focused attempts.
7. The deterministic self-test checks legacy residues, trigger boundaries, dangerous research behavior, explicit-only metadata, cross-document routing consistency, PowerShell parsing, and five routing fixtures.
8. Cost ranges are labeled estimated structural targets and paired with a sampled-task measurement plan. No actual token, productivity, pass-rate, or safety result is claimed.

## Sol Routing Smoke Checks

These were real read-only routing decisions made in the authorized Sol root and encoded as inspectable fixtures; the self-test verifies the expected contract. They are not represented as platform-level enforcement.

| Case | Expected route | Verification evidence |
| --- | --- | --- |
| Known small parser regression | S1, `code-audit-fix`, root-direct | failing unit test plus focused regression check |
| Clear CSV preview feature | S2, `feature-development`, root-direct | vertical-slice behavior test plus affected package check |
| Ambiguous project-sharing visibility | S2, `feature-discovery`, root discovery | compact acceptance/compatibility/authorization/assumption/route contract |
| Read-only notification architecture refactor | S0, `architecture-refactor`, root read-only | behavior baseline, impact, options, staged migration, rollback checks |
| Explicit public last-30-days research | S0, `last30days-public`, public Web read-only | fixed window, dated citations, facts/signals/inference/limits |

## Checks Run

- `./scripts/capability-layer-self-test.ps1` - PASS, 101 assertions.
- Skill Creator `quick_validate.py` for all seven revised/new Skills - PASS, seven of seven.
- `./scripts/harness-self-test.ps1` - PASS, including Hook, Goal state, scope/hash, report, feature-plan, migration, and health fixtures.
- `./scripts/health-check.ps1 -Strict` - PASS, including required-file, JSON/TOML shape, PowerShell parser, scope, and CodeGraph-fallback checks.
- `./scripts/scope-check.ps1 -Strict -AllowedPath <Packet allowlist plus inherited baseline paths>` - PASS.
- Manual SHA-256 comparison for the five inherited dirty paths - PASS, zero mismatches.
- `git diff --check` - PASS; Git emitted only expected LF-to-CRLF working-copy warnings.
- Final parser check for the new Harness self-test and four revised formal-delivery helper scripts - PASS.

Focused repair evidence:

- Standardized `project-native verification` terminology after the new consistency fixture caught a wording mismatch.
- Tightened S-level/root-direct fixture matching and route wording rather than weakening the intended policy.
- Corrected Windows PowerShell 5 JSON-array handling in the smoke fixture.
- Restored the existing `feature-plan` primary `S-Level: S2` contract after the inherited self-test caught an incompatibility, while keeping explicit S3 escalation text.
- Replaced non-ASCII aliases in the explicit 30-day Skill description after Windows Python's default GBK decoder rejected the UTF-8 file; trigger behavior remains explicit and the validator now passes.

## Scope Guard

PASS. Repository changes consist of the Packet allowlist plus the five pre-existing dirty paths, whose hashes are unchanged. User-Skill changes match the Packet's external allowlist. No frozen Packet was modified after its hash was recorded. No unrelated files were written.

## Skipped Checks

- CodeGraph: skipped because this is Markdown/PowerShell policy and isolated Skill content with obvious ownership; compensated by `rg`, direct file/diff inspection, parser checks, and deterministic fixtures.
- Browser/UI and `node_repl`: skipped because no live UI or stateful JavaScript behavior is under acceptance.
- Live community/30-day Web research: skipped because the acceptance target is safe routing/report behavior, not a time-sensitive subject-matter answer.
- Terra/Luna/Claude or subagent review: intentionally skipped under the Human's task-scoped Sol-only execution exception. Final review is a separate read-only Sol pass.
- Migration script edits: skipped as unnecessary. User-level Skills are not project migration assets, and the inherited dirty migration/self-test changes were preserved byte-for-byte.

## Known Limitations

- Codex runtime Skill selection and tool calls cannot be mechanically enforced or proven by static Markdown. The fixture proves that the documented route contracts are present and internally consistent; actual behavior requires sampled runtime observation.
- The structural cost bands are estimates relative to an old GPT-5.5 workflow, not measured outcomes or guarantees. The policy defines what to count in future samples.
- Hooks remain guardrails, not a sandbox. Existing security fixtures passed, but documentation cannot create isolation by itself.
- User-level Skills are outside repository Git history; baseline/final hashes and local validation provide evidence, not a repository commit diff.
- The desktop Goal record was created moments before the Packet file was frozen rather than after it. No implementation edit occurred before the Packet freeze, so the authorization boundary governed all mutations, but the historical ordering cannot be retroactively changed and is disclosed rather than represented as exact procedural compliance.

## Residual Risk

Low policy-adoption risk remains: an agent may fail to select the intended Skill despite correct metadata, or may over/under-classify S-level. Explicit trigger descriptions, route fixtures, low-overhead defaults, and sampled-task measurement are the mitigations. No production/runtime behavior was changed.

## Final Read-Only Review

Sol-only decision: `GO`.

- Daily friction: GO. S0/S1 remain direct, clear S2 remains root-direct, Skill selection creates no required child task/model switch/document/extra GO, and formal delivery is narrow.
- Safety boundaries: GO. Existing Hook safety fixtures pass; research Skills prohibit install/cookies/private sessions/keys/paid services/default writes; architecture is read-only by default; Hooks are not called a sandbox.
- Document/template/script consistency: GO. Route, capability, model, Goal, templates, Skill metadata, helper scripts, and deterministic fixtures agree on the same S-level and one-GO semantics.
- Scope drift: GO. All module writes are allowlisted, inherited dirt is hash-identical, and model/agent/MCP configuration is untouched.
- Unsupported claims: GO. Cost bands are explicitly estimates; runtime Skill selection, safety, productivity, pass rate, and actual token use are not claimed as statically proven.
- Test evidence: GO. The report records real command outcomes, initial failures, narrow repairs, reruns, skips, and compensations.

No P0, P1, or P2 artifact finding remains. The Goal/Packet creation-order observation is recorded under Known Limitations; it did not precede or authorize any implementation mutation and does not require a code or policy repair.

## Next Recommended Action

Human reviews this evidence and either accepts it or opens a new task. Branch finish, commit, push, PR, merge, cleanup, and further Harness work remain separately unauthorized.
