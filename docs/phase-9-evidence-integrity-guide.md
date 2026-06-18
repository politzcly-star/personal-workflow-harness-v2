# Phase 9 Evidence Integrity Guide

Phase 9 rehearses how the v2 markdown control plane audits Evidence Index integrity, scope-change handling, and recovery from audit blockers.

The guide keeps v2 as a markdown control plane. It does not add runner, CI, Docker, browser automation, source code, production access, secrets, paid actions, push, or PR.

## Core Rule

```text
Human-signed North Star
> append-only Evidence Index
> scope-change records
> Evaluator evidence-first findings
> Parent Synthesis with Evidence IDs
> Human Decision
> Chat Context
```

Evidence Index is append-only. Old entries are never deleted, rewritten, renumbered, or silently reclassified.

## Audit Blockers

```text
duplicate Evidence ID: No-Go
missing evidence refs: No-Go
overwritten evaluator finding: No-Go
uncited scope-change: No-Go
scope-change smuggled into existing scope: blocked: needs-human-decision
fake accepted-risk: No-Go
```

Parent cannot assign itself. Parent cannot treat chat memory as audit evidence. Parent cannot repair an Evidence Index violation by editing an old entry; it can only append a new correction record and route unresolved conflict to Human decision.

## Scope-Change Handling

Every scope-change needs:

- a new Evidence ID
- reason and timestamp
- prior scope reference
- proposed new scope reference
- Human decision state
- Evaluator review result

If a child needs work outside Allowed Changes, it must stop or request scope-change evidence. It cannot smuggle the change into an existing scope entry.

## Evaluator Review

```text
Pass Type: evidence-first
Purpose: inspect raw Evidence Index, scope-change records, child reports, verification outputs, and audit records before reading Parent Synthesis.
```

```text
Pass Type: synthesis-comparison
Purpose: compare Parent Synthesis against evidence-first audit findings and ensure every claim cites Evidence IDs.
```

Evaluator `No-Go` blocks acceptance. `Conditional Go` requires follow-up review before acceptance. Missing evidence refs, duplicate Evidence ID, overwritten evaluator finding, or uncited scope-change are blocking.

## Recovery

Recovery must append new evidence. Valid recovery records include:

- conflict record for disputed audit findings
- scope-change record for changed boundaries
- evaluator-finding record for follow-up review
- human-decision record for Go, Reject, accepted-risk, or follow-up

Accepted-risk is valid only when Human explicitly names and accepts the risk. Parent cannot infer accepted-risk from chat memory.

