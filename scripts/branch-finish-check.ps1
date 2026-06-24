param(
    [string]$TestCommand = "",
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

Push-Location $root
try {
    $inside = git rev-parse --is-inside-work-tree 2>$null
    if ($LASTEXITCODE -ne 0 -or $inside.Trim() -ne "true") {
        Write-Check "FAIL" "not inside a git worktree"
        exit 1
    }

    $branch = git branch --show-current
    $head = git rev-parse --short HEAD
    $gitDir = (Resolve-Path (git rev-parse --git-dir)).Path
    $gitCommon = (Resolve-Path (git rev-parse --git-common-dir)).Path
    $worktreeType = if ($gitDir -eq $gitCommon) { "normal" } elseif ($branch) { "named worktree" } else { "detached/external" }

    $branchLabel = if ($branch) { $branch } else { "(detached)" }
    Write-Check "INFO" ("branch: {0}" -f $branchLabel)
    Write-Check "INFO" ("head: {0}" -f $head)
    Write-Check "INFO" ("worktree: {0}" -f $worktreeType)

    $baseCandidates = @("main", "master")
    $baseBranch = ""
    foreach ($candidate in $baseCandidates) {
        git show-ref --verify --quiet ("refs/heads/{0}" -f $candidate)
        if ($LASTEXITCODE -eq 0) {
            $baseBranch = $candidate
            break
        }
        git show-ref --verify --quiet ("refs/remotes/origin/{0}" -f $candidate)
        if ($LASTEXITCODE -eq 0) {
            $baseBranch = "origin/$candidate"
            break
        }
    }
    if ($baseBranch) {
        Write-Check "INFO" ("base branch candidate: {0}" -f $baseBranch)
    } else {
        Write-Check "WARN" "base branch could not be inferred from main/master"
        if ($Strict) { $failed = $true }
    }

    $remotes = git remote -v
    if ($remotes) {
        $remoteSummary = ($remotes | Select-Object -First 4) -join "; "
        Write-Check "INFO" ("remotes: {0}" -f $remoteSummary)
        if ($remoteSummary -match "github\.com") {
            Write-Check "INFO" "GitHub remote detected; PR tooling may be appropriate if auth is configured"
        } else {
            Write-Check "INFO" "non-GitHub or unknown remote; do not assume gh pr create"
        }
    } else {
        Write-Check "WARN" "no git remotes configured"
    }

    $status = git status --short
    if ($status) {
        Write-Check "INFO" "changed files:"
        foreach ($line in $status) {
            Write-Output ("  {0}" -f $line)
        }
    } else {
        Write-Check "OK" "worktree clean"
    }

    & (Join-Path $root "scripts/scope-check.ps1")
    if ($LASTEXITCODE -ne 0) {
        if ($Strict) {
            $failed = $true
        } else {
            Write-Check "WARN" "scope-check reported warnings"
        }
    }

    if ($TestCommand) {
        Write-Check "INFO" ("running test command: {0}" -f $TestCommand)
        Invoke-Expression $TestCommand
        if ($LASTEXITCODE -ne 0) {
            Write-Check "FAIL" "test command failed; do not offer merge/PR as ready"
            $failed = $true
        } else {
            Write-Check "OK" "test command passed"
        }
    } else {
        Write-Check "WARN" "no test command supplied; cite prior verification or record not-verified reason before merge/PR"
        if ($Strict) { $failed = $true }
    }

    Write-Check "INFO" "branch_finish options: push/PR, keep, merge with approval, or discard with exact confirmation"
    Write-Check "INFO" "do not delete branch/worktree before chosen integration action succeeds"
}
finally {
    Pop-Location
}

if ($failed) {
    exit 1
}

Write-Check "OK" "branch-finish-check complete"
exit 0
