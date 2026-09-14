param([switch]$Strict)
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$failed = $false
$required = @('AGENTS.md','templates/release-authorization.json','.codex/config.toml','.codex/hooks.json','.codex/hooks/harness-hook.ps1','.codex/hooks/authorize-command.ps1','.codex/hooks/validate-report.ps1','scripts/goal-state.ps1','scripts/validate-config.py','scripts/runtime-inspect.py','scripts/verification-evidence.py','.codex/hooks/invoke-authorized.ps1','docs/git-network-policy.md','docs/runtime-readiness-policy.md','templates/verification-evidence.json')
if (-not (Test-Path -LiteralPath (Join-Path $root '.codex/harness-owned.json'))) { $required += @('README.md','docs/model-routing-policy.md','docs/skill-routing-policy.md','docs/cost-efficiency-policy.md','templates/project-profile.md','scripts/migrate-project-harness.ps1','scripts/scope-check.ps1','scripts/stop-check.ps1','tests/test_harness.py','tests/test_migration.py') }
foreach ($relative in $required) {
    if (-not (Test-Path -LiteralPath (Join-Path $root $relative) -PathType Leaf)) { Write-Output "[FAIL] missing $relative"; $failed = $true }
}
foreach ($relative in @('.codex/hooks.json','templates/release-authorization.json')) {
    try { Get-Content -Raw -LiteralPath (Join-Path $root $relative) | ConvertFrom-Json -ErrorAction Stop | Out-Null } catch { Write-Output "[FAIL] JSON $relative"; $failed = $true }
}
foreach ($script in @(Get-ChildItem -LiteralPath (Join-Path $root 'scripts') -Filter '*.ps1' -File) + @(Get-ChildItem -LiteralPath (Join-Path $root '.codex/hooks') -Filter '*.ps1' -File)) {
    $tokens = $null; $errors = $null
    [System.Management.Automation.Language.Parser]::ParseFile($script.FullName, [ref]$tokens, [ref]$errors) | Out-Null
    if ($errors.Count) { Write-Output "[FAIL] syntax $($script.Name): $($errors[0].Message)"; $failed = $true }
}
python -B (Join-Path $PSScriptRoot 'validate-config.py')
if ($LASTEXITCODE -ne 0) { $failed = $true }
if ($failed) { exit 1 }
Write-Output '[OK] static health only; run canonical harness-self-test.ps1 for isolated behavior tests. No MCP/production calls.'
exit 0
