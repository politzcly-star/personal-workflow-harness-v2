# Developer Efficiency Mode

Use the fastest feedback path that can produce trustworthy evidence.

1. Inspect only the files that can change the decision.
2. Run the smallest relevant check first.
3. Broaden verification only when shared behavior, risk, or acceptance requires it.
4. Batch independent reads and checks; do not repeatedly reload unchanged durable documents.
5. Avoid refactors that do not reduce actual risk or complexity.

For scripts, parse syntax and run safe fixtures. For docs, verify required terms, links where relevant, and whitespace. For UI, use browser evidence only when it proves a user-facing outcome. For remote, deployment, or database work, prefer read-only inspection, dry-run, or a checklist over live action.

Cost discipline means root-direct work for clear S0-S2 tasks, one `terra_worker` implementation when delegation helps, and one `luna_verifier` milestone review when required - not a model switch after every small change.
