param(
    [switch]$Quiet
)

$ErrorActionPreference = "Stop"
$root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$codegraphDir = Join-Path $root ".codegraph"

if (Test-Path -LiteralPath $codegraphDir) {
    if (-not $Quiet) {
        Write-Output "[OK] .codegraph directory exists"
    }
    exit 0
}

$command = Get-Command codegraph -ErrorAction SilentlyContinue
if ($command) {
    if (-not $Quiet) {
        Write-Output ("[INFO] codegraph command is available: {0}" -f $command.Source)
        Write-Output "[WARN] .codegraph directory not found for this project"
    }
    exit 2
}

if (-not $Quiet) {
    Write-Output "[WARN] CodeGraph is not initialized or not available for this project"
    Write-Output "[INFO] fallback: rg + file tree + test entry points + dependency/import scan + manual caller/callee notes"
}
exit 2
