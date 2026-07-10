param(
    [Parameter(Mandatory = $true)]
    [string]$ProjectPath,

    [switch]$Apply,
    [switch]$ReplaceConfig,
    [switch]$ReplaceHooks,
    [switch]$ReplaceLegacyAgents,
    [switch]$ArchiveLegacyHarness
)

$ErrorActionPreference = "Stop"
$harnessRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path

if (-not (Test-Path -LiteralPath $ProjectPath -PathType Container)) {
    throw ("Project path does not exist: {0}" -f $ProjectPath)
}

$projectRoot = (Resolve-Path -LiteralPath $ProjectPath).Path
if ($projectRoot -eq $harnessRoot) {
    throw "The harness repository is already activated; choose a different project path."
}

$projectPrefix = $projectRoot.TrimEnd([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar) + [IO.Path]::DirectorySeparatorChar
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backupRoot = Join-Path $projectRoot (".codex/legacy-harness-backup/{0}" -f $timestamp)
$blocked = @()
$plans = @()

function Get-SafeProjectPath {
    param([string]$RelativePath)
    $full = [IO.Path]::GetFullPath((Join-Path $projectRoot $RelativePath))
    if (-not $full.StartsWith($projectPrefix, [StringComparison]::OrdinalIgnoreCase)) {
        throw ("Path escapes project root: {0}" -f $RelativePath)
    }
    return $full
}

function Add-Plan {
    param([string]$Message)
    $script:plans += $Message
}

function Add-Blocker {
    param([string]$Message)
    $script:blocked += $Message
}

function Test-SameFile {
    param(
        [string]$Source,
        [string]$Target
    )
    if (-not (Test-Path -LiteralPath $Source -PathType Leaf) -or -not (Test-Path -LiteralPath $Target -PathType Leaf)) {
        return $false
    }
    return (Get-FileHash -LiteralPath $Source -Algorithm SHA256).Hash -eq (Get-FileHash -LiteralPath $Target -Algorithm SHA256).Hash
}

function Ensure-ParentDirectory {
    param([string]$Path)
    $parent = Split-Path -Parent $Path
    if (-not (Test-Path -LiteralPath $parent -PathType Container)) {
        New-Item -ItemType Directory -Path $parent | Out-Null
    }
}

function Ensure-LocalBackupExcluded {
    $excludePath = Join-Path $projectRoot ".git/info/exclude"
    if (-not (Test-Path -LiteralPath $excludePath -PathType Leaf)) {
        return
    }

    $pattern = ".codex/legacy-harness-backup/"
    $excludeText = Get-Content -Raw -LiteralPath $excludePath
    if ($excludeText -match '(?m)^\.codex/legacy-harness-backup/\s*$') {
        return
    }

    $prefix = if ($excludeText.Length -gt 0 -and -not $excludeText.EndsWith("`n")) { "`n" } else { "" }
    Add-Content -LiteralPath $excludePath -Value ($prefix + "# Local-only Harness migration backups`n" + $pattern) -Encoding UTF8
}

function Ensure-LocalRuntimeStateExcluded {
    $excludePath = Join-Path $projectRoot ".git/info/exclude"
    if (-not (Test-Path -LiteralPath $excludePath -PathType Leaf)) {
        $excludeParent = Split-Path -Parent $excludePath
        New-Item -ItemType Directory -Force -Path $excludeParent | Out-Null
        Set-Content -LiteralPath $excludePath -Value "" -Encoding UTF8 -NoNewline
    }
    $pattern = ".codex/harness-state/"
    $excludeText = Get-Content -Raw -LiteralPath $excludePath
    if ($excludeText -match '(?m)^\.codex/harness-state/\s*$') { return }
    $prefix = if ($excludeText.Length -gt 0 -and -not $excludeText.EndsWith("`n")) { "`n" } else { "" }
    Add-Content -LiteralPath $excludePath -Value ($prefix + "# Local-only autonomous Goal state`n" + $pattern) -Encoding UTF8
}

function Backup-ProjectFile {
    param([string]$RelativePath)
    $source = Get-SafeProjectPath $RelativePath
    if (-not (Test-Path -LiteralPath $source -PathType Leaf)) {
        return
    }
    $destination = [IO.Path]::GetFullPath((Join-Path $backupRoot $RelativePath))
    if (-not $destination.StartsWith(($backupRoot.TrimEnd('\') + '\'), [StringComparison]::OrdinalIgnoreCase)) {
        throw ("Backup path escapes backup root: {0}" -f $RelativePath)
    }
    Ensure-ParentDirectory $destination
    Copy-Item -LiteralPath $source -Destination $destination -Force
}

function Install-File {
    param(
        [string]$SourceRelativePath,
        [string]$TargetRelativePath,
        [bool]$CanReplace,
        [switch]$PlanOnly
    )

    $source = Join-Path $harnessRoot $SourceRelativePath
    $target = Get-SafeProjectPath $TargetRelativePath
    if (-not (Test-Path -LiteralPath $source -PathType Leaf)) {
        throw ("Harness source is missing: {0}" -f $SourceRelativePath)
    }

    if (Test-Path -LiteralPath $target -PathType Leaf) {
        if (Test-SameFile -Source $source -Target $target) {
            if ($PlanOnly) {
                Add-Plan ("keep current {0}" -f $TargetRelativePath)
            }
            return
        }
        if (-not $CanReplace) {
            if ($PlanOnly) {
                Add-Blocker ("existing {0} differs; review it and use the matching replace switch" -f $TargetRelativePath)
            }
            return
        }
        if ($PlanOnly) {
            Add-Plan ("backup and replace {0}" -f $TargetRelativePath)
        } else {
            Backup-ProjectFile $TargetRelativePath
            Copy-Item -LiteralPath $source -Destination $target -Force
        }
        return
    }

    if ($PlanOnly) {
        Add-Plan ("install {0}" -f $TargetRelativePath)
    } else {
        Ensure-ParentDirectory $target
        Copy-Item -LiteralPath $source -Destination $target
    }
}

function Get-ManagedAgentsBlock {
    $template = Get-Content -Raw -LiteralPath (Join-Path $harnessRoot "templates/project-agents.md")
    $match = [regex]::Match($template, '(?s)```text\s*(.*?)\s*```')
    $instructions = if ($match.Success) { $match.Groups[1].Value.Trim() } else { $template.Trim() }
    return @"
<!-- production-harness-v2:start -->
$instructions
<!-- production-harness-v2:end -->
"@
}

$agentsPath = Get-SafeProjectPath "AGENTS.md"
$managedBlock = Get-ManagedAgentsBlock
if (Test-Path -LiteralPath $agentsPath -PathType Leaf) {
    $agentsText = Get-Content -Raw -LiteralPath $agentsPath
    $hasManagedBlock = $agentsText -match '(?s)<!-- production-harness-v2:start -->.*?<!-- production-harness-v2:end -->'
    $hasLegacyWorkflowPreamble = $hasManagedBlock -and
        $agentsText -match '(?m)^## AI Workflow Operating System\s*$' -and
        $agentsText -match '(?m)^## Production Harness v2\.1\s*$' -and
        $agentsText -match '(?m)^# Project Conventions for .+\s*$'
    $looksLikeUnmanagedLegacy = -not $hasManagedBlock -and $agentsText -match '(?m)^# Production Harness (Starter )?Instructions\s*$'

    if ($hasLegacyWorkflowPreamble) {
        if (-not $ReplaceLegacyAgents) {
            Add-Blocker "AGENTS.md contains a recognized v2.1 workflow preamble; review it and rerun with -ReplaceLegacyAgents to preserve Project Conventions while removing the old workflow"
        } else {
            Add-Plan "backup AGENTS.md, remove the recognized v2.1 workflow preamble, preserve Project Conventions, and install the managed block"
        }
    } elseif ($hasManagedBlock) {
        Add-Plan "replace managed production-harness block in AGENTS.md"
    } elseif ($looksLikeUnmanagedLegacy) {
        if (-not $ReplaceLegacyAgents) {
            Add-Blocker "AGENTS.md looks like an unmarked legacy harness; review it and rerun with -ReplaceLegacyAgents"
        } else {
            Add-Plan "backup and replace unmarked legacy AGENTS.md"
        }
    } else {
        Add-Plan "append managed production-harness block to AGENTS.md"
    }
} else {
    Add-Plan "create AGENTS.md with managed production-harness block"
}

Install-File -SourceRelativePath ".codex/config.toml" -TargetRelativePath ".codex/config.toml" -CanReplace ([bool]$ReplaceConfig) -PlanOnly
Install-File -SourceRelativePath ".codex/agents/terra-worker.toml" -TargetRelativePath ".codex/agents/terra-worker.toml" -CanReplace $true -PlanOnly
Install-File -SourceRelativePath ".codex/agents/luna-verifier.toml" -TargetRelativePath ".codex/agents/luna-verifier.toml" -CanReplace $true -PlanOnly
Install-File -SourceRelativePath ".codex/hooks.json" -TargetRelativePath ".codex/hooks.json" -CanReplace ([bool]$ReplaceHooks) -PlanOnly
Install-File -SourceRelativePath ".codex/hooks/harness-hook.ps1" -TargetRelativePath ".codex/hooks/harness-hook.ps1" -CanReplace ([bool]$ReplaceHooks) -PlanOnly
Install-File -SourceRelativePath "scripts/goal-state.ps1" -TargetRelativePath "scripts/goal-state.ps1" -CanReplace $true -PlanOnly
Install-File -SourceRelativePath "templates/goal-contract.md" -TargetRelativePath "templates/goal-contract.md" -CanReplace $true -PlanOnly
Install-File -SourceRelativePath "templates/context-capsule.md" -TargetRelativePath "templates/context-capsule.md" -CanReplace $true -PlanOnly

$profilePath = Get-SafeProjectPath "docs/project-profile.md"
if (Test-Path -LiteralPath $profilePath -PathType Leaf) {
    Add-Plan "preserve existing docs/project-profile.md"
} else {
    Add-Plan "create docs/project-profile.md"
}

$legacyCandidates = @(
    "docs/route-policy.md",
    "docs/capability-policy.md",
    "docs/context-memory.md",
    "docs/context-compression-policy.md",
    "docs/parent-child-execution.md",
    "docs/reporting-policy.md",
    "docs/developer-efficiency-mode.md",
    "docs/verification-and-guardrails.md",
    "docs/hook-tuning.md",
    "docs/install-hooks-upgrade.md",
    "templates/task-brief.md",
    "templates/verification-report.md",
    "templates/child-task.md",
    "templates/child-report.md",
    "templates/handoff.md",
    "templates/project-agents.md",
    "templates/feature-plan.md",
    "scripts/health-check.ps1"
)

if ($ArchiveLegacyHarness) {
    foreach ($relative in $legacyCandidates) {
        if (Test-Path -LiteralPath (Get-SafeProjectPath $relative) -PathType Leaf) {
            Add-Plan ("archive legacy harness candidate {0}" -f $relative)
        }
    }
}

Write-Output ("[MODE] {0}" -f $(if ($Apply) { "APPLY" } else { "DRY RUN" }))
Write-Output ("[PROJECT] {0}" -f $projectRoot)
foreach ($plan in $plans) {
    Write-Output ("[PLAN] {0}" -f $plan)
}
foreach ($item in $blocked) {
    Write-Output ("[BLOCKED] {0}" -f $item)
}

if ($blocked.Count -gt 0) {
    Write-Output "[INFO] no project files were changed because preflight found blockers"
    exit 2
}

if (-not $Apply) {
    Write-Output "[OK] dry run complete; rerun with -Apply after reviewing the plan"
    exit 0
}

Ensure-LocalBackupExcluded
Ensure-LocalRuntimeStateExcluded

if (Test-Path -LiteralPath $agentsPath -PathType Leaf) {
    $agentsText = Get-Content -Raw -LiteralPath $agentsPath
    $hasManagedBlock = $agentsText -match '(?s)<!-- production-harness-v2:start -->.*?<!-- production-harness-v2:end -->'
    $hasLegacyWorkflowPreamble = $hasManagedBlock -and
        $agentsText -match '(?m)^## AI Workflow Operating System\s*$' -and
        $agentsText -match '(?m)^## Production Harness v2\.1\s*$' -and
        $agentsText -match '(?m)^# Project Conventions for .+\s*$'

    if ($hasLegacyWorkflowPreamble) {
        Backup-ProjectFile "AGENTS.md"
        $projectConventions = [regex]::Match($agentsText, '(?ms)^# Project Conventions for .+?(?=<!-- production-harness-v2:start -->)').Value.Trim()
        if (-not $projectConventions) {
            throw "Recognized legacy AGENTS.md did not contain preservable Project Conventions"
        }
        Set-Content -LiteralPath $agentsPath -Value ($projectConventions + "`n`n" + $managedBlock) -Encoding UTF8 -NoNewline
    } elseif ($hasManagedBlock) {
        $updated = [regex]::Replace($agentsText, '(?s)<!-- production-harness-v2:start -->.*?<!-- production-harness-v2:end -->', [Text.RegularExpressions.MatchEvaluator]{ param($m) $managedBlock })
        Set-Content -LiteralPath $agentsPath -Value $updated.TrimEnd() -Encoding UTF8 -NoNewline
    } elseif ($agentsText -match '(?m)^# Production Harness (Starter )?Instructions\s*$') {
        Backup-ProjectFile "AGENTS.md"
        Set-Content -LiteralPath $agentsPath -Value $managedBlock -Encoding UTF8 -NoNewline
    } else {
        Add-Content -LiteralPath $agentsPath -Value ("`n`n" + $managedBlock) -Encoding UTF8
    }
} else {
    Set-Content -LiteralPath $agentsPath -Value $managedBlock -Encoding UTF8 -NoNewline
}

Install-File -SourceRelativePath ".codex/config.toml" -TargetRelativePath ".codex/config.toml" -CanReplace ([bool]$ReplaceConfig)
Install-File -SourceRelativePath ".codex/agents/terra-worker.toml" -TargetRelativePath ".codex/agents/terra-worker.toml" -CanReplace $true
Install-File -SourceRelativePath ".codex/agents/luna-verifier.toml" -TargetRelativePath ".codex/agents/luna-verifier.toml" -CanReplace $true
Install-File -SourceRelativePath ".codex/hooks.json" -TargetRelativePath ".codex/hooks.json" -CanReplace ([bool]$ReplaceHooks)
Install-File -SourceRelativePath ".codex/hooks/harness-hook.ps1" -TargetRelativePath ".codex/hooks/harness-hook.ps1" -CanReplace ([bool]$ReplaceHooks)
Install-File -SourceRelativePath "scripts/goal-state.ps1" -TargetRelativePath "scripts/goal-state.ps1" -CanReplace $true
Install-File -SourceRelativePath "templates/goal-contract.md" -TargetRelativePath "templates/goal-contract.md" -CanReplace $true
Install-File -SourceRelativePath "templates/context-capsule.md" -TargetRelativePath "templates/context-capsule.md" -CanReplace $true

if (-not (Test-Path -LiteralPath $profilePath -PathType Leaf)) {
    & (Join-Path $harnessRoot "scripts/init-project-profile.ps1") -ProjectName (Split-Path -Leaf $projectRoot) -ProjectPath $projectRoot -OutPath "docs/project-profile.md" | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw "Project profile initialization failed"
    }
    Write-Output "[OK] created docs/project-profile.md"
} else {
    Write-Output "[OK] preserved existing docs/project-profile.md"
}

if ($ArchiveLegacyHarness) {
    foreach ($relative in $legacyCandidates) {
        $source = Get-SafeProjectPath $relative
        if (-not (Test-Path -LiteralPath $source -PathType Leaf)) {
            continue
        }
        $destination = [IO.Path]::GetFullPath((Join-Path $backupRoot $relative))
        if (-not $destination.StartsWith(($backupRoot.TrimEnd('\') + '\'), [StringComparison]::OrdinalIgnoreCase)) {
            throw ("Archive path escapes backup root: {0}" -f $relative)
        }
        Ensure-ParentDirectory $destination
        Move-Item -LiteralPath $source -Destination $destination
        Write-Output ("[OK] archived {0}" -f $relative)
    }
}

Write-Output "[OK] project harness migration applied"
Write-Output "[NEXT] inspect the project diff, trust the project in Codex, and run the project's own tests"
exit 0
