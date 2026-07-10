$ErrorActionPreference = "Stop"
$root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$hook = Join-Path $root ".codex/hooks/harness-hook.ps1"
$scope = Join-Path $root "scripts/scope-check.ps1"
$stop = Join-Path $root "scripts/stop-check.ps1"
$health = Join-Path $root "scripts/health-check.ps1"
$profileInit = Join-Path $root "scripts/init-project-profile.ps1"
$migrate = Join-Path $root "scripts/migrate-project-harness.ps1"
$goalState = Join-Path $root "scripts/goal-state.ps1"

function Assert-True {
    param(
        [bool]$Condition,
        [string]$Message
    )

    if (-not $Condition) {
        throw $Message
    }
}

function Invoke-HookFixture {
    param(
        [string]$Name,
        [string]$ToolName,
        [string]$Command,
        [bool]$ExpectDenied
    )

    $payload = @{ tool_name = $ToolName; tool_input = @{ command = $Command } } | ConvertTo-Json -Compress
    $raw = $payload | & powershell -NoProfile -ExecutionPolicy Bypass -File $hook -Event PreToolUse
    $response = if ($raw) { $raw | ConvertFrom-Json } else { $null }
    $denied = $false
    if ($null -ne $response -and $null -ne $response.hookSpecificOutput) {
        $denied = $response.hookSpecificOutput.permissionDecision -eq "deny"
    }

    Assert-True -Condition ($denied -eq $ExpectDenied) -Message ("hook fixture failed: {0}" -f $Name)
    Write-Output ("[OK] hook fixture {0}" -f $Name)
}

function Invoke-PatchFixture {
    param(
        [string]$Name,
        [string]$Patch,
        [bool]$ExpectDenied
    )

    $payload = @{ tool_name = "apply_patch"; tool_input = @{ patch = $Patch } } | ConvertTo-Json -Compress
    $raw = $payload | & powershell -NoProfile -ExecutionPolicy Bypass -File $hook -Event PreToolUse
    $response = if ($raw) { $raw | ConvertFrom-Json } else { $null }
    $denied = $false
    if ($null -ne $response -and $null -ne $response.hookSpecificOutput) {
        $denied = $response.hookSpecificOutput.permissionDecision -eq "deny"
    }

    Assert-True -Condition ($denied -eq $ExpectDenied) -Message ("patch fixture failed: {0}" -f $Name)
    Write-Output ("[OK] patch fixture {0}" -f $Name)
}

function Assert-ExitCode {
    param(
        [int]$Expected,
        [string]$Message
    )

    Assert-True -Condition ($LASTEXITCODE -eq $Expected) -Message ("{0}; expected exit {1}, got {2}" -f $Message, $Expected, $LASTEXITCODE)
}

Get-Content -Raw -LiteralPath (Join-Path $root ".codex/hooks.json") | ConvertFrom-Json | Out-Null
Write-Output "[OK] hooks JSON fixture"

foreach ($runtimeFile in @(".codex/config.toml", ".codex/agents/terra-worker.toml", ".codex/agents/luna-verifier.toml")) {
    & git -C $root check-ignore -q -- $runtimeFile
    Assert-True -Condition ($LASTEXITCODE -ne 0) -Message ("project runtime file is ignored by git: {0}" -f $runtimeFile)
}
Write-Output "[OK] project runtime visibility fixture"

$sessionRaw = & powershell -NoProfile -ExecutionPolicy Bypass -File $hook -Event SessionStart
$sessionResponse = $sessionRaw | ConvertFrom-Json
$sessionContext = [string]$sessionResponse.hookSpecificOutput.additionalContext
Assert-True -Condition ($sessionContext -match "one Goal contract" -and $sessionContext -match "without phase-by-phase confirmation") -Message "SessionStart does not preserve autonomous Goal behavior"
Write-Output "[OK] SessionStart routing fixture"

