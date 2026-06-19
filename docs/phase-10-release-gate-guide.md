# Phase 10 Release Gate Guide

Phase 10 rehearses a release gate for remote-sync readiness. It keeps v2 as a markdown control plane and does not add runner, CI, Docker, browser automation, source code, production access, secrets, paid actions, push, or PR.

## Authority

```text
Human-signed North Star
> local commit acceptance evidence
> release gate checklist
> evaluator evidence-first findings
> evaluator synthesis-comparison findings
> Parent Synthesis
> Child Reports / Evidence Refs
> Chat Context
```

Local commit acceptance is not push/PR authorization. A push or PR requires a separate Human Go with a release evidence ref. Parent cannot infer release approval from a prior local commit approval, chat memory, or a commit being ahead of origin.

## Release Gate Blockers

```text
dirty staged files: No-Go
missing release evidence: No-Go
fake push approval: No-Go
unreviewed scope change: No-Go
unexpected files in release scope: No-Go
local state included in release scope: No-Go
```

`.claude/settings.local.json` and other local state are excluded from release scope. They may remain untracked local state, but they must not be staged, committed, pushed, or cited as release payload evidence.

## Parent Response

Parent cannot assign itself. Parent can prepare release gate artifacts, synthesize evidence, and ask Human for a separate remote-sync decision. Parent cannot push, open a PR, or treat Phase 1-9 local Human Go records as remote approval.

## Evaluator Review

```text
Pass Type: evidence-first
Purpose: inspect git status, commit list, staged files, release gate checklist, child report, and Evidence Index before reading Parent Synthesis.
```

```text
Pass Type: synthesis-comparison
Purpose: compare Parent Synthesis against evidence-first release findings and ensure every release claim cites Evidence IDs.
```

Evaluator `No-Go` blocks release. Missing release evidence, fake push approval, dirty staged files, unreviewed scope change, or unexpected files must route back to blocked review before any remote-sync action.

## Human Decision

Human Decision remains pending until the user gives a separate Human Go for push or PR. The placeholder must state `push / PR Authorized: no` until that happens.
