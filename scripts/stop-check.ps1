param(
    [string]$ReportPath,
    [switch]$Strict
)

$ErrorActionPreference = "Stop"
$root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path

if (-not $ReportPath) {
    Write-Output "[INFO] no report supplied; no completion claim was checked"
    exit 0
}

$full = if ([System.IO.Path]::IsPathRooted($ReportPath)) { $ReportPath } else { Join-Path $root $ReportPath }
if (-not (Test-Path -LiteralPath $full -PathType Leaf)) {
    Write-Output ("[FAIL] report path not found: {0}" -f $ReportPath)
    exit 1
}

$text = Get-Content -Raw -LiteralPath $full
$missing = @()
foreach ($term in @("Task ID", "Status", "Changed Files", "Checks Run", "Scope Guard", "Residual Risk", "Next Recommended Action")) {
    if ($text -notmatch [regex]::Escape($term)) {
        $missing += $term
    }
}

if ($text -match "TODO") {
    $missing += "resolved report fields (contains TODO)"
}

if ($missing.Count -gt 0) {
    foreach ($item in $missing) {
        Write-Output ("[FAIL] report missing {0}" -f $item)
    }
    exit 1
}

Write-Output "[OK] concrete verification report has required evidence fields"
exit 0
