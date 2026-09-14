# Route policy
AGENTS.md owns S0-S4; model-routing-policy.md owns optional roles. Routes change work/checks, not Human handoff count.

| Signal | Capability | Result |
| --- | --- | --- |
| Bounded feature | feature-development | integrated full-stack slice |
| Consequential ambiguity | feature-discovery | evidence-backed acceptance then authorized implementation |
| Failure/regression | code-audit-fix | original symptom plus nearby regression checked |
| Architecture assessment | architecture-refactor | read-only unless implementation authorized |
| UI/API outcome | acceptance-verify | positive/negative/permission/integration evidence |
| Release/restart/config rollout | release-deploy | preflight, concrete authority, pinned release, checks, bounded rollback |
| Remote read-only | server_inspection | alias-scoped redacted observation |
| Schema/data | database_route | impact preview and separately authorized mutations |
| Commit/push/PR/cleanup | branch_finish | branch/scope inspection and applicable authority |
| S4/formal delivery | lab-ai-delivery | Agent-owned Packet, milestones, independent Gate |
| Practitioner evidence | community-research | source and inference separation |

Legacy deployment_route is an alias for release-deploy, not a second approval process. Database checklist supplements releases only for actual data impact. No duplicate model pins or ceremony labels.
