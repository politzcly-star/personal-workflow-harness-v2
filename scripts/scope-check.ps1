param(
    [string[]]$AllowedPath,
    [string[]]$ChangedPath,
    [string]$BaselineManifest,
    [switch]$CaptureBaseline,
    [switch]$RequireContentBaseline,
    [switch]$Strict
)

$ErrorActionPreference = "Stop"
$root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$violations = @()
$baselineHashes = @{}
$legacyBaselinePaths = @()

function Normalize-Path {
    param([string]$Path)
    $normalized = ($Path -replace "\\", "/").Trim()
    while ($normalized.StartsWith("./")) { $normalized = $normalized.Substring(2) }
    return $normalized
}

function Get-ChangedPaths {
    if ($ChangedPath) { return @($ChangedPath | ForEach-Object { Normalize-Path $_ }) }
    $status = git status --short --untracked-files=all
    if ($LASTEXITCODE -ne 0) { Add-Violation "git status failed"; return @() }
    $paths = @()
    foreach ($line in $status) {
        if ($line.Length -lt 4) { continue }
        $path = $line.Substring(3).Trim()
        if ($path.Contains(" -> ")) { $path = ($path -split " -> ")[-1] }
        $paths += Normalize-Path $path
    }
    return @($paths)
}

function Get-ContentHashOrNull([string]$Path) {
    $full = Join-Path $root $Path
    if (-not (Test-Path -LiteralPath $full -PathType Leaf)) { return $null }
    return (Get-FileHash -LiteralPath $full -Algorithm SHA256).Hash.ToLowerInvariant()
}

if ($BaselineManifest) {
    $manifest = $null
    $manifestPath = $null
    try {
        $manifestPath = if ([IO.Path]::IsPathRooted($BaselineManifest)) { $BaselineManifest } else { Join-Path $PSScriptRoot "..\\$BaselineManifest" }
        if ($CaptureBaseline) {
            $snapshot = [ordered]@{ schema_version = 2; captured_utc = (Get-Date).ToUniversalTime().ToString('o'); files = [ordered]@{} }
            foreach ($path in (Get-ChangedPaths)) { $snapshot.files[(Normalize-Path $path)] = Get-ContentHashOrNull $path }
            $parent = Split-Path -Parent $manifestPath; if (-not (Test-Path -LiteralPath $parent)) { New-Item -ItemType Directory -Force -Path $parent | Out-Null }
            $snapshot | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $manifestPath -Encoding UTF8 -NoNewline
            Write-Output ("[OK] captured content baseline: {0}" -f $manifestPath)
            exit 0
        }
        $manifest = Get-Content -Raw -LiteralPath $manifestPath | ConvertFrom-Json -ErrorAction Stop
    } catch {
        Write-Output "[FAIL] baseline manifest could not be read: $BaselineManifest"
        exit 1
    }
    if ($manifest.schema_version -eq 2 -and $null -ne $manifest.files) {
        foreach ($property in $manifest.files.PSObject.Properties) { $baselineHashes[(Normalize-Path $property.Name)] = [string]$property.Value }
    } else {
        $legacyBaselinePaths = @($manifest.inherited_paths | ForEach-Object { Normalize-Path $_.ToString() })
        Write-Output "[WARN] path-only legacy baseline cannot prove edits inside inherited files; it is inventory-only, not a module-delta proof."
        if ($RequireContentBaseline) { Write-Output "[FAIL] content-hash baseline is required but unavailable"; exit 1 }
    }
}

function Add-Violation {
    param([string]$Message)
    $script:violations += $Message
    Write-Output ("[FAIL] {0}" -f $Message)
}

function Test-AllowedPath {
    param(
        [string]$Path,
        [string[]]$Allowed
    )

    if (-not $Allowed -or $Allowed.Count -eq 0) {
        return $true
    }

    $normalizedPath = Normalize-Path $Path
    foreach ($item in $Allowed) {
        $normalizedAllowed = Normalize-Path $item
        if ($normalizedAllowed.EndsWith("/")) {
            if ($normalizedPath.StartsWith($normalizedAllowed)) {
                return $true
            }
            continue
        }

        if ($normalizedPath -eq $normalizedAllowed) {
            return $true
        }

        if ($normalizedPath.EndsWith("/") -and $normalizedAllowed.StartsWith($normalizedPath)) {
            return $true
        }
    }

    return $false
}

Push-Location $root
try {
    $changed = @()
    if ($ChangedPath) {
        $changed = @($ChangedPath)
    } else {
        foreach ($path in (Get-ChangedPaths)) {
            if ($baselineHashes.ContainsKey($path) -and (Get-ContentHashOrNull $path) -eq $baselineHashes[$path]) { Write-Output ("[INFO] unchanged content baseline path excluded: {0}" -f $path); continue }
            if ($legacyBaselinePaths -contains $path) { Write-Output ("[INFO] legacy inherited inventory path excluded without content-delta proof: {0}" -f $path); continue }
            $changed += $path
        }
    }

    if ($changed.Count -eq 0) {
        Write-Output "[OK] no changed files"
    } else {
        Write-Output "[INFO] changed files:"
        foreach ($path in $changed) {
            Write-Output ("  {0}" -f $path)
        }
    }

    $forbidden = @(
        "^\.env($|\.)",
        "^\.vs/",
        "^node_modules/",
        "^dist/",
        "^build/",
        "^tmp/",
        "^temp/",
        "\.sqlite(-journal)?$",
        "\.pem$",
        "\.key$",
        "(^|/)id_rsa$",
        "(^|/)id_ed25519$"
    )

    foreach ($path in $changed) {
        $normalized = Normalize-Path $path
        foreach ($pattern in $forbidden) {
            if ($normalized -match $pattern) {
                Add-Violation ("changed path is forbidden or runtime-local: {0}" -f $path)
            }
        }

        if (-not (Test-AllowedPath -Path $path -Allowed $AllowedPath)) {
            Add-Violation ("changed path is outside the exact allowlist: {0}" -f $path)
        }
    }
} finally {
    Pop-Location
}

if ($violations.Count -gt 0) {
    exit 1
}

Write-Output "[OK] scope-check complete"
exit 0