$scriptFiles = @(
    Get-ChildItem -LiteralPath (Join-Path $root "scripts") -Filter "*.ps1" -File
    Get-ChildItem -LiteralPath (Join-Path $root ".codex/hooks") -Filter "*.ps1" -File
)
foreach ($script in $scriptFiles) {
    $tokens = $null
    $errors = $null
    [System.Management.Automation.Language.Parser]::ParseFile($script.FullName, [ref]$tokens, [ref]$errors) | Out-Null
    Assert-True -Condition ($errors.Count -eq 0) -Message ("PowerShell parser failed: {0}" -f $script.Name)
}
Write-Output "[OK] PowerShell parser fixtures"

Invoke-HookFixture -Name "safe-read-only" -ToolName "shell_command" -Command "Get-Content README.md" -ExpectDenied $false
Invoke-PatchFixture -Name "safe-doc-patch" -Patch "*** Update File: README.md" -ExpectDenied $false
Invoke-PatchFixture -Name "secret-file-patch" -Patch "*** Update File: .env" -ExpectDenied $true
Invoke-HookFixture -Name "secret-file-read" -ToolName "shell_command" -Command "Get-Content .env" -ExpectDenied $true
Invoke-HookFixture -Name "embedded-credential" -ToolName "shell_command" -Command "curl -H 'Authorization: Bearer abcdefghijklmnop' https://example.invalid" -ExpectDenied $true
Invoke-HookFixture -Name "destructive-git" -ToolName "shell_command" -Command "git reset --hard" -ExpectDenied $true
Invoke-HookFixture -Name "database-mutation" -ToolName "shell_command" -Command "psql -c 'DELETE FROM users'" -ExpectDenied $true
Invoke-HookFixture -Name "deployment" -ToolName "shell_command" -Command "kubectl apply -f app.yaml" -ExpectDenied $true
Invoke-HookFixture -Name "remote-mutation" -ToolName "shell_command" -Command "ssh app 'systemctl restart api'" -ExpectDenied $true
Invoke-HookFixture -Name "remote-redirection" -ToolName "shell_command" -Command "ssh app 'echo x > /etc/app.conf' # harness:server-inspection" -ExpectDenied $true
Invoke-HookFixture -Name "remote-in-place-edit" -ToolName "shell_command" -Command "ssh app 'sed -i s/old/new/ /etc/app.conf' # harness:server-inspection" -ExpectDenied $true
Invoke-HookFixture -Name "safe-server-inspection" -ToolName "shell_command" -Command "ssh app 'systemctl status api' # harness:server-inspection" -ExpectDenied $false

