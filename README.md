# 个人工作流 v2 - Agent-Native Delivery Harness

本仓库用于设计 **Agent-Native Delivery Harness**：让 agent 自主组织计划、拆分、并行执行和汇总，但由人类、Evaluator 与 artifacts 共同约束它的方向和边界。

v2 不替代 v1。`D:\个人工作流` 仍保留为 Workflow-first / 稳定边界型 Harness，适合固定流程自动化、明确 bugfix、强审计任务和低创造力高稳定性场景。v2 只探索任务目标清楚但路径不确定、需要多 agent 编排和父线程合成的工作方式。

v2 是 `goal-first / agent-orchestrated control plane`：它把 North Star、Dispatch Matrix、Child Report、Evaluator Gate Card、Parent Synthesis 和 Evidence Index 组织成可审阅的控制面。Phase 2 仍然是纯文档/模板层最小闭环，不实现 runner、CI、Docker、浏览器自动化、GitHub issue tracker integration、生产系统操作或任何自动化执行框架。

## Phase 1 定位

Phase 1 只做架构和核心模板：

- 不实现 runner。
- 不接 CI。
- 不接 GitHub issue tracker。
- 不做 eval infra。
- 不做 Docker、浏览器自动化或生产环境操作。
- 不迁移 v1 文件。

## Phase 2 定位

Phase 2 增加“可执行任务控制面最小闭环”的纸面 artifacts：

- Task Instance：从 `templates/task-state.md` 派生可填写任务实例。
- Dispatch Matrix：定义 child ownership、allowed read/change、stop conditions、report contract。
- Child Report：标准化子线程输出，包含 changed files、evidence、verification、exhaustion。
- Parent Synthesis：标准化父线程汇总，只引用 evidence refs。
- Evaluator Gate Card：标准化 `evidence-first`、`synthesis-comparison`、`conditional-followup` 三类审阅记录。

这些模板只定义人工和 agent 可填写的控制面，不调度线程、不运行命令、不接外部系统。

## Documentation Navigation

v2 is a markdown control plane, not runner/CI/automation. Use these links to reload the current authority chain and examples before changing the harness.

### Start Here

- [README](README.md): repository orientation, phase boundaries, authority order, and non-bypass rules.
- [v1/v2 Routing](docs/route-v2.md): when to use v2 and when to fall back to v1.
- [Architecture](docs/architecture.md): roles, layers, and artifact authority.

### Architecture &amp; Protocol

