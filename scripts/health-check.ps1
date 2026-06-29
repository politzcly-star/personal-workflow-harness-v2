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

function Require-Directory {
    param([string]$RelativePath)
    $path = Join-Path $root $RelativePath
    if (Test-Path -LiteralPath $path -PathType Container) {
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
        "docs/route-policy.md",
        "docs/capability-policy.md",
        "docs/verification-and-guardrails.md",
        "docs/install-hooks-upgrade.md",
        "docs/context-memory.md",
        "docs/parent-child-execution.md",
        "docs/ael-capability-recovery-map.md",
        "docs/production-pilot.md",
        "templates/task-brief.md",
        "templates/verification-report.md",
        "templates/risk-review.md",
        "templates/handoff.md",
        "templates/child-task.md",
        "templates/child-report.md",
        "templates/project-profile.md",
        "templates/feature-plan.md",
        "templates/deployment-checklist.md",
        "templates/database-checklist.md",
        "templates/branch-finish.md",
        "templates/server-inspection.md",
        ".codex/hooks.json",
        ".codex/hooks/harness-hook.ps1",
        "scripts/health-check.ps1",
        "scripts/scope-check.ps1",
        "scripts/stop-check.ps1",
        "scripts/init-project-profile.ps1",
        "scripts/check-codegraph.ps1",
        "scripts/branch-finish-check.ps1",
        "scripts/server-inspection-check.ps1"
    )

    foreach ($file in $requiredFiles) {
        Require-File $file
    }

    Require-Directory "docs"
    Require-Directory "templates"
    Require-Directory "scripts"
    Require-Directory ".codex/hooks"

    try {
        Get-Content -Raw -LiteralPath (Join-Path $root ".codex/hooks.json") | ConvertFrom-Json | Out-Null
        Write-Check "OK" ".codex/hooks.json parses as JSON"
    } catch {
        Write-Check "FAIL" (".codex/hooks.json parse failed: {0}" -f $_.Exception.Message)
        $failed = $true
    }

    $scriptFiles = Get-ChildItem -LiteralPath (Join-Path $root "scripts") -Filter "*.ps1" -File
    $scriptFiles += Get-ChildItem -LiteralPath (Join-Path $root ".codex/hooks") -Filter "*.ps1" -File
    foreach ($script in $scriptFiles) {
        try {
            $tokens = $null
            $errors = $null
            [System.Management.Automation.Language.Parser]::ParseFile($script.FullName, [ref]$tokens, [ref]$errors) | Out-Null
            if ($errors.Count -eq 0) {
                Write-Check "OK" ("PowerShell syntax {0}" -f $script.FullName.Substring($root.Length + 1))
            } else {
                Write-Check "FAIL" ("PowerShell syntax {0}: {1}" -f $script.FullName.Substring($root.Length + 1), $errors[0].Message)
                $failed = $true
            }
        } catch {
            Write-Check "FAIL" ("PowerShell syntax check failed for {0}: {1}" -f $script.Name, $_.Exception.Message)
            $failed = $true
        }
    }

    & (Join-Path $root "scripts/scope-check.ps1")
    if ($LASTEXITCODE -ne 0) {
        if ($Strict) {
            $failed = $true
        } else {
            Write-Check "WARN" "scope-check reported warnings; rerun with -Strict to fail health-check on warnings"
        }
    }

    & (Join-Path $root "scripts/stop-check.ps1")
    if ($LASTEXITCODE -ne 0) {
        if ($Strict) {
            $failed = $true
        } else {
            Write-Check "WARN" "stop-check reported warnings; rerun with -Strict to fail health-check on warnings"
        }
    }

    & (Join-Path $root "scripts/check-codegraph.ps1")
    if ($LASTEXITCODE -ne 0) {
        Write-Check "WARN" "CodeGraph unavailable; fallback is acceptable"
    }
}
finally {
    Pop-Location
}

if ($failed) {
    exit 1
}

Write-Check "OK" "health-check complete"
exit 0
