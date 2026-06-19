# Authorization State Field Registry

## Purpose

The authorization state field registry defines the canonical status field names for Phase 22. These fields must appear with consistent `no` values whenever an artifact summarizes authorization state.

## Canonical Status Fields

```text
Execution Authorized: no
Meaning: no command execution, exact command use, route execution, or local execution is authorized.
Required In: guide, task instance, dispatch matrix, child report, cross-artifact consistency checklist, evaluator gate card, parent synthesis, human decision.
Acceptance Effect: missing canonical status field blocks acceptance.
```

```text
push / PR Authorized: no
Meaning: no push and no pull request creation are authorized.
Required In: guide, task instance, dispatch matrix, child report, evaluator gate card, parent synthesis, human decision.
Acceptance Effect: conflicting yes/no fields block acceptance.
```

```text
Remote Action Authorized: no
Meaning: no network remote action, remote command, GitHub issue tracker action, hosted service action, or external action is authorized.
Required In: guide, task instance, dispatch matrix, child report, evaluator gate card, parent synthesis, human decision.
Acceptance Effect: stale evidence or chat-only wording cannot override this field.
```

```text
Remote Execution Authorized: no
Meaning: no remote command execution, remote-sync execution, hosted runner execution, or remote deployment execution is authorized.
Required In: guide, task instance, dispatch matrix, child report, evaluator gate card, parent synthesis, human decision.
Acceptance Effect: local-only state in release scope blocks acceptance when remote execution or release scope is implied.
```

```text
Remote Action Executed: no
Meaning: no remote/network action occurred during the drill.
Required In: guide, task instance, dispatch matrix, child report, evaluator gate card, parent synthesis, human decision.
Acceptance Effect: if evidence shows remote action occurred, Phase 22 acceptance is blocked.
```

```text
Release Authorized: no
Meaning: no release, publication, production deployment, distribution, tag, or release artifact promotion is authorized.
Required In: guide, task instance, child report, cross-artifact consistency checklist, evaluator gate card, parent synthesis, human decision.
Acceptance Effect: local-only state in release scope blocks acceptance.
```

## Forbidden Synonyms

```text
Forbidden Pattern: "remote allowed: yes" without Remote Action Authorized: no
Reason: conflicting yes/no fields obscure authorization state.
Decision: blocks acceptance.
```

```text
Forbidden Pattern: "release ready" when Release Authorized: no is omitted
Reason: local-only state can be mistaken for release permission.
Decision: blocks acceptance.
```

```text
Forbidden Pattern: "artifact complete, proceed" without Execution Authorized: no
Reason: artifact completeness is a non-authorization input.
Decision: blocks acceptance.
```