- [Parent Agent Protocol](docs/parent-agent-protocol.md): Parent duties, schema, and Evaluator constraints.
- [Context Survival](docs/context-survival.md): handoff, compression, recovery, and conflict handling.
- [Phase 5 Gate Hardening Guide](docs/phase-5-gate-hardening-guide.md): parent responses to Conditional Go, No-Go, authority conflict, and child exhaustion.
- [Phase 6 Dispatch Discipline Guide](docs/phase-6-dispatch-discipline-guide.md): when Parent may control artifacts and when Generator/Evaluator work must be delegated.
- [Phase 7 Context Handoff Guide](docs/phase-7-context-handoff-guide.md): context compression, reload paths, and handoff recovery without chat memory authority.
- [Phase 8 Evaluator Dispute Guide](docs/phase-8-evaluator-dispute-guide.md): evaluator dispute, No-Go blocking, and human-decision recovery paths.
- [Phase 9 Evidence Integrity Guide](docs/phase-9-evidence-integrity-guide.md): append-only Evidence Index audit, scope-change records, and evidence recovery blockers.
- [Phase 10 Release Gate Guide](docs/phase-10-release-gate-guide.md): release gate, remote-sync readiness, and separate push/PR authorization checks.
- [Phase 11 Release Packet Guide](docs/phase-11-release-packet-guide.md): release packet preparation, origin/master..HEAD summary, and remote-sync authorization request checks.
- [Phase 12 Remote-Sync Decision Guide](docs/phase-12-remote-sync-decision-guide.md): remote-sync decision validity, authorization expiry, and blocking conditions.
- [Phase 13 Remote-Sync Execution Handoff Guide](docs/phase-13-remote-sync-execution-handoff-guide.md): remote-sync execution handoff, final preflight, and separate execution Human Go checks.
- [Phase 14 Remote-Sync Outcome Audit Guide](docs/phase-14-remote-sync-outcome-audit-guide.md): post-execution audit, remote evidence requirements, and outcome acceptance blockers.
- [Phase 15 Baseline Closure Guide](docs/phase-15-baseline-closure-guide.md): baseline closure, end-to-end evidence map, and chat-memory-free reconstruction blockers.
- [Phase 16 Remote-Sync Authorization Packet Guide](docs/phase-16-remote-sync-authorization-packet-guide.md): paper-only authorization packet, push/PR route decision, and Human route-selection blockers.
- [Phase 17 Route Selection Readiness Guide](docs/phase-17-route-selection-readiness-guide.md): route selection readiness, evidence refresh, and push/PR non-authorization expiry blockers.
- [Phase 18 Route Selection Decision Guide](docs/phase-18-route-selection-decision-guide.md): route selection decision capture, single-route binding, and ambiguity blockers.
- [Phase 19 Route-Specific Execution Authorization Guide](docs/phase-19-route-specific-execution-authorization-guide.md): route-specific execution authorization, candidate command isolation, and separate execution Human Go checks.
- [Phase 20 Execution Human Go Capture Guide](docs/phase-20-execution-human-go-capture-guide.md): execution Human Go capture, exact command binding, and authorization expiry checks.
- [Phase 21 Execution Denial / Abort and Recovery Guide](docs/phase-21-execution-denial-abort-recovery-guide.md): execution denial, abort trigger, and recovery decision checks.
- [Phase 22 Authorization State Canonicalization Guide](docs/phase-22-authorization-state-canonicalization-guide.md): canonical authorization status fields, non-authorization input inventory, and cross-artifact consistency blockers.
- [Phase 23 Release Candidate Freeze Guide](docs/phase-23-release-candidate-freeze-guide.md): release-candidate freeze, canonical evidence snapshot, and chat-memory-free reconstruction blockers.
- [Phase 24 Release Candidate Review Guide](docs/phase-24-release-candidate-review-guide.md): release-candidate review packet, freeze freshness revalidation, and stale freeze blockers.
- [Phase 25 Current Release Candidate Refreeze Guide](docs/phase-25-current-release-candidate-refreeze-guide.md): current release candidate refreeze, refreshed evidence snapshot, and authorization No-Go preservation.
- [Phase 26 Freeze Finalization Boundary Guide](docs/phase-26-freeze-finalization-boundary-guide.md): freeze finalization boundary, no-commit-after-freeze rule, and stale-freeze risk acceptance blockers.

### Templates

- [Task State](templates/task-state.md)
- [Task Instance](templates/task-instance.md)
- [Dispatch Matrix](templates/dispatch-matrix.md)
- [Child Report](templates/child-report.md)
- [Evaluator Gate Card](templates/evaluator-gate-card.md)
- [Parent Synthesis](templates/parent-synthesis.md)

### Examples &amp; Rehearsals

