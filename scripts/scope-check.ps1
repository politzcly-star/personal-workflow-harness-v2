param(
    [string[]]$AllowedPath,
    [switch]$Strict
)

$ErrorActionPreference = "Stop"
$root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$warnings = @()

function Add-Warn {
    param([string]$Message)
    $script:warnings += $Message
    Write-Output ("[WARN] {0}" -f $Message)
}

Push-Location $root
try {
    $status = git status --short
    if ($LASTEXITCODE -ne 0) {
        Add-Warn "git status failed"
    }

    $changed = @()
    foreach ($line in $status) {
        if ($line.Length -ge 4) {
            $path = $line.Substring(3).Trim()
            if ($path.Contains(" -> ")) {
                $path = ($path -split " -> ")[-1]
            }
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

    $forbiddenPathPatterns = @(
        "^\.env($|\.)",
        "^\.vs/",
        "^\.claude/settings\.local\.json$",
        "^node_modules/",
        "^dist/",
        "^build/",
        "\.sqlite(-journal)?$",
        "\.pem$",
        "\.key$",
        "id_rsa",
        "id_ed25519"
    )

    foreach ($path in $changed) {
        $normalized = $path -replace "\\", "/"
        foreach ($pattern in $forbiddenPathPatterns) {
            if ($normalized -match $pattern) {
                Add-Warn ("changed path looks forbidden or runtime-local: {0}" -f $path)
            }
        }
        if ($AllowedPath -and -not ($AllowedPath | Where-Object { $normalized.StartsWith(($_ -replace "\\", "/")) })) {
            Add-Warn ("changed path outside allowed paths: {0}" -f $path)
        }
    }

    if (Get-Command rg -ErrorAction SilentlyContinue) {
        $secretPattern = "(?i)(BEGIN (RSA|OPENSSH|PRIVATE) KEY|sk-[A-Za-z0-9_-]{20,}|(api[_-]?key|secret|token|password|database_url)\s*[:=]\s*['""]?[A-Za-z0-9_./+=-]{16,})"
        $secretFiles = rg -l --hidden --glob "!.git/**" --glob "!.vs/**" --glob "!node_modules/**" --glob "!dist/**" --glob "!build/**" --glob "!*.sqlite" --glob "!*.sqlite-journal" $secretPattern 2>$null
        if ($secretFiles) {
            foreach ($file in $secretFiles) {
                Add-Warn ("secret-like keyword present in tracked scan scope: {0}" -f $file)
            }
        } else {
            Write-Output "[OK] no secret-like keywords found in safe scan scope"
        }
    } else {
        Add-Warn "rg not available; skipped content secret-keyword scan"
    }

    $runtimeDirs = @(".vs", "node_modules", "dist", "build", "tmp", "temp")
    foreach ($dir in $runtimeDirs) {
        if (Test-Path -LiteralPath (Join-Path $root $dir)) {
            Write-Output ("[INFO] runtime/local directory exists and should stay untracked: {0}" -f $dir)
        }
    }
}
finally {
    Pop-Location
}

if ($warnings.Count -gt 0) {
    if ($Strict) {
        exit 1
    }
    exit 2
}

Write-Output "[OK] scope-check complete"
exit 0
