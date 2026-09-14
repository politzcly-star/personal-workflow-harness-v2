# Branch finish — compact evidence

Use existing task evidence, not another mandatory report. Routine local completion does not require branch cleanup.

```text
Task / accepted outcome:
Frozen starting base / current HEAD / inherited dirty work:
Required local checks:
Evidence path / check ID / re-established environment ID:
Tested working tree / intended staged content agreement (if delivering a commit):
Changed facts invalidating evidence, if any:
Scope / secrets / independent review result:
State: locally verified | push pending | pushed | deployed | production accepted
Integration action covered by existing authority:
External blocker / eligible local work completed:
Residual risk / next action:
```

branch-finish-check.ps1 accepts either TestCommand or EvidencePath plus CheckId/EnvironmentId. Valid content-bound local evidence need not be rerun for a stage label. Supply BaseRef for the actual frozen project base rather than assuming main/master. No remote refresh just to recover context; integration freshness still follows the project contract.
EvidencePath selects verify --require-index-match for staged delivery. For ordinary unstaged development use the helper's default verify instead; do not present its local-only result as commit acceptance. A changed semantic index invalidates this cache; stage only the intended deliverable within existing authority before final checks. Normal Git text/autocrlf EOL conversion is supported; unsupported filters require a separate verified delivery path, not an unchanged retry loop.
Only take already-authorized commit/push/merge actions; ask once at an uncovered boundary, not once per phase. Discard/delete needs exact scope confirmation. Never clean up unrelated dirty work or claim local success means pushed/deployed.