- [Phase 2 Paper Drill](examples/phase-2-paper-drill.md)
- [Phase 3 Task Instance](examples/phase-3-docs-index-rehearsal/task-instance.md)
- [Phase 3 Dispatch Matrix](examples/phase-3-docs-index-rehearsal/dispatch-matrix.md)
- [Phase 3 Research Child Report](examples/phase-3-docs-index-rehearsal/child-report-research.md)
- [Phase 3 Proposal Child Report](examples/phase-3-docs-index-rehearsal/child-report-proposal.md)
- [Phase 3 Evaluator Gate Card](examples/phase-3-docs-index-rehearsal/evaluator-gate-card.md)
- [Phase 3 Parent Synthesis](examples/phase-3-docs-index-rehearsal/parent-synthesis.md)
- [Phase 3 Human Decision](examples/phase-3-docs-index-rehearsal/human-decision.md)
- [Phase 4 Task Instance](examples/phase-4-docs-index-implementation/task-instance.md)
- [Phase 4 Dispatch Matrix](examples/phase-4-docs-index-implementation/dispatch-matrix.md)
- [Phase 4 Docs Edit Child Report](examples/phase-4-docs-index-implementation/child-report-docs-edit.md)
- [Phase 4 Evaluator Gate Card](examples/phase-4-docs-index-implementation/evaluator-gate-card.md)
- [Phase 4 Parent Synthesis](examples/phase-4-docs-index-implementation/parent-synthesis.md)
- [Phase 4 Human Decision](examples/phase-4-docs-index-implementation/human-decision.md)
- [Phase 5 Task Instance](examples/phase-5-gate-hardening-drill/task-instance.md)
- [Phase 5 Dispatch Matrix](examples/phase-5-gate-hardening-drill/dispatch-matrix.md)
- [Phase 5 Conditional Child Report](examples/phase-5-gate-hardening-drill/child-report-conditional-followup.md)
- [Phase 5 No-Go Child Report](examples/phase-5-gate-hardening-drill/child-report-no-go.md)
- [Phase 5 Authority Conflict Child Report](examples/phase-5-gate-hardening-drill/child-report-authority-conflict.md)
- [Phase 5 Exhausted Child Report](examples/phase-5-gate-hardening-drill/child-report-exhausted.md)
- [Phase 5 Evaluator Gate Card](examples/phase-5-gate-hardening-drill/evaluator-gate-card.md)
- [Phase 5 Parent Synthesis](examples/phase-5-gate-hardening-drill/parent-synthesis.md)
- [Phase 5 Human Decision](examples/phase-5-gate-hardening-drill/human-decision.md)
- [Phase 6 Task Instance](examples/phase-6-dispatch-discipline-rehearsal/task-instance.md)
- [Phase 6 Dispatch Matrix](examples/phase-6-dispatch-discipline-rehearsal/dispatch-matrix.md)
- [Phase 6 Dispatch Discipline Child Report](examples/phase-6-dispatch-discipline-rehearsal/child-report-dispatch-discipline.md)
- [Phase 6 Evaluator Gate Card](examples/phase-6-dispatch-discipline-rehearsal/evaluator-gate-card.md)
- [Phase 6 Parent Synthesis](examples/phase-6-dispatch-discipline-rehearsal/parent-synthesis.md)
- [Phase 6 Human Decision](examples/phase-6-dispatch-discipline-rehearsal/human-decision.md)
- [Phase 7 Task Instance](examples/phase-7-context-handoff-rehearsal/task-instance.md)
- [Phase 7 Dispatch Matrix](examples/phase-7-context-handoff-rehearsal/dispatch-matrix.md)
- [Phase 7 Context Handoff Child Report](examples/phase-7-context-handoff-rehearsal/child-report-context-handoff.md)
- [Phase 7 Context Compression Snapshot](examples/phase-7-context-handoff-rehearsal/context-compression-snapshot.md)
- [Phase 7 Handoff Recovery Record](examples/phase-7-context-handoff-rehearsal/handoff-recovery-record.md)
- [Phase 7 Evaluator Gate Card](examples/phase-7-context-handoff-rehearsal/evaluator-gate-card.md)
- [Phase 7 Parent Synthesis](examples/phase-7-context-handoff-rehearsal/parent-synthesis.md)
- [Phase 7 Human Decision](examples/phase-7-context-handoff-rehearsal/human-decision.md)
- [Phase 8 Task Instance](examples/phase-8-evaluator-dispute-recovery-drill/task-instance.md)
- [Phase 8 Dispatch Matrix](examples/phase-8-evaluator-dispute-recovery-drill/dispatch-matrix.md)
- [Phase 8 Evaluator Dispute Child Report](examples/phase-8-evaluator-dispute-recovery-drill/child-report-evaluator-dispute.md)
- [Phase 8 Evaluator Gate Card](examples/phase-8-evaluator-dispute-recovery-drill/evaluator-gate-card.md)
- [Phase 8 Evaluator Dispute Record](examples/phase-8-evaluator-dispute-recovery-drill/evaluator-dispute-record.md)
- [Phase 8 Human Decision Recovery Record](examples/phase-8-evaluator-dispute-recovery-drill/human-decision-recovery-record.md)
- [Phase 8 Parent Synthesis](examples/phase-8-evaluator-dispute-recovery-drill/parent-synthesis.md)
- [Phase 8 Human Decision](examples/phase-8-evaluator-dispute-recovery-drill/human-decision.md)
- [Phase 9 Task Instance](examples/phase-9-evidence-integrity-drill/task-instance.md)
- [Phase 9 Dispatch Matrix](examples/phase-9-evidence-integrity-drill/dispatch-matrix.md)
- [Phase 9 Evidence Integrity Child Report](examples/phase-9-evidence-integrity-drill/child-report-evidence-integrity.md)
- [Phase 9 Evaluator Gate Card](examples/phase-9-evidence-integrity-drill/evaluator-gate-card.md)
- [Phase 9 Evidence Audit Record](examples/phase-9-evidence-integrity-drill/evidence-audit-record.md)
- [Phase 9 Scope Change Record](examples/phase-9-evidence-integrity-drill/scope-change-record.md)
- [Phase 9 Parent Synthesis](examples/phase-9-evidence-integrity-drill/parent-synthesis.md)
- [Phase 9 Human Decision](examples/phase-9-evidence-integrity-drill/human-decision.md)
- [Phase 10 Task Instance](examples/phase-10-release-gate-drill/task-instance.md)
- [Phase 10 Dispatch Matrix](examples/phase-10-release-gate-drill/dispatch-matrix.md)
- [Phase 10 Release Gate Child Report](examples/phase-10-release-gate-drill/child-report-release-gate.md)
- [Phase 10 Evaluator Gate Card](examples/phase-10-release-gate-drill/evaluator-gate-card.md)
- [Phase 10 Release Gate Checklist](examples/phase-10-release-gate-drill/release-gate-checklist.md)
- [Phase 10 Parent Synthesis](examples/phase-10-release-gate-drill/parent-synthesis.md)
- [Phase 10 Human Decision](examples/phase-10-release-gate-drill/human-decision.md)
- [Phase 11 Task Instance](examples/phase-11-release-packet-drill/task-instance.md)
- [Phase 11 Dispatch Matrix](examples/phase-11-release-packet-drill/dispatch-matrix.md)
- [Phase 11 Release Packet Child Report](examples/phase-11-release-packet-drill/child-report-release-packet.md)
- [Phase 11 Release Packet](examples/phase-11-release-packet-drill/release-packet.md)
- [Phase 11 Evaluator Gate Card](examples/phase-11-release-packet-drill/evaluator-gate-card.md)
- [Phase 11 Parent Synthesis](examples/phase-11-release-packet-drill/parent-synthesis.md)
- [Phase 11 Human Decision](examples/phase-11-release-packet-drill/human-decision.md)
- [Phase 12 Task Instance](examples/phase-12-remote-sync-decision-drill/task-instance.md)
- [Phase 12 Dispatch Matrix](examples/phase-12-remote-sync-decision-drill/dispatch-matrix.md)
- [Phase 12 Remote-Sync Decision Child Report](examples/phase-12-remote-sync-decision-drill/child-report-remote-sync-decision.md)
- [Phase 12 Remote-Sync Decision Request](examples/phase-12-remote-sync-decision-drill/remote-sync-decision-request.md)
- [Phase 12 Evaluator Gate Card](examples/phase-12-remote-sync-decision-drill/evaluator-gate-card.md)
- [Phase 12 Parent Synthesis](examples/phase-12-remote-sync-decision-drill/parent-synthesis.md)
- [Phase 12 Human Decision](examples/phase-12-remote-sync-decision-drill/human-decision.md)
- [Phase 13 Task Instance](examples/phase-13-remote-sync-execution-handoff-drill/task-instance.md)
- [Phase 13 Dispatch Matrix](examples/phase-13-remote-sync-execution-handoff-drill/dispatch-matrix.md)
- [Phase 13 Remote-Sync Execution Child Report](examples/phase-13-remote-sync-execution-handoff-drill/child-report-remote-sync-execution-handoff.md)
- [Phase 13 Remote-Sync Execution Runbook](examples/phase-13-remote-sync-execution-handoff-drill/remote-sync-execution-runbook.md)
- [Phase 13 Remote-Sync Preflight Checklist](examples/phase-13-remote-sync-execution-handoff-drill/remote-sync-preflight-checklist.md)
- [Phase 13 Evaluator Gate Card](examples/phase-13-remote-sync-execution-handoff-drill/evaluator-gate-card.md)
- [Phase 13 Parent Synthesis](examples/phase-13-remote-sync-execution-handoff-drill/parent-synthesis.md)
- [Phase 13 Human Decision](examples/phase-13-remote-sync-execution-handoff-drill/human-decision.md)
- [Phase 14 Task Instance](examples/phase-14-remote-sync-outcome-audit-drill/task-instance.md)
- [Phase 14 Dispatch Matrix](examples/phase-14-remote-sync-outcome-audit-drill/dispatch-matrix.md)
- [Phase 14 Remote-Sync Outcome Audit Child Report](examples/phase-14-remote-sync-outcome-audit-drill/child-report-remote-sync-outcome-audit.md)
- [Phase 14 Remote-Sync Outcome Record](examples/phase-14-remote-sync-outcome-audit-drill/remote-sync-outcome-record.md)
- [Phase 14 Post-Execution Audit Checklist](examples/phase-14-remote-sync-outcome-audit-drill/post-execution-audit-checklist.md)
- [Phase 14 Evaluator Gate Card](examples/phase-14-remote-sync-outcome-audit-drill/evaluator-gate-card.md)
- [Phase 14 Parent Synthesis](examples/phase-14-remote-sync-outcome-audit-drill/parent-synthesis.md)
- [Phase 14 Human Decision](examples/phase-14-remote-sync-outcome-audit-drill/human-decision.md)
- [Phase 15 Task Instance](examples/phase-15-baseline-closure-drill/task-instance.md)
- [Phase 15 Dispatch Matrix](examples/phase-15-baseline-closure-drill/dispatch-matrix.md)
- [Phase 15 Baseline Closure Child Report](examples/phase-15-baseline-closure-drill/child-report-baseline-closure.md)
- [Phase 15 Baseline Closure Record](examples/phase-15-baseline-closure-drill/baseline-closure-record.md)
- [Phase 15 End-to-End Evidence Map](examples/phase-15-baseline-closure-drill/end-to-end-evidence-map.md)
- [Phase 15 Evaluator Gate Card](examples/phase-15-baseline-closure-drill/evaluator-gate-card.md)
- [Phase 15 Parent Synthesis](examples/phase-15-baseline-closure-drill/parent-synthesis.md)
- [Phase 15 Human Decision](examples/phase-15-baseline-closure-drill/human-decision.md)
- [Phase 16 Task Instance](examples/phase-16-remote-sync-authorization-packet-drill/task-instance.md)
- [Phase 16 Dispatch Matrix](examples/phase-16-remote-sync-authorization-packet-drill/dispatch-matrix.md)
- [Phase 16 Remote-Sync Authorization Packet Child Report](examples/phase-16-remote-sync-authorization-packet-drill/child-report-remote-sync-authorization-packet.md)
- [Phase 16 Remote-Sync Authorization Packet](examples/phase-16-remote-sync-authorization-packet-drill/remote-sync-authorization-packet.md)
- [Phase 16 Route Decision Matrix](examples/phase-16-remote-sync-authorization-packet-drill/route-decision-matrix.md)
- [Phase 16 Evaluator Gate Card](examples/phase-16-remote-sync-authorization-packet-drill/evaluator-gate-card.md)
- [Phase 16 Parent Synthesis](examples/phase-16-remote-sync-authorization-packet-drill/parent-synthesis.md)
- [Phase 16 Human Decision](examples/phase-16-remote-sync-authorization-packet-drill/human-decision.md)
- [Phase 17 Task Instance](examples/phase-17-route-selection-readiness-drill/task-instance.md)
- [Phase 17 Dispatch Matrix](examples/phase-17-route-selection-readiness-drill/dispatch-matrix.md)
- [Phase 17 Route Selection Readiness Child Report](examples/phase-17-route-selection-readiness-drill/child-report-route-selection-readiness.md)
- [Phase 17 Route Selection Readiness Record](examples/phase-17-route-selection-readiness-drill/route-selection-readiness-record.md)
- [Phase 17 Evidence Refresh Checklist](examples/phase-17-route-selection-readiness-drill/evidence-refresh-checklist.md)
- [Phase 17 Evaluator Gate Card](examples/phase-17-route-selection-readiness-drill/evaluator-gate-card.md)
- [Phase 17 Parent Synthesis](examples/phase-17-route-selection-readiness-drill/parent-synthesis.md)
- [Phase 17 Human Decision](examples/phase-17-route-selection-readiness-drill/human-decision.md)
- [Phase 18 Task Instance](examples/phase-18-route-selection-decision-drill/task-instance.md)
- [Phase 18 Dispatch Matrix](examples/phase-18-route-selection-decision-drill/dispatch-matrix.md)
- [Phase 18 Route Selection Decision Child Report](examples/phase-18-route-selection-decision-drill/child-report-route-selection-decision.md)
- [Phase 18 Route Selection Decision Packet](examples/phase-18-route-selection-decision-drill/route-selection-decision-packet.md)
- [Phase 18 Single-Route Binding Record](examples/phase-18-route-selection-decision-drill/single-route-binding-record.md)
- [Phase 18 Ambiguity Rejection Checklist](examples/phase-18-route-selection-decision-drill/ambiguity-rejection-checklist.md)
- [Phase 18 Evaluator Gate Card](examples/phase-18-route-selection-decision-drill/evaluator-gate-card.md)
- [Phase 18 Parent Synthesis](examples/phase-18-route-selection-decision-drill/parent-synthesis.md)
- [Phase 18 Human Decision](examples/phase-18-route-selection-decision-drill/human-decision.md)
- [Phase 19 Task Instance](examples/phase-19-route-specific-execution-authorization-drill/task-instance.md)
- [Phase 19 Dispatch Matrix](examples/phase-19-route-specific-execution-authorization-drill/dispatch-matrix.md)
- [Phase 19 Route-Specific Execution Authorization Child Report](examples/phase-19-route-specific-execution-authorization-drill/child-report-route-specific-execution-authorization.md)
- [Phase 19 Route-Specific Execution Authorization Packet](examples/phase-19-route-specific-execution-authorization-drill/route-specific-execution-authorization-packet.md)
- [Phase 19 Candidate Command Isolation Record](examples/phase-19-route-specific-execution-authorization-drill/candidate-command-isolation-record.md)
- [Phase 19 Execution Authorization Checklist](examples/phase-19-route-specific-execution-authorization-drill/execution-authorization-checklist.md)
- [Phase 19 Evaluator Gate Card](examples/phase-19-route-specific-execution-authorization-drill/evaluator-gate-card.md)
- [Phase 19 Parent Synthesis](examples/phase-19-route-specific-execution-authorization-drill/parent-synthesis.md)
- [Phase 19 Human Decision](examples/phase-19-route-specific-execution-authorization-drill/human-decision.md)
- [Phase 20 Task Instance](examples/phase-20-execution-human-go-capture-drill/task-instance.md)
- [Phase 20 Dispatch Matrix](examples/phase-20-execution-human-go-capture-drill/dispatch-matrix.md)
- [Phase 20 Execution Human Go Capture Child Report](examples/phase-20-execution-human-go-capture-drill/child-report-execution-human-go-capture.md)
- [Phase 20 Execution Human Go Capture Packet](examples/phase-20-execution-human-go-capture-drill/execution-human-go-capture-packet.md)
- [Phase 20 Exact Command Binding Record](examples/phase-20-execution-human-go-capture-drill/exact-command-binding-record.md)
- [Phase 20 Authorization Expiry Checklist](examples/phase-20-execution-human-go-capture-drill/authorization-expiry-checklist.md)
- [Phase 20 Evaluator Gate Card](examples/phase-20-execution-human-go-capture-drill/evaluator-gate-card.md)
- [Phase 20 Parent Synthesis](examples/phase-20-execution-human-go-capture-drill/parent-synthesis.md)
- [Phase 20 Human Decision](examples/phase-20-execution-human-go-capture-drill/human-decision.md)
- [Phase 21 Task Instance](examples/phase-21-execution-denial-abort-recovery-drill/task-instance.md)
- [Phase 21 Dispatch Matrix](examples/phase-21-execution-denial-abort-recovery-drill/dispatch-matrix.md)
- [Phase 21 Execution Denial / Abort and Recovery Child Report](examples/phase-21-execution-denial-abort-recovery-drill/child-report-execution-denial-abort-recovery.md)
- [Phase 21 Execution Denial Record](examples/phase-21-execution-denial-abort-recovery-drill/execution-denial-record.md)
- [Phase 21 Abort Trigger Checklist](examples/phase-21-execution-denial-abort-recovery-drill/abort-trigger-checklist.md)
- [Phase 21 Recovery Decision Matrix](examples/phase-21-execution-denial-abort-recovery-drill/recovery-decision-matrix.md)
- [Phase 21 Evaluator Gate Card](examples/phase-21-execution-denial-abort-recovery-drill/evaluator-gate-card.md)
- [Phase 21 Parent Synthesis](examples/phase-21-execution-denial-abort-recovery-drill/parent-synthesis.md)
- [Phase 21 Human Decision](examples/phase-21-execution-denial-abort-recovery-drill/human-decision.md)
- [Phase 22 Task Instance](examples/phase-22-authorization-state-canonicalization-drill/task-instance.md)
- [Phase 22 Dispatch Matrix](examples/phase-22-authorization-state-canonicalization-drill/dispatch-matrix.md)
- [Phase 22 Authorization State Canonicalization Child Report](examples/phase-22-authorization-state-canonicalization-drill/child-report-authorization-state-canonicalization.md)
- [Phase 22 Authorization State Field Registry](examples/phase-22-authorization-state-canonicalization-drill/authorization-state-field-registry.md)
- [Phase 22 Non-Authorization Input Inventory](examples/phase-22-authorization-state-canonicalization-drill/non-authorization-input-inventory.md)
- [Phase 22 Cross-Artifact Consistency Checklist](examples/phase-22-authorization-state-canonicalization-drill/cross-artifact-consistency-checklist.md)
- [Phase 22 Evaluator Gate Card](examples/phase-22-authorization-state-canonicalization-drill/evaluator-gate-card.md)
- [Phase 22 Parent Synthesis](examples/phase-22-authorization-state-canonicalization-drill/parent-synthesis.md)
- [Phase 22 Human Decision](examples/phase-22-authorization-state-canonicalization-drill/human-decision.md)
- [Phase 23 Task Instance](examples/phase-23-release-candidate-freeze-drill/task-instance.md)
- [Phase 23 Dispatch Matrix](examples/phase-23-release-candidate-freeze-drill/dispatch-matrix.md)
- [Phase 23 Release Candidate Freeze Child Report](examples/phase-23-release-candidate-freeze-drill/child-report-release-candidate-freeze.md)
- [Phase 23 Release Candidate Snapshot](examples/phase-23-release-candidate-freeze-drill/release-candidate-snapshot.md)
- [Phase 23 Canonical Authorization State Snapshot](examples/phase-23-release-candidate-freeze-drill/canonical-authorization-state-snapshot.md)
- [Phase 23 Evidence Freeze Checklist](examples/phase-23-release-candidate-freeze-drill/evidence-freeze-checklist.md)
- [Phase 23 Evaluator Gate Card](examples/phase-23-release-candidate-freeze-drill/evaluator-gate-card.md)
- [Phase 23 Parent Synthesis](examples/phase-23-release-candidate-freeze-drill/parent-synthesis.md)
- [Phase 23 Human Decision](examples/phase-23-release-candidate-freeze-drill/human-decision.md)
- [Phase 24 Task Instance](examples/phase-24-release-candidate-review-drill/task-instance.md)
- [Phase 24 Dispatch Matrix](examples/phase-24-release-candidate-review-drill/dispatch-matrix.md)
- [Phase 24 Release Candidate Review Child Report](examples/phase-24-release-candidate-review-drill/child-report-release-candidate-review.md)
- [Phase 24 Release Candidate Review Packet](examples/phase-24-release-candidate-review-drill/release-candidate-review-packet.md)
- [Phase 24 Freeze Freshness Revalidation Checklist](examples/phase-24-release-candidate-review-drill/freeze-freshness-revalidation-checklist.md)
- [Phase 24 Authorization State Comparison Record](examples/phase-24-release-candidate-review-drill/authorization-state-comparison-record.md)
- [Phase 24 Evaluator Gate Card](examples/phase-24-release-candidate-review-drill/evaluator-gate-card.md)
- [Phase 24 Parent Synthesis](examples/phase-24-release-candidate-review-drill/parent-synthesis.md)
- [Phase 24 Human Decision](examples/phase-24-release-candidate-review-drill/human-decision.md)
- [Phase 25 Task Instance](examples/phase-25-current-release-candidate-refreeze-drill/task-instance.md)
- [Phase 25 Dispatch Matrix](examples/phase-25-current-release-candidate-refreeze-drill/dispatch-matrix.md)
- [Phase 25 Current Release Candidate Refreeze Child Report](examples/phase-25-current-release-candidate-refreeze-drill/child-report-current-release-candidate-refreeze.md)
- [Phase 25 Current Release Candidate Refreeze Packet](examples/phase-25-current-release-candidate-refreeze-drill/current-release-candidate-refreeze-packet.md)
- [Phase 25 Refreshed Evidence Snapshot](examples/phase-25-current-release-candidate-refreeze-drill/refreshed-evidence-snapshot.md)
- [Phase 25 Canonical Authorization State Snapshot](examples/phase-25-current-release-candidate-refreeze-drill/canonical-authorization-state-snapshot.md)
- [Phase 25 Evidence Refresh Checklist](examples/phase-25-current-release-candidate-refreeze-drill/evidence-refresh-checklist.md)
- [Phase 25 Evaluator Gate Card](examples/phase-25-current-release-candidate-refreeze-drill/evaluator-gate-card.md)
- [Phase 25 Parent Synthesis](examples/phase-25-current-release-candidate-refreeze-drill/parent-synthesis.md)
- [Phase 25 Human Decision](examples/phase-25-current-release-candidate-refreeze-drill/human-decision.md)
- [Phase 26 Task Instance](examples/phase-26-freeze-finalization-boundary-drill/task-instance.md)
- [Phase 26 Dispatch Matrix](examples/phase-26-freeze-finalization-boundary-drill/dispatch-matrix.md)
- [Phase 26 Freeze Finalization Boundary Child Report](examples/phase-26-freeze-finalization-boundary-drill/child-report-freeze-finalization-boundary.md)
- [Phase 26 Freeze Finalization Boundary Record](examples/phase-26-freeze-finalization-boundary-drill/freeze-finalization-boundary-record.md)
- [Phase 26 Self-Invalidation Analysis](examples/phase-26-freeze-finalization-boundary-drill/self-invalidation-analysis.md)
- [Phase 26 No-Commit-After-Freeze Checklist](examples/phase-26-freeze-finalization-boundary-drill/no-commit-after-freeze-checklist.md)
- [Phase 26 Evaluator Gate Card](examples/phase-26-freeze-finalization-boundary-drill/evaluator-gate-card.md)
- [Phase 26 Parent Synthesis](examples/phase-26-freeze-finalization-boundary-drill/parent-synthesis.md)
- [Phase 26 Human Decision](examples/phase-26-freeze-finalization-boundary-drill/human-decision.md)