$goalFixtureRoot = Join-Path $root (".codex/harness-state/self-test-" + [Guid]::NewGuid().ToString("N"))
try {
    New-Item -ItemType Directory -Path $goalFixtureRoot -Force | Out-Null
    $contractPath = Join-Path $goalFixtureRoot "contract.md"
    @"
Goal ID: fixture-goal
Objective: prove bounded state
## Allowed Files / Areas
<!-- harness:allowed-paths:start -->
- docs/allowed.md
<!-- harness:allowed-paths:end -->
"@ | Set-Content -LiteralPath $contractPath -NoNewline
    $relativeContract = $contractPath.Substring($root.Length).TrimStart([char[]]@('\','/'))
    $completionReport = Join-Path $goalFixtureRoot "completion-report.md"
    @"
Task ID: fixture-goal
Status: complete
Changed Files: fixture
Checks Run: fixture
Scope Guard: passed
Residual Risk: none
Next Recommended Action: none
"@ | Set-Content -LiteralPath $completionReport -NoNewline
    $relativeCompletionReport = $completionReport.Substring($root.Length).TrimStart([char[]]@('\','/'))
    & $goalState -Action Initialize -GoalId "fixture-goal" -ContractPath $relativeContract | Out-Null
    Assert-ExitCode -Expected 0 -Message "goal initialize fixture"
    & $goalState -Action Activate -GoalId "fixture-goal" | Out-Null
    Assert-ExitCode -Expected 0 -Message "goal activate fixture"
    $beforeReplacement = Get-Content -Raw -LiteralPath (Join-Path $root ".codex/harness-state/active-goal.json")
    & $goalState -Action Initialize -GoalId "replacement-goal" -ContractPath $relativeContract | Out-Null
    Assert-ExitCode -Expected 1 -Message "active Goal replacement Initialize fixture"
    Assert-True -Condition ((Get-Content -Raw -LiteralPath (Join-Path $root ".codex/harness-state/active-goal.json")) -eq $beforeReplacement) -Message "Initialize replaced an active authorization state"
    $capsulePath = Join-Path $goalFixtureRoot "input-capsule.md"
    "Goal ID: fixture-goal`nContext epoch: 1`nNext action: focused verification" | Set-Content -LiteralPath $capsulePath -NoNewline
    & $goalState -Action Checkpoint -GoalId "fixture-goal" -CapsulePath $capsulePath -Milestone "M1" -NextAction "verify" | Out-Null
    Assert-ExitCode -Expected 0 -Message "goal checkpoint fixture"
    $show = & $goalState -Action Show -GoalId "fixture-goal" | ConvertFrom-Json
    Assert-True -Condition ($show.ContextEpoch -eq 1 -and $show.AllowedPaths -contains "docs/allowed.md") -Message "goal show fixture lost compact state"
    $resumePayload = @{ source = "compact" } | ConvertTo-Json -Compress
    $resumeRaw = $resumePayload | & powershell -NoProfile -ExecutionPolicy Bypass -File $hook -Event SessionStart
    Assert-True -Condition (($resumeRaw | ConvertFrom-Json).hookSpecificOutput.additionalContext -match "active Goal fixture-goal") -Message "compact resume did not use bounded Goal pointer"
    $preCompactRaw = & powershell -NoProfile -ExecutionPolicy Bypass -File $hook -Event PreCompact
    Assert-True -Condition (-not [string]::IsNullOrWhiteSpace($preCompactRaw)) -Message "PreCompact fixture did not return non-blocking output"
    Invoke-PatchFixture -Name "active-in-scope-patch" -Patch "*** Update File: docs/allowed.md" -ExpectDenied $false
    Invoke-PatchFixture -Name "active-out-of-scope-patch" -Patch "*** Update File: outside.md" -ExpectDenied $true
    Invoke-PatchFixture -Name "active-contract-edit" -Patch ("*** Update File: " + ($relativeContract -replace '\\','/')) -ExpectDenied $true
    Invoke-PatchFixture -Name "active-hook-edit" -Patch "*** Update File: .codex/hooks/harness-hook.ps1" -ExpectDenied $true
    Invoke-PatchFixture -Name "active-goal-state-script-edit" -Patch "*** Update File: scripts/goal-state.ps1" -ExpectDenied $true
    Invoke-PatchFixture -Name "active-authorization-state-edit" -Patch "*** Update File: .codex/harness-state/active-goal.json" -ExpectDenied $true
    Invoke-HookFixture -Name "active-ambiguous-mutation" -ToolName "shell_command" -Command "Set-Content docs/allowed.md safe" -ExpectDenied $true
    Invoke-HookFixture -Name "active-goal-state-initialize" -ToolName "shell_command" -Command ".\scripts\goal-state.ps1 -Action Initialize -GoalId replacement -ContractPath tasks/contract.md" -ExpectDenied $true
    Invoke-HookFixture -Name "active-goal-state-validate" -ToolName "shell_command" -Command ".\scripts\goal-state.ps1 -Action Validate" -ExpectDenied $false
    Invoke-HookFixture -Name "active-goal-state-checkpoint" -ToolName "shell_command" -Command ".\scripts\goal-state.ps1 -Action Checkpoint -CapsulePath docs/capsule.md" -ExpectDenied $false
    Invoke-HookFixture -Name "active-goal-state-close-without-control" -ToolName "shell_command" -Command ".\scripts\goal-state.ps1 -Action Close -ReportPath $relativeCompletionReport" -ExpectDenied $true
    Invoke-HookFixture -Name "active-goal-state-close-with-control" -ToolName "shell_command" -Command ".\scripts\goal-state.ps1 -Action Close -ReportPath $relativeCompletionReport # harness:goal-close" -ExpectDenied $false
    "Goal ID: fixture-goal`nContext epoch: 0`nNext action: stale" | Set-Content -LiteralPath (Join-Path $root ".codex/harness-state/capsule-fixture-goal.md") -NoNewline
    & $goalState -Action Validate -GoalId "fixture-goal" | Out-Null
    Assert-ExitCode -Expected 1 -Message "stale capsule epoch fixture"
    & $goalState -Action Close -GoalId "fixture-goal" -ReportPath $relativeCompletionReport | Out-Null
    Assert-ExitCode -Expected 0 -Message "close stale Goal before reinitialize fixture"
    & $goalState -Action Initialize -GoalId "fixture-goal" -ContractPath $relativeContract | Out-Null
    & $goalState -Action Activate -GoalId "fixture-goal" | Out-Null
    "Goal ID: fixture-goal`nContext epoch: 1`nsecret: forbidden" | Set-Content -LiteralPath $capsulePath -NoNewline
    & $goalState -Action Checkpoint -GoalId "fixture-goal" -CapsulePath $capsulePath | Out-Null
    Assert-ExitCode -Expected 1 -Message "secret-like capsule fixture"
    Set-Content -LiteralPath $capsulePath -Value ("Context epoch: 1`n" + ('x' * 17000)) -NoNewline
    & $goalState -Action Checkpoint -GoalId "fixture-goal" -CapsulePath $capsulePath | Out-Null
    Assert-ExitCode -Expected 1 -Message "oversized capsule fixture"
    Add-Content -LiteralPath $contractPath -Value "`nchanged"
    & $goalState -Action Validate -GoalId "fixture-goal" | Out-Null
    Assert-ExitCode -Expected 1 -Message "contract hash mismatch fixture"
    "malformed" | Set-Content -LiteralPath (Join-Path $root ".codex/harness-state/active-goal.json") -NoNewline
    & $goalState -Action Validate | Out-Null
    Assert-ExitCode -Expected 1 -Message "malformed state fixture"
    Remove-Item -LiteralPath (Join-Path $root ".codex/harness-state/active-goal.json") -Force
    & $goalState -Action Initialize -GoalId "fixture-close" -ContractPath $relativeContract | Out-Null
    Assert-ExitCode -Expected 0 -Message "goal reinitialize for close fixture"
    & $goalState -Action Close -GoalId "fixture-close" -ReportPath $relativeCompletionReport | Out-Null
    Assert-ExitCode -Expected 0 -Message "goal close fixture"
    Assert-True -Condition (-not (Test-Path -LiteralPath (Join-Path $root ".codex/harness-state/active-goal.json"))) -Message "Close left active state behind"
    Assert-True -Condition (-not (Test-Path -LiteralPath (Join-Path $root ".codex/harness-state/capsule-fixture-close.md"))) -Message "Close left capsule behind"
} finally {
    $testActive = Join-Path $root ".codex/harness-state/active-goal.json"
    if (Test-Path -LiteralPath $testActive) { Remove-Item -LiteralPath $testActive -Force }
    $testCapsule = Join-Path $root ".codex/harness-state/capsule-fixture-goal.md"
    if (Test-Path -LiteralPath $testCapsule) { Remove-Item -LiteralPath $testCapsule -Force }
    if (Test-Path -LiteralPath $goalFixtureRoot) { [System.IO.Directory]::Delete($goalFixtureRoot, $true) }
}
Write-Output "[OK] Goal state, compaction, and contract-scope fixtures"

& $scope -Strict -AllowedPath "docs/allowed.md" -ChangedPath "docs/allowed.md" | Out-Null
Assert-ExitCode -Expected 0 -Message "scope exact allowlist fixture"
& $scope -Strict -AllowedPath "docs/allowed.md" -ChangedPath "outside.md" | Out-Null
Assert-ExitCode -Expected 1 -Message "scope outside-allowlist fixture"
Write-Output "[OK] scope fixtures"

$baselineFixtureRoot = Join-Path ([IO.Path]::GetTempPath()) ("harness-scope-baseline-" + [Guid]::NewGuid().ToString("N"))
try {
    New-Item -ItemType Directory -Path (Join-Path $baselineFixtureRoot "scripts") -Force | Out-Null
    Copy-Item -LiteralPath $scope -Destination (Join-Path $baselineFixtureRoot "scripts/scope-check.ps1")
    Push-Location $baselineFixtureRoot
    git init -q; git config user.email "fixture@example.invalid"; git config user.name "fixture"
    "baseline.json" | Set-Content -LiteralPath ".git/info/exclude" -NoNewline
    "base" | Set-Content -LiteralPath "tracked.txt" -NoNewline; git add tracked.txt; git commit -qm baseline
    "before" | Set-Content -LiteralPath "tracked.txt" -NoNewline
    $fixtureScope = Join-Path $baselineFixtureRoot "scripts/scope-check.ps1"
    $baselineFixture = Join-Path $baselineFixtureRoot "baseline.json"
    & $fixtureScope -Strict -BaselineManifest $baselineFixture -CaptureBaseline | Out-Null
    Assert-ExitCode -Expected 0 -Message "content baseline capture fixture"
    $captured = Get-Content -Raw -LiteralPath $baselineFixture | ConvertFrom-Json
    Assert-True -Condition ($captured.schema_version -eq 2 -and $null -ne $captured.files."tracked.txt") -Message "content baseline did not record per-file hash"
    $unchangedOutput = & $fixtureScope -Strict -AllowedPath "tracked.txt" -BaselineManifest $baselineFixture
    Assert-ExitCode -Expected 0 -Message "unchanged content baseline fixture"
    Assert-True -Condition (($unchangedOutput -join "`n") -match "unchanged content baseline path excluded: tracked.txt") -Message "normal Git discovery did not exclude unchanged captured file"
    "after" | Set-Content -LiteralPath "tracked.txt" -NoNewline
    $scopeOutput = & $fixtureScope -Strict -AllowedPath "tracked.txt" -BaselineManifest $baselineFixture
    Assert-ExitCode -Expected 0 -Message "changed content baseline fixture"
    Assert-True -Condition (($scopeOutput -join "`n") -match "changed files:[\s\S]*tracked.txt") -Message "normal Git discovery did not expose changed captured file"
} finally {
    if ((Get-Location).Path -eq $baselineFixtureRoot) { Pop-Location }
    if (Test-Path -LiteralPath $baselineFixtureRoot) {
        Get-ChildItem -LiteralPath $baselineFixtureRoot -Recurse -Force | ForEach-Object { $_.Attributes = [IO.FileAttributes]::Normal }
        [IO.Directory]::Delete($baselineFixtureRoot, $true)
    }
}
Write-Output "[OK] content-hash baseline fixtures"

$reportPath = [System.IO.Path]::GetTempFileName()
try {
    @"
Task ID: fixture
Status: passed
Changed Files: none
Checks Run: fixture
Scope Guard: passed
Residual Risk: none
Next Recommended Action: none
"@ | Set-Content -LiteralPath $reportPath -NoNewline
    & $stop -Strict -ReportPath $reportPath | Out-Null
    Assert-ExitCode -Expected 0 -Message "complete report fixture"

    "Task ID: incomplete" | Set-Content -LiteralPath $reportPath -NoNewline
    & $stop -Strict -ReportPath $reportPath | Out-Null
    Assert-ExitCode -Expected 1 -Message "incomplete report fixture"
} finally {
    [System.IO.File]::Delete($reportPath)
}
Write-Output "[OK] report fixtures"

$profileRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("harness-profile-" + [Guid]::NewGuid().ToString("N"))
try {
    New-Item -ItemType Directory -Path $profileRoot | Out-Null
    & $profileInit -ProjectName "fixture-project" -ProjectPath $profileRoot -OutPath "docs/project-profile.md" | Out-Null
    Assert-ExitCode -Expected 0 -Message "project-profile initialization fixture"

    $profile = Get-Content -Raw -LiteralPath (Join-Path $profileRoot "docs/project-profile.md")
    $expectedRoot = (Resolve-Path -LiteralPath $profileRoot).Path
    Assert-True -Condition ($profile -match "(?m)^Project: fixture-project\r?$") -Message "project name was not written to profile"
    Assert-True -Condition ($profile -match ([regex]::Escape("Repository Root: " + $expectedRoot))) -Message "project root was not written to profile"
} finally {
    if (Test-Path -LiteralPath $profileRoot) {
        [System.IO.Directory]::Delete($profileRoot, $true)
    }
}
Write-Output "[OK] project-profile fixture"

$featurePlan = Get-Content -Raw -LiteralPath (Join-Path $root "templates/feature-plan.md")
Assert-True -Condition ($featurePlan -notmatch "(?m)^Layer:") -Message "feature-plan still requires a layer"
Assert-True -Condition ($featurePlan -match "(?m)^S-Level: S2$") -Message "feature-plan is missing the S2 primary weight"
Write-Output "[OK] feature-plan routing fixture"

$migrationRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("harness-migration-" + [Guid]::NewGuid().ToString("N"))
try {
    New-Item -ItemType Directory -Path $migrationRoot | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $migrationRoot "docs") | Out-Null
    "project facts must survive" | Set-Content -LiteralPath (Join-Path $migrationRoot "PROJECT_FACTS.md") -NoNewline

    $dryRun = & $migrate -ProjectPath $migrationRoot
    Assert-ExitCode -Expected 0 -Message "migration dry-run fixture"
    Assert-True -Condition (-not (Test-Path -LiteralPath (Join-Path $migrationRoot ".codex/config.toml"))) -Message "dry run changed the project"
    Assert-True -Condition (($dryRun -join "`n") -match "DRY RUN") -Message "dry run did not report its mode"

    & $migrate -ProjectPath $migrationRoot -Apply | Out-Null
    Assert-ExitCode -Expected 0 -Message "migration apply fixture"
    foreach ($relative in @(
        "AGENTS.md",
        "docs/project-profile.md",
        ".codex/config.toml",
        ".codex/agents/terra-worker.toml",
        ".codex/agents/luna-verifier.toml",
        ".codex/hooks.json",
        ".codex/hooks/harness-hook.ps1",
        "scripts/goal-state.ps1",
        "templates/goal-contract.md",
        "templates/context-capsule.md"
    )) {
        Assert-True -Condition (Test-Path -LiteralPath (Join-Path $migrationRoot $relative) -PathType Leaf) -Message ("migration missed {0}" -f $relative)
    }
    $installedAgents = Get-Content -Raw -LiteralPath (Join-Path $migrationRoot "AGENTS.md")
    Assert-True -Condition ($installedAgents -match "terra_worker" -and $installedAgents -match "luna_verifier") -Message "managed AGENTS block misses automatic roles"
    Assert-True -Condition ($installedAgents -notmatch '```text') -Message "managed AGENTS block installed a fenced example instead of instructions"
    Assert-True -Condition (Test-Path -LiteralPath (Join-Path $migrationRoot "PROJECT_FACTS.md")) -Message "migration removed project facts"
    $migrationExclude = Get-Content -Raw -LiteralPath (Join-Path $migrationRoot ".git/info/exclude")
    Assert-True -Condition ($migrationExclude -match "\.codex/harness-state/") -Message "migration did not ignore runtime Goal state"

    "model = 'legacy'" | Set-Content -LiteralPath (Join-Path $migrationRoot ".codex/config.toml") -NoNewline
    & $migrate -ProjectPath $migrationRoot -Apply | Out-Null
    Assert-ExitCode -Expected 2 -Message "migration config-conflict fixture"
    $legacyConfig = Get-Content -Raw -LiteralPath (Join-Path $migrationRoot ".codex/config.toml")
    Assert-True -Condition ($legacyConfig -eq "model = 'legacy'") -Message "blocked migration overwrote config"

    & $migrate -ProjectPath $migrationRoot -Apply -ReplaceConfig | Out-Null
    Assert-ExitCode -Expected 0 -Message "migration config-replacement fixture"
    $installedConfig = Get-Content -Raw -LiteralPath (Join-Path $migrationRoot ".codex/config.toml")
    Assert-True -Condition ($installedConfig -match 'model = "gpt-5\.6-terra"') -Message "replacement did not install Terra daily root model"
    $configBackups = @(Get-ChildItem -LiteralPath (Join-Path $migrationRoot ".codex/legacy-harness-backup") -Recurse -Filter "config.toml" -File)
    Assert-True -Condition ($configBackups.Count -gt 0) -Message "replacement did not back up config"

    "legacy route policy" | Set-Content -LiteralPath (Join-Path $migrationRoot "docs/route-policy.md") -NoNewline
    & $migrate -ProjectPath $migrationRoot -Apply -ArchiveLegacyHarness | Out-Null
    Assert-ExitCode -Expected 0 -Message "legacy archive fixture"
    Assert-True -Condition (-not (Test-Path -LiteralPath (Join-Path $migrationRoot "docs/route-policy.md"))) -Message "legacy route policy remained active"
    $routeBackups = @(Get-ChildItem -LiteralPath (Join-Path $migrationRoot ".codex/legacy-harness-backup") -Recurse -Filter "route-policy.md" -File)
    Assert-True -Condition ($routeBackups.Count -gt 0) -Message "legacy route policy was not archived"
} finally {
    if (Test-Path -LiteralPath $migrationRoot) {
        [System.IO.Directory]::Delete($migrationRoot, $true)
    }
}
Write-Output "[OK] project migration fixtures"

$legacyAgentsRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("harness-legacy-agents-" + [Guid]::NewGuid().ToString("N"))
try {
    New-Item -ItemType Directory -Path $legacyAgentsRoot | Out-Null
    "# Production Harness Starter Instructions`n`nlegacy harness body" | Set-Content -LiteralPath (Join-Path $legacyAgentsRoot "AGENTS.md") -NoNewline

    & $migrate -ProjectPath $legacyAgentsRoot -Apply | Out-Null
    Assert-ExitCode -Expected 2 -Message "unmarked legacy AGENTS blocker fixture"
    $blockedAgents = Get-Content -Raw -LiteralPath (Join-Path $legacyAgentsRoot "AGENTS.md")
    Assert-True -Condition ($blockedAgents -match "legacy harness body") -Message "blocked migration changed legacy AGENTS.md"

    & $migrate -ProjectPath $legacyAgentsRoot -Apply -ReplaceLegacyAgents | Out-Null
    Assert-ExitCode -Expected 0 -Message "unmarked legacy AGENTS replacement fixture"
    $replacedAgents = Get-Content -Raw -LiteralPath (Join-Path $legacyAgentsRoot "AGENTS.md")
    Assert-True -Condition ($replacedAgents -match "production-harness-v2:start" -and $replacedAgents -notmatch "legacy harness body") -Message "legacy AGENTS.md was not replaced by the managed block"
    $agentsBackups = @(Get-ChildItem -LiteralPath (Join-Path $legacyAgentsRoot ".codex/legacy-harness-backup") -Recurse -Filter "AGENTS.md" -File)
    Assert-True -Condition ($agentsBackups.Count -gt 0) -Message "legacy AGENTS.md replacement was not backed up"
} finally {
    if (Test-Path -LiteralPath $legacyAgentsRoot) {
        [System.IO.Directory]::Delete($legacyAgentsRoot, $true)
    }
}
Write-Output "[OK] legacy AGENTS migration fixtures"

$v21AgentsRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("harness-v21-agents-" + [Guid]::NewGuid().ToString("N"))
try {
    New-Item -ItemType Directory -Path $v21AgentsRoot | Out-Null
    @"
# AGENTS.md - legacy workflow and project rules

## AI Workflow Operating System

Legacy workflow instructions.

## Production Harness v2.1

Medium tasks require the old packet.

# Project Conventions for fixture

Keep this durable project rule.

<!-- production-harness-v2:start -->
old managed block
<!-- production-harness-v2:end -->
"@ | Set-Content -LiteralPath (Join-Path $v21AgentsRoot "AGENTS.md") -NoNewline

    & $migrate -ProjectPath $v21AgentsRoot -Apply | Out-Null
    Assert-ExitCode -Expected 2 -Message "managed v2.1 AGENTS blocker fixture"

    & $migrate -ProjectPath $v21AgentsRoot -Apply -ReplaceLegacyAgents | Out-Null
    Assert-ExitCode -Expected 0 -Message "managed v2.1 AGENTS replacement fixture"
    $v21Agents = Get-Content -Raw -LiteralPath (Join-Path $v21AgentsRoot "AGENTS.md")
    Assert-True -Condition ($v21Agents -notmatch "AI Workflow Operating System" -and $v21Agents -notmatch "Production Harness v2\.1") -Message "v2.1 workflow preamble remained active"
    Assert-True -Condition ($v21Agents -match "Keep this durable project rule" -and $v21Agents -match "gpt-5\.6-terra") -Message "v2.1 migration did not preserve project rules and install the new managed block"
    $v21Backups = @(Get-ChildItem -LiteralPath (Join-Path $v21AgentsRoot ".codex/legacy-harness-backup") -Recurse -Filter "AGENTS.md" -File)
    Assert-True -Condition ($v21Backups.Count -gt 0) -Message "v2.1 AGENTS replacement was not backed up"
} finally {
    if (Test-Path -LiteralPath $v21AgentsRoot) {
        [System.IO.Directory]::Delete($v21AgentsRoot, $true)
    }
}
Write-Output "[OK] managed v2.1 AGENTS migration fixtures"

$mixedAgentsRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("harness-mixed-agents-" + [Guid]::NewGuid().ToString("N"))
try {
    New-Item -ItemType Directory -Path $mixedAgentsRoot | Out-Null
    "# Project Rules`n`nKeep this project-specific rule." | Set-Content -LiteralPath (Join-Path $mixedAgentsRoot "AGENTS.md") -NoNewline

    & $migrate -ProjectPath $mixedAgentsRoot -Apply | Out-Null
    Assert-ExitCode -Expected 0 -Message "mixed project AGENTS append fixture"
    $mixedAgents = Get-Content -Raw -LiteralPath (Join-Path $mixedAgentsRoot "AGENTS.md")
    Assert-True -Condition ($mixedAgents -match "Keep this project-specific rule" -and $mixedAgents -match "production-harness-v2:start") -Message "migration did not preserve mixed project AGENTS content"
} finally {
    if (Test-Path -LiteralPath $mixedAgentsRoot) {
        [System.IO.Directory]::Delete($mixedAgentsRoot, $true)
    }
}
Write-Output "[OK] mixed AGENTS migration fixture"

& $health -Strict | Out-Null
Assert-ExitCode -Expected 0 -Message "strict health-check fixture"
Write-Output "[OK] health-check fixture"
Write-Output "[OK] harness self-test complete"
