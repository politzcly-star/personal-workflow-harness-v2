# Dispatch Matrix: baseline closure drill

## Parent Boundary

```text
Parent Role: control-plane dispatcher and synthesizer only
Parent Must Not: self-assign as Generator or Evaluator; edit outside Allowed Changes; stage; commit; push; PR; execute remote commands; perform network remote action; read or modify the v1 repository; modify .claude/; treat chat memory as baseline evidence; claim baseline closure without cited evidence.
Parent cannot assign itself.
```

## Generator Child

```text
Child ID: C-P15-BASELINE-CLOSURE
Role: Generator
Goal: Add Phase 15 baseline closure guide, closure record, end-to-end evidence map, drill artifacts, and README Phase 15 navigation links.
Allowed Read: README.md; docs; templates; examples; local git status/remote/branch/log/show/diff outputs in this v2 repository
Allowed Changes: README.md Phase 15 navigation links only; docs/phase-15-baseline-closure-guide.md; examples/phase-15-baseline-closure-drill/task-instance.md; examples/phase-15-baseline-closure-drill/dispatch-matrix.md; examples/phase-15-baseline-closure-drill/child-report-baseline-closure.md; examples/phase-15-baseline-closure-drill/baseline-closure-record.md; examples/phase-15-baseline-closure-drill/end-to-end-evidence-map.md; examples/phase-15-baseline-closure-drill/evaluator-gate-card.md; examples/phase-15-baseline-closure-drill/parent-synthesis.md; examples/phase-15-baseline-closure-drill/human-decision.md
Forbidden Changes: .claude/settings.local.json; .claude/ files; v1 repository reads or writes; source code; runner; scripts; CI; Docker; browser automation; GitHub issue tracker integration; production; database; secrets; paid external actions; commit; push; PR; stage; remote command execution; network remote action; Phase 1/2/3/4/5/6/7/8/9/10/11/12/13/14 docs, templates, or examples except README Phase 15 navigation additions
Stop Conditions: need to edit outside Allowed Changes; need to stage, commit, push, PR, execute remote command, or perform network remote action; need to read or modify v1; need to modify .claude/; missing repository evidence prevents reconstruction; child-report: exhausted
Report Contract: changed files, evidence refs, verification commands and results, baseline closure blockers, forbidden-scope check, Human Decision state, remaining risk, parent acceptance recommendation
```

## Evaluator

```text
Evaluator ID: EVAL-P15-BASELINE-CLOSURE
Role: Independent baseline closure evaluator
Allowed Read: Human-signed North Star, Task Instance, Dispatch Matrix, Child Report, Baseline Closure Record, End-to-End Evidence Map, verification outputs, diff, Evidence Index, Parent Synthesis after evidence-first
Passes: evidence-first, synthesis-comparison
Decision Set: Go, Conditional Go, No-Go
No-Go Rule: missing phase artifact, missing evidence ref, unresolved No-Go, dirty staged files, branch/remote mismatch, fake closeout, local-only state in release scope, unauthorized remote action, duplicate P15-EV definition, or uncited Parent Synthesis claim blocks baseline closure.
```

## Baseline Closure Boundary

```text
Baseline Closure: local markdown/control-plane packet only.
Release: not authorized.
Remote-Sync: not authorized.
Remote Execution: not authorized.
.claude/ and local-only state: excluded.
push / PR Authorized: no
remote action unauthorized
Human Decision: pending
```