## 权威顺序

```text
Human-signed North Star
> Task State
> Evaluator Decision
> Parent Synthesis
> Child Reports / Evidence Refs
> Chat Context
```

聊天上下文永远不是权威来源。恢复、审阅和继续执行时必须回到 artifacts。

Human-signed North Star 是最高目标源。North Star 可由 Parent 草拟，但只有 Human 签署后才生效；缺少 Human signoff 时，任务状态必须保持 `proposed` 或 `blocked: needs-human-signoff`。

## 核心文件

- `docs/architecture.md`：四层架构、角色、权威关系。
- `docs/parent-agent-protocol.md`：Parent Agent 协议、schema、Evaluator 规则。
- `docs/context-survival.md`：上下文压缩、handoff、恢复和冲突处理。
- `docs/route-v2.md`：v1/v2 路由规则和 fallback。
- `templates/task-state.md`：Phase 1 核心模板，内嵌 North Star、child、evaluator、evidence 结构。
- `templates/task-instance.md`：Phase 2 可填写任务实例模板。
- `templates/dispatch-matrix.md`：Phase 2 派发矩阵模板。
- `templates/child-report.md`：Phase 2 子线程报告模板。
- `templates/parent-synthesis.md`：Phase 2 父线程汇总模板。
- `templates/evaluator-gate-card.md`：Phase 2 Evaluator gate 记录模板。
- `examples/phase-2-paper-drill.md`：低风险纸面演练样例。

