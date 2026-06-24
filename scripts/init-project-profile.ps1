param(
    [string]$ProjectName = "",
    [string]$OutPath = "docs/project-profile.md",
    [switch]$Force
)

$ErrorActionPreference = "Stop"
$root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$template = Join-Path $root "templates/project-profile.md"
$target = if ([System.IO.Path]::IsPathRooted($OutPath)) { $OutPath } else { Join-Path $root $OutPath }

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
$content = $content -replace "Project Path:", ("Project Path: {0}" -f $root)
$content = $content -replace "Last Updated:", ("Last Updated: {0}" -f (Get-Date -Format "yyyy-MM-dd"))

Set-Content -LiteralPath $target -Value $content -Encoding UTF8
Write-Output ("[OK] project profile written: {0}" -f $target)
exit 0
