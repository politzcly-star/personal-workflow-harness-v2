param(
    [string]$ProjectName = "",
    [string]$ProjectPath = "",
    [string]$OutPath = "docs/project-profile.md",
    [switch]$InstallAgents,
    [switch]$Force
)

$ErrorActionPreference = "Stop"
$harnessRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$template = Join-Path $harnessRoot "templates/project-profile.md"
$agentsTemplate = Join-Path $harnessRoot "templates/project-agents.md"

if ($ProjectPath) {
    $projectRoot = if (Test-Path -LiteralPath $ProjectPath) {
        (Resolve-Path -LiteralPath $ProjectPath).Path
    } else {
        [System.IO.Path]::GetFullPath($ProjectPath)
    }
} elseif ([System.IO.Path]::IsPathRooted($OutPath)) {
    $targetParent = Split-Path -Parent ([System.IO.Path]::GetFullPath($OutPath))
    if ((Split-Path -Leaf $targetParent) -ieq "docs") {
        $projectRoot = Split-Path -Parent $targetParent
    } else {
        $projectRoot = $targetParent
    }
} else {
    $projectRoot = $harnessRoot
}

$target = if ([System.IO.Path]::IsPathRooted($OutPath)) {
    [System.IO.Path]::GetFullPath($OutPath)
} else {
    Join-Path $projectRoot $OutPath
}

if (-not (Test-Path -LiteralPath $template)) {
    throw "Missing template: templates/project-profile.md"
}

if ((Test-Path -LiteralPath $target) -and -not $Force) {
    Write-Output ("[OK] project profile already exists: {0}" -f $target)
    exit 0
}

$targetDir = Split-Path -Parent $target
if (-not (Test-Path -LiteralPath $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir | Out-Null
}

$content = Get-Content -Raw -LiteralPath $template
if ($ProjectName) {
    $content = $content -replace "Project Name:", ("Project Name: {0}" -f $ProjectName)
}
$content = $content -replace "Project Path:", ("Project Path: {0}" -f $projectRoot)
$content = $content -replace "Last Updated:", ("Last Updated: {0}" -f (Get-Date -Format "yyyy-MM-dd"))

Set-Content -LiteralPath $target -Value $content -Encoding UTF8
Write-Output ("[OK] project profile written: {0}" -f $target)

if ($InstallAgents) {
    if (-not (Test-Path -LiteralPath $agentsTemplate)) {
        throw "Missing template: templates/project-agents.md"
    }

    $agentsTarget = Join-Path $projectRoot "AGENTS.md"
    $agentsContent = Get-Content -Raw -LiteralPath $agentsTemplate
    $startMarker = "<!-- production-harness-v2:start -->"
    $endMarker = "<!-- production-harness-v2:end -->"
    $managedBlock = @"
$startMarker
$agentsContent
$endMarker
"@

    if (Test-Path -LiteralPath $agentsTarget) {
        $existing = Get-Content -Raw -LiteralPath $agentsTarget
        if ($existing -match [regex]::Escape($startMarker)) {
            if ($Force) {
                $updated = [regex]::Replace($existing, "(?s)<!-- production-harness-v2:start -->.*?<!-- production-harness-v2:end -->", [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $managedBlock })
                Set-Content -LiteralPath $agentsTarget -Value $updated -Encoding UTF8
                Write-Output ("[OK] project AGENTS.md harness block updated: {0}" -f $agentsTarget)
            } else {
                Write-Output ("[OK] project AGENTS.md already has harness block: {0}" -f $agentsTarget)
            }
        } else {
            Add-Content -LiteralPath $agentsTarget -Value ("`n`n" + $managedBlock) -Encoding UTF8
            Write-Output ("[OK] project AGENTS.md harness block appended: {0}" -f $agentsTarget)
        }
    } else {
        Set-Content -LiteralPath $agentsTarget -Value $managedBlock -Encoding UTF8
        Write-Output ("[OK] project AGENTS.md created: {0}" -f $agentsTarget)
    }
}

exit 0
