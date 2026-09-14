# HARNESS-56 Luna Daily Route — Migration Follow-up

Status: FROZEN  
Frozen: 2026-08-03  
Parent contract: `tasks/HARNESS-56-LUNA-DAILY-ROUTE.md`  
S-level: S2 narrow consistency repair authorized by the durable-route objective

## Finding

Independent review found that the active migration guide still described Terra Medium as the daily root. Related migration/health/self-test code also omitted `luna_qa` and checked the old root model. This would let onboarding reintroduce the two problems the durable route is intended to prevent.

## Goal

Align the project-scoped runtime template, migration path, health check, and migration documentation with the durable route:

- project root template: `gpt-5.6-luna` / `xhigh`;
- preserve `max_threads=2` and `max_depth=1`;
- migrate and health-check `luna_qa`, `terra_worker`, and `luna_verifier`;
- keep role semantics: S2 Luna QA is same-family, S3/S4 Terra→Luna is independent;
- do not read or modify the user-level `C:\Users\32027\.codex\config.toml` or any credential/environment/auth data.

## Exact Allowlist

- `.codex/config.toml` (only the project-scoped `model` and `model_reasoning_effort` keys)
- `docs/install-hooks-upgrade.md`
- `scripts/migrate-project-harness.ps1`
- `scripts/harness-self-test.ps1`
- `scripts/health-check.ps1`
- `tasks/HARNESS-56-LUNA-DAILY-ROUTE-FOLLOWUP.md` (this frozen Packet; no edits)
- `audits/HARNESS-56-LUNA-DAILY-ROUTE-gate-report.md` (root only)

## Acceptance

1. Safe literal inspection shows project `.codex/config.toml` selects Luna Xhigh and retains thread/depth limits; no other project config field changes.
2. Migration installs all three role files in plan/apply paths.
3. Health/strict checks require Luna Xhigh root and validate `luna_qa` alongside the existing roles.
4. Harness self-test expects Luna Xhigh and all three roles.
5. Migration guide has no Terra-daily-default residue and explains same-family versus independent review.
6. Daily-route, capability-layer, Harness, and strict health checks pass where safe.
7. Same independent read-only reviewer rechecks the original finding and the final combined evidence.

## Forbidden

No user-level config access, secrets, deployment/database/remote actions, destructive cleanup, commit, push, or unrelated dirty-file rewrites. Do not modify any other key in project `.codex/config.toml`.

