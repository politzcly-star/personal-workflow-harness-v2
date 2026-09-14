param([switch]$Strict)
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
& (Join-Path $PSScriptRoot 'health-check.ps1') -Strict
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
# Temp projects only: never initialize live Goal state.
python -B -m unittest discover -s (Join-Path $root 'tests') -p 'test_*.py' -v
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
Write-Output '[OK] offline behavior suite passed; no paid model calls, production actions or runtime routing claims.'
exit 0
