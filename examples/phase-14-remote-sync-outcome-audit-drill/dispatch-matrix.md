# Dispatch Matrix: remote-sync outcome audit drill

## Parent Boundary

```text
Parent Role: control-plane dispatcher and synthesizer only
Parent Must Not: self-assign as Generator or Evaluator; edit outside Allowed Changes; stage; commit; push; PR; execute candidate remote commands; perform network remote action; treat local commit, candidate command, chat message, or claimed success as remote evidence.
Parent cannot assign itself.
```

## Generator Child

```text
Child ID: C-P14-REMOTE-SYNC-OUTCOME-AUDIT
Role: Generator
Goal: Add Phase 14 remote-sync outcome audit guide, outcome record, post-execution audit checklist, drill artifacts, and README Phase 14 navigation links.
Allowed Read: README.md; docs; templates; examples; git status/remote/branch/log/diff outputs in this v2 repository
Allowed Changes: README.md Phase 14 navigation links only; docs/phase-14-remote-sync-outcome-audit-guide.md; examples/phase-14-remote-sync-outcome-audit-drill/*.md
Forbidden Changes: .claude/settings.local.json; .claude/ files; v1 repository; source code; runner; scripts; CI; Docker; browser automation; GitHub issue tracker integration; production; database; secrets; paid external actions; commit; push; PR; stage; remote command execution; network remote action; Phase 1/2/3/4/5/6/7/8/9/10/11/12/13 docs, templates, or examples except README Phase 14 navigation additions
Stop Conditions: need to edit outside Allowed Changes; need to stage, commit, push, PR, execute remote command, or perform network remote action; remote outcome acceptance cannot be represented safely; verification unavailable; child-report: exhausted
Report Contract: changed files, evidence refs, verification commands and results, remote-sync outcome blockers, forbidden-scope check, Human Decision state, remaining risk, parent acceptance recommendation
```

## Evaluator

```text
Evaluator ID: EVAL-P14-REMOTE-SYNC-OUTCOME-AUDIT
Role: Independent remote-sync outcome audit evaluator
Allowed Read: Human-signed North Star, Task Instance, Dispatch Matrix, Child Report, Remote-Sync Outcome Record, Post-Execution Audit Checklist, verification outputs, diff, Evidence Index, Parent Synthesis after evidence-first
Passes: evidence-first, synthesis-comparison
Decision Set: Go, Conditional Go, No-Go
No-Go Rule: missing remote evidence, fake success claim, partial push without reconciliation, rejected push without recovery, protected branch without PR route decision, PR-required route without PR evidence, remote URL drift, diverged origin, local-only state leakage, or missing Human decision blocks remote outcome acceptance.
```

## Remote-Sync Outcome Boundary

```text
Local Commit: not remote evidence.
Candidate Command: not remote evidence.
Chat Message: not remote evidence.
Claimed Success: not remote evidence.
Simulated Outcome Lanes: paper-only; not real push/PR evidence.
Remote-Sync Execution: not authorized or performed by this drill.
Post-Execution Audit: future-only unless separate execution Human Go and remote evidence exist.
push / PR Authorized: no
remote outcome acceptance: not granted
```
