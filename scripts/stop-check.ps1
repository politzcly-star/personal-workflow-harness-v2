param([string]$ReportPath, [string]$ExpectedTaskId, [switch]$Strict)
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
. (Join-Path $root '.codex/hooks/validate-report.ps1')
if (-not $ReportPath) { Write-Output '[INFO] no report supplied; no completion claim was checked'; exit 0 }
$full = if ([IO.Path]::IsPathRooted($ReportPath)) { $ReportPath } else { Join-Path $root $ReportPath }
if (-not (Test-Path -LiteralPath $full -PathType Leaf)) { Write-Output '[FAIL] missing report'; exit 1 }
if (-not (Test-HarnessCompletionReport -Text (Get-Content -Raw -LiteralPath $full) -ExpectedTaskId $ExpectedTaskId)) { Write-Output '[FAIL] inconsistent, unsuccessful, empty or mismatched completion report'; exit 1 }
Write-Output '[OK] final report consistency checked; actual test truth still requires independent evidence'
exit 0
