param(
    [switch]$Strict
)

$ErrorActionPreference = "Stop"
$root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$failed = $false

function Write-Check {
    param(
        [string]$Status,
        [string]$Message
    )
    Write-Output ("[{0}] {1}" -f $Status, $Message)
}

function Require-File {
    param([string]$RelativePath)
    $path = Join-Path $root $RelativePath
    if (Test-Path -LiteralPath $path -PathType Leaf) {
        Write-Check "OK" $RelativePath
    } else {
        Write-Check "FAIL" ("missing {0}" -f $RelativePath)
        $script:failed = $true
    }
}

Push-Location $root
try {
    $requiredFiles = @(
        "README.md",
        "AGENTS.md",
        "docs/model-routing-policy.md",
        "docs/autonomous-goal-workflow.md",
        "docs/route-policy.md",
        "docs/capability-policy.md",
        "docs/verification-and-guardrails.md",
        "docs/developer-efficiency-mode.md",
        "docs/reporting-policy.md",
        "docs/parent-child-execution.md",
        "docs/external-executor-workflow.md",
        "docs/install-hooks-upgrade.md",
        "docs/hook-tuning.md",
        "templates/task-brief.md",
        "templates/goal-contract.md",
        "templates/context-capsule.md",
        "templates/verification-report.md",
        "templates/project-agents.md",
        "templates/project-profile.md",
        ".codex/config.toml",
        ".codex/agents/terra-worker.toml",
        ".codex/agents/luna-verifier.toml",
        ".codex/hooks.json",
        ".codex/hooks/harness-hook.ps1",
        "scripts/harness-self-test.ps1",
        "scripts/health-check.ps1",
        "scripts/migrate-project-harness.ps1",
        "scripts/goal-state.ps1",
        "scripts/scope-check.ps1",
        "scripts/stop-check.ps1"
    )

    foreach ($file in $requiredFiles) {
        Require-File $file
    }

    try {
        Get-Content -Raw -LiteralPath (Join-Path $root ".codex/hooks.json") | ConvertFrom-Json | Out-Null
        Write-Check "OK" ".codex/hooks.json parses as JSON"
    } catch {
        Write-Check "FAIL" (".codex/hooks.json parse failed: {0}" -f $_.Exception.Message)
        $failed = $true
    }

    $configText = Get-Content -Raw -LiteralPath (Join-Path $root ".codex/config.toml")
    if ($configText -match '(?m)^model = "gpt-5\.6-terra"$' -and
        $configText -match '(?m)^model_reasoning_effort = "medium"$' -and
        $configText -match '(?m)^max_threads = 2$' -and
        $configText -match '(?m)^max_depth = 1$') {
        Write-Check "OK" ".codex/config.toml routing defaults"
    } else {
        Write-Check "FAIL" ".codex/config.toml routing defaults are incomplete"
        $failed = $true
    }

    foreach ($agentRelative in @(".codex/agents/terra-worker.toml", ".codex/agents/luna-verifier.toml")) {
        $agentText = Get-Content -Raw -LiteralPath (Join-Path $root $agentRelative)
        if ($agentText -match '(?m)^name = "[^"]+"$' -and
            $agentText -match '(?m)^description = "[^"]+"$' -and
            $agentText -match '(?m)^model = "[^"]+"$' -and
            $agentText -match '(?m)^model_reasoning_effort = "(medium|high)"$' -and
            $agentText -match '(?m)^developer_instructions = """$') {
            Write-Check "OK" ("custom agent shape {0}" -f $agentRelative)
        } else {
            Write-Check "FAIL" ("custom agent shape is incomplete: {0}" -f $agentRelative)
            $failed = $true
        }
    }

    $terraText = Get-Content -Raw -LiteralPath (Join-Path $root ".codex/agents/terra-worker.toml")
    $lunaText = Get-Content -Raw -LiteralPath (Join-Path $root ".codex/agents/luna-verifier.toml")
    if ($terraText -match '(?m)^model = "gpt-5\.6-terra"$' -and
        $terraText -match '(?m)^model_reasoning_effort = "high"$' -and
        $lunaText -match '(?m)^model = "gpt-5\.6-luna"$' -and
        $lunaText -match '(?m)^model_reasoning_effort = "medium"$' -and
        $lunaText -match '(?m)^sandbox_mode = "read-only"$') {
        Write-Check "OK" "verified 5.6 role model contracts"
    } else {
        Write-Check "FAIL" "verified 5.6 role model contracts are incomplete"
        $failed = $true
    }

    $scriptFiles = @(
        Get-ChildItem -LiteralPath (Join-Path $root "scripts") -Filter "*.ps1" -File
        Get-ChildItem -LiteralPath (Join-Path $root ".codex/hooks") -Filter "*.ps1" -File
    )
    foreach ($script in $scriptFiles) {
        $tokens = $null
        $errors = $null
        [System.Management.Automation.Language.Parser]::ParseFile($script.FullName, [ref]$tokens, [ref]$errors) | Out-Null
        if ($errors.Count -eq 0) {
            Write-Check "OK" ("PowerShell syntax {0}" -f $script.FullName.Substring($root.Length + 1))
        } else {
            Write-Check "FAIL" ("PowerShell syntax {0}: {1}" -f $script.Name, $errors[0].Message)
            $failed = $true
        }
    }

    & (Join-Path $root "scripts/scope-check.ps1")
    if ($LASTEXITCODE -ne 0) {
        Write-Check "FAIL" "scope-check found forbidden changed paths"
        $failed = $true
    }

    & (Join-Path $root "scripts/stop-check.ps1")
    if ($LASTEXITCODE -ne 0) {
        Write-Check "FAIL" "stop-check failed"
        $failed = $true
    }

    & (Join-Path $root "scripts/check-codegraph.ps1") -Quiet
    if ($LASTEXITCODE -ne 0) {
        Write-Check "INFO" "CodeGraph unavailable; documented fallback remains valid"
    }
} finally {
    Pop-Location
}

if ($failed) {
    exit 1
}

Write-Check "OK" "health-check complete"
exit 0
