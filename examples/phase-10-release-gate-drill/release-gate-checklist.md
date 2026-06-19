# Release Gate Checklist: remote-sync readiness drill

## Header

```text
Checklist ID: CHECK-P10-RELEASE-GATE-001
Task Instance Ref: examples/phase-10-release-gate-drill/task-instance.md
Created At: 2026-06-18
```

## Commit Inventory

```text
Branch State: master...origin/master [ahead 9]
Remote-Sync Status: pending separate Human Go
Release Action Authorized: no
```

```text
Phase 1: 29ae943 docs: add v2 phase 1 harness baseline
Phase 2: 72cc236 docs: add v2 phase 2 control-plane loop
Phase 3: 8960e61 docs: add v2 phase 3 process rehearsal
Phase 4: 1f17ad1 docs: add v2 phase 4 docs navigation implementation
Phase 5: 670b8ec docs: add v2 phase 5 gate hardening drill
Phase 6: b80e566 docs: add v2 phase 6 dispatch discipline rehearsal
Phase 7: 08df78c docs: add v2 phase 7 context handoff rehearsal
Phase 8: fb7774a docs: add v2 phase 8 evaluator dispute recovery drill
Phase 9: 05ddf8d docs: add v2 phase 9 evidence integrity drill
Evidence Refs: P10-EV-004, P10-EV-009
```

## Readiness Checks

```text
Check: local commit acceptance versus remote authorization
Result: release gate blocks remote-sync until separate Human Go exists.
Evidence Refs: P10-EV-001, P10-EV-007, P10-EV-008
```

```text
Check: staged files
Result: dirty staged files block release gate.
Evidence Refs: P10-EV-004, P10-EV-005
```

```text
Check: release evidence completeness
Result: missing release evidence blocks release gate.
Evidence Refs: P10-EV-004, P10-EV-005
```

```text
Check: local state exclusion
Result: .claude/settings.local.json is local state and excluded from release scope.
Evidence Refs: P10-EV-004, P10-EV-008
```

```text
Check: scope-change review
Result: unreviewed scope change blocks release gate.
Evidence Refs: P10-EV-004, P10-EV-005
```

## Blocking Release Lanes

```text
Lane: dirty staged files
Blocking State: No-Go
Recovery: clear staged release payload through explicit review; do not push while staged state is unresolved.
```

```text
Lane: missing release evidence
Blocking State: No-Go
Recovery: append release evidence refs and rerun evaluator evidence-first pass.
```

```text
Lane: fake push approval
Blocking State: No-Go
Recovery: require separate Human Go with evidence ref; local commit approval is insufficient.
```

```text
Lane: unreviewed scope change
Blocking State: No-Go
Recovery: append scope-change evidence and wait for Human decision.
```

```text
Lane: unexpected files
Blocking State: No-Go
Recovery: identify file, classify scope, and route to Human if release payload expands.
```

## Release Scope

```text
Included For Phase 10 Review: README.md navigation links; docs/phase-10-release-gate-guide.md; examples/phase-10-release-gate-drill/*.md
Excluded Local State: .claude/settings.local.json and any other untracked local machine state
Remote Action: none
push / PR Authorized: no
```
