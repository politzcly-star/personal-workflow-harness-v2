# Release checklist
Use with release-deploy, not a second approval chain.
Task / environment / service:
Current version / immutable desired artifact or digest:
Build/config/preflight checks and results:
Impacted services / data changes:
Concrete authorization source, exact scope and UTC window (never agent-issued approval):
Repeat-safe commands or immutable reviewed runner:
Health + business smoke + released version / timeout:
Abort / previous artifact / authorized rollback / rollback checks:
Separate data backup/restore/migration authority:
Redacted evidence / no raw credentials:
Per-target execution lock owner:
Actual deploy/rollback evidence:
Skipped checks / residual risk / final status:

## Early read-only readiness
Confirm correct target/alias, required Git base, toolchain, trusted approval transport and rollback availability once before release-dependent work. A signature template or runner file is not a live grant. Keep blockers scoped; continue independent local work. At release, revalidate immutable artifact/version and live target state; never reuse stale production health as current evidence.
