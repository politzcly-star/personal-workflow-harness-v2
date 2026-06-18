# Parent Agent Protocol

本文件定义 Parent Agent 在 v2 中的职责、限制、schema 和质量 gate 规则。核心目标是避免 Parent 自定方向、自派自做、自评自过。

Phase 2 把 v2 明确为 `goal-first / agent-orchestrated control plane`。Parent 维护 markdown artifacts，不实现 runner、CI、Docker、浏览器自动化、GitHub issue tracker integration 或生产系统操作。

## Parent 可以做

- 草拟 North Star Contract。
- 草拟 Dispatch Matrix。
- 派发 Child Goals。
- 汇总 Child Reports。
- 生成 Parent Synthesis。
- 准备 Human Acceptance Summary。
- 维护 v2 控制面 artifacts。

## Parent 不可以做

- 未经 Human signoff 启动 implementation。
- 把自己列入 Dispatch Matrix 作为 Generator 或 Evaluator。
- 直接修改受管业务文件。
- reject Evaluator 的 `No-Go`。
- 覆盖 Evaluator findings。
- 自行扩大 Allowed Changes。
- 自行修改已签署的 North Star。
- 删除或改写 Evidence Index 既有条目。

Parent 只能修改 v2 控制面 artifacts，例如 task-state、goal、dispatch、synthesis、handoff。

Parent cannot assign itself.

Parent 不能用聊天记忆替代 Child Report、verification output、Evaluator Gate Card 或 Evidence Index。

## Human Signoff

North Star Contract 由 Parent 草拟，但必须 Human 签署后才生效。

Phase 1 signoff 规则：

- Human 在对话中明确说 `Go`、`同意`、`确认` 或等价表达。
- Parent 在 `Human Signoff` 字段记录确认文本摘要和 timestamp。
- Parent 不得自行填充 Human Signoff。
- 没有人类对话确认的 signoff 视为无效。
- 缺少 signoff 时，任务状态必须是 `proposed` 或 `blocked: needs-human-signoff`。

## Dispatch Matrix Schema

```text
Dispatch ID:
Parent Task:
North Star Version:
Human Signoff:
Children:
  - Child ID:
    Role: planner | generator | evaluator | researcher
    Goal:
    Owned Files:
    Allowed Read:
    Allowed Changes:
    Forbidden Changes:
    Expected Evidence:
    Verification:
    Stop Conditions:
    Report Path:
Evaluator Assignment:
Conflict Rule:
Merge Rule:
Human GO Required For:
```

Rules:

- Parent cannot assign itself as `generator` or `evaluator`.
- Generator ownership must be disjoint unless Human explicitly accepts overlap.
- Evaluator read scope is automatic and must not be narrowed by Parent.
- Shared files are parent-owned unless exactly one child owns them.
- Stop conditions and report contract must be explicit before child work starts.

## Child Goal Schema

```text
Child ID:
Role: planner | generator | evaluator | researcher
Parent Task:
Goal:
Allowed Read:
Allowed Changes:
Forbidden Changes:
Expected Evidence:
Verification:
Stop Conditions:
Report Contract:
Self-Verification Result:
Exhaustion Rule:
```

Child exhaustion rule:

- If a child triggers a stop condition or exhausts available actions, it must output `child-report: exhausted`.
- Parent must not re-dispatch the same goal unchanged.
- Parent must enter `blocked: needs-human-decision`, or draft a new boundary and wait for Human signoff.

## Child Report Schema

```text
Child ID:
Role:
Goal:
Status: complete | blocked | exhausted | failed
Changed Files:
Evidence:
Verification:
Self-Verification Result:
Findings:
Open Questions:
Stop Conditions Triggered:
Recommended Parent Action:
```

`Self-Verification Result` must include command, exit code, or reason verification was not run.

Child test results and verification evidence must be written into the report. Parent must not infer a pass/fail result from chat memory.

## Evaluator Rules

Evaluator is a quality gate, not a normal child.

Evaluator automatically reads:

- Human-signed North Star
- Task State
- Dispatch Matrix
- all Generator modified files
- full diff
- all Child Reports
- verification outputs
- relevant project facts
- Evidence Index

Evaluator must use two passes:

1. `evidence-first`: read original evidence, diff, child reports, verification output, project facts, and North Star before reading Parent Synthesis.
2. `synthesis-comparison`: read Parent Synthesis draft only after the first pass, treating it as Parent's statement, not as source truth.

## Evaluator Decision Schema

```text
Evaluator ID:
Pass Type: evidence-first | synthesis-comparison | conditional-followup
Input Artifacts:
Decision: Go | Conditional Go | No-Go
Findings:
Conditions:
Evidence Gaps:
Disputes:
Timestamp:
```

Rules:

- `No-Go` blocks the task.
- Parent cannot reject Evaluator findings.
- Parent cannot override Evaluator findings.
- Parent can record `Evaluator Dispute` only by entering `blocked: needs-human-decision`.
- `Conditional Go` requires a second lightweight Evaluator pass that checks only whether listed conditions are satisfied.
- A task cannot become `accepted` until Conditional Go conditions are verified.
- Evidence Index `append-only` violations are review blockers.

## Parent Synthesis Schema

```text
Input Reports:
Accepted Findings:
Conflicts:
Evaluator State:
Evidence Refs:
Scope Changes:
Remaining Uncertainty:
Recommended Human Decision:
```

Parent Synthesis rules:

- Use evidence refs, not memory.
- Cite Child Reports for child test results.
- Record conflicts instead of silently resolving them.
- Record scope changes as blocked until Human approves.
- Do not include `rejected evaluator findings`; Evaluator findings cannot be rejected by Parent.

## Evidence Index Rules

Evidence Index is append-only.

```text
Evidence ID:
Source:
Type: diff | child-report | verification | evaluator-finding | human-decision | conflict | scope-change
Status: open | resolved | disputed | accepted-risk
Summary:
Reference:
Created At:
Updated By:
Update Reason:
```

Rules:

- Do not delete entries.
- Do not rewrite old entries.
- Status changes must append an update record with reason and timestamp.
- Evaluator may issue `No-Go` when Evidence Index omits P0/P1 findings, scope changes, conflicts, or Evaluator findings.

Evidence update record:

```text
Evidence ID:
Previous Status:
New Status:
Reason:
Timestamp:
Updated By:
```

## Authority Conflict

Use `blocked: authority-conflict` when artifacts disagree about:

- signed North Star content
- current task state
- Evaluator decision
- allowed scope
- evidence status
- Human decision

Parent must request Human resolution instead of choosing the convenient artifact.
