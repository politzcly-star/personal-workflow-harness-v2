# Reporting Policy

Reports should match task weight. Formal delivery evidence is useful for S3/S4 work, but too heavy for discussion and small fixes.

## S0: Direct Answer

Use for discussion, prompts, explanations, and no-code analysis.

Expected response:

```text
discussion / no code changes
answer
```

Route/report fields are optional unless the Human asks.

## S1: Lightweight Report

Use for known files, small fixes, single-point changes.

Minimum:

```text
Route/S-level:
Changed:
Verified:
Residual risk:
```

If no files changed, say so.

## S2: Standard Report

Use for bounded medium work.

Minimum:

```text
Route/S-level:
Files changed:
Checks run:
Skipped checks and reason:
Residual risk:
```

Mention whether child was used or skipped when relevant.

## S3-S4: Formal Delivery Report

Use for high-risk, hidden acceptance, deployment, database, security, permission, public API, production server, formal module, and long staged delivery.

Include:

- route, S-level, and layer;
- child task/report summary when used;
- reviewer or checklist status when required;
- files changed;
- commands/checks and result;
- skipped checks and allowed reason;
- rollback/operator boundary when applicable;
- residual risk;
- next recommended action.

## Not Verified

Do not claim completion without evidence. If a check cannot be run, record:

- exact check skipped;
- why skipping is allowed;
- what risk remains;
- what would close the gap later.

## Product Artifacts

When the deliverable is a PPT, dashboard, document, page, agent product, or script tool, pair the report with `templates/product-acceptance.md` when quality matters.
