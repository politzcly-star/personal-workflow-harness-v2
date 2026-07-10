# Route Policy

Choose S-level first. Name a route only when it changes the work, checks, or safety boundary.

## S-Level

| Weight | Meaning | Minimum evidence |
| --- | --- | --- |
| S0 | Discussion, prompt help, read-only analysis. | Direct answer. |
| S1 | Known, narrow edit. | Changed files and focused check. |
| S2 | Bounded multi-file implementation. | Scope, focused checks, skipped-check reason, residual risk. |
| S3 | Hidden acceptance or boundary risk. | Explicit scope plus Luna review or an equivalent checklist. |
| S4 | Multi-milestone product or formal delivery. | Milestone packet, evidence, and independent review. |

S-level is the only required weight label. Do not add a separate layer field.

## Routes

| Route | Select when | Required adjustment |
| --- | --- | --- |
| `lightweight_fix` | Clear S1 edit. | Narrow edit and focused check. |
| `audit_fix` | Failure, regression, or suspicious behavior. | Reproduce/localize, then verify the repair. |
| `structural_localization` | Ownership or impact is unclear. | Use `rg`; use CodeGraph only when relationships matter. |
| `feature_discovery` | Requirements or alternatives are unresolved. | Short decision and acceptance note before implementation. |
| `feature_plan` | Bounded S2 work needs sequencing. | Compact plan, scope, checks, and stop conditions. |
| `docs_assisted` | Current platform documentation can change the decision. | Use authoritative documentation. |
| `review_gated` | Boundary, public contract, hidden acceptance, or comparable risk. | Luna review or a risk-specific checklist. |
| `deployment_route` | Production config, CI/CD, reload/restart. | Dry-run/config-test, rollback, and operator boundary. |
| `server_inspection` | Read-only remote inspection through a configured alias. | Redacted read-only evidence only. |
| `database_route` | Schema, SQL, import/export, or persistent data. | Impact preview, rollback, and no writes without fresh approval. |
| `branch_finish` | Commit, push, PR, merge, discard, or cleanup. | Inspect branch/worktree and require approval for destructive action. |
| `lab_ai_delivery` | Human requests formal audit-grade delivery. | Task Packet, gate evidence, and independent review. |

## Escalation

- Stay in the root `gpt-5.6-terra` Medium task for clear S0-S2 daily work.
- The root owns architecture and acceptance; stop for the Human only when a real decision cannot be inferred safely.
- Use `terra_worker` for bounded delegated implementation and `luna_verifier` once per S3/S4 milestone or required independent review.
- Treat secrets, permissions, production, database, deployment, and destructive operations as high-risk regardless of diff size.

External execution is not a route. It is a Human-enabled optional adapter described in `docs/external-executor-workflow.md`.
