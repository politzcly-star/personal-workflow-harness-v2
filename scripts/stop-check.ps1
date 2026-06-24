param(
    [string]$ReportPath,
    [switch]$Strict
)

$ErrorActionPreference = "Stop"
$root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$warnings = @()

function Add-Warn {
    param([string]$Message)
    $script:warnings += $Message
    Write-Output ("[WARN] {0}" -f $Message)
}

$template = Join-Path $root "templates/verification-report.md"
if (Test-Path -LiteralPath $template) {
    Write-Output "[OK] verification report template exists"
} else {
    Add-Warn "templates/verification-report.md is missing"
}

if ($ReportPath) {
    $full = if ([System.IO.Path]::IsPathRooted($ReportPath)) { $ReportPath } else { Join-Path $root $ReportPath }
    if (-not (Test-Path -LiteralPath $full)) {
        Add-Warn ("report path not found: {0}" -f $ReportPath)
    } else {
        $text = Get-Content -Raw -LiteralPath $full
        $required = @("Selected Route", "Changed Files", "Checks Run", "Residual Risk")
        foreach ($term in $required) {
            if ($text -notmatch [regex]::Escape($term)) {
                Add-Warn ("verification report missing term: {0}" -f $term)
            }
        }
        if ($text -match "(?i)not-verified" -and $text -notmatch "(?i)Allowed Reason") {
            Add-Warn "not-verified report should include Allowed Reason"
        }
    }
} else {
    Write-Output "[INFO] no concrete report supplied; stop-check verified template availability only"
}

if ($warnings.Count -gt 0) {
    if ($Strict) {
        exit 1
    }
    exit 2
}

Write-Output "[OK] stop-check complete"
exit 0