## 最小使用流程

1. 判断任务是否适合 v2，路由不确定时默认退回 v1 或 blocked。
2. Parent 草拟 North Star Contract。
3. Human 明确签署 North Star。
4. Parent 生成 Dispatch Matrix 和 Child Goals。
5. Child Agents 按角色执行并提交 Child Report，测试结果必须写入 report。
6. Evaluator 先做 `evidence-first` pass，再做 `synthesis-comparison` pass。
7. Parent 只能基于 evidence refs 合成 Parent Synthesis，不得用聊天记忆替代验证证据。
8. Human 根据 artifacts 做最终接受、调整或拒绝。

## 不可绕过规则

- Parent 不得把自己列为 Generator 或 Evaluator。
- Parent cannot assign itself.
- Parent 不得直接修改受管业务文件，不能未经 Human signoff 启动 implementation。
- Parent 不得 reject Evaluator 的 `No-Go`。
- `Conditional Go` 必须经过第二次轻量 Evaluator pass。
- Evidence Index 必须是 append-only，只能追加，不能删除或改写旧条目。
- Child 报告若触发停止条件或耗尽可行动作，必须写入 `child-report: exhausted`。
- 未 Human signoff 的 North Star 不能启动 implementation。
- 高风险任务默认退回 v1 gated delivery。
