param(
    [Parameter(Mandatory = $true)]
    [string]$Event
)

$ErrorActionPreference = "Stop"
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "../..")).Path
$raw = [Console]::In.ReadToEnd()
$payload = $null

if ($raw.Trim()) {
    try {
        $payload = $raw | ConvertFrom-Json -ErrorAction Stop
    } catch {
        $payload = $null
    }
}

function Write-HookJson {
    param([hashtable]$Object)
    $Object | ConvertTo-Json -Depth 10 -Compress
}

function Get-PayloadText {
    param($InputObject)
    if ($null -eq $InputObject) {
        return ""
    }
    try {
        return ($InputObject | ConvertTo-Json -Depth 12 -Compress)
    } catch {
        return [string]$InputObject
    }
}

function Add-Context {
    param(
        [string]$Level,
        [string]$Message,
        [string]$HookEvent = $Event
    )
    Write-HookJson @{
        hookSpecificOutput = @{
            hookEventName = $HookEvent
            additionalContext = ("[{0}] {1}" -f $Level, $Message)
        }
    }
}

function Block-PreTool {
    param([string]$Reason)
    Write-HookJson @{
        hookSpecificOutput = @{
            hookEventName = "PreToolUse"
            permissionDecision = "deny"
            permissionDecisionReason = ("[block] {0}" -f $Reason)
        }
    }
}

function Block-Stop {
    param([string]$Reason)
    Write-HookJson @{
        decision = "block"
        reason = ("[block] {0}" -f $Reason)
    }
}

function Get-ChangedFilesSummary {
    Push-Location $repoRoot
    try {
        $status = git status --short 2>$null
        if ($LASTEXITCODE -ne 0 -or -not $status) {
            return "No changed files detected by git status."
        }
        return (($status | Select-Object -First 40) -join "`n")
    } finally {
        Pop-Location
    }
}

function Has-ChangedFiles {
    Push-Location $repoRoot
    try {
        $status = git status --short 2>$null
        return [bool]$status
    } finally {
        Pop-Location
    }
}

switch ($Event) {
    "SessionStart" {
        $required = @(
            "README.md",
            "AGENTS.md",
            "docs/route-policy.md",
            "docs/parent-child-execution.md",
            "docs/developer-efficiency-mode.md",
            "docs/reporting-policy.md",
            "docs/context-compression-policy.md",
            "templates/project-profile.md"
        )
        $missing = @()
        foreach ($file in $required) {
            if (-not (Test-Path -LiteralPath (Join-Path $repoRoot $file))) {
                $missing += $file
            }
        }
        $status = if ($missing.Count -eq 0) { "all required harness files found" } else { "missing: " + ($missing -join ", ") }
        Add-Context "info" ("v2.2 production harness active. Classify S0-S4 and route first. S0/S1 stay light; bounded S2 may run in-parent; S3/S4 require child/reviewer or explicit authorization. Verify before completion. Status: {0}" -f $status) "SessionStart"
        break
    }
    "PreToolUse" {
        $text = Get-PayloadText $payload
        $lower = $text.ToLowerInvariant()

        if ($lower -match '(begin\s+(rsa|openssh|private)\s+key|private\s+key-----)') {
            Block-PreTool "tool call appears to expose private key material. Use redacted presence summaries instead."
            break
        }

        if ($lower -match '(get-content|type|cat|gc|select-string|sls|rg|grep|open|notepad|code|apply_patch|remove-item|copy-item|move-item|set-content|add-content|out-file)[^`r`n]{0,160}(\.env($|[^a-z0-9])|id_rsa|id_ed25519|\.pem|\.key)') {
            Block-PreTool "tool call appears to read, print, or modify a secret-like file. Do not inspect secret values; record only redacted presence."
            break
        }

        if ($lower -match '(sshpass|password\s*=|pass\s*=|token\s*=|secret\s*=|database_url\s*=|connectionstring\s*=)') {
            Block-PreTool "command appears to embed credentials. Configure SSH alias/agent or use redacted operator evidence instead."
            break
        }

        if ($lower -match '(rm\s+-rf|remove-item[^`n]*(recurse)[^`n]*(force)|git\s+reset\s+--hard|git\s+checkout\s+--\s|git\s+clean\s+-[a-z]*f|git\s+branch\s+(-d|--delete)|git\s+worktree\s+remove)') {
            Block-PreTool "destructive filesystem or git reset/checkout command needs explicit fresh Human approval and route justification."
            break
        }

        if ($lower -match '(git\s+push|git\s+merge|gh\s+pr\s+create)') {
            Add-Context "warn" "branch_finish reminder: before push/PR/merge, run scripts/branch-finish-check.ps1 or document equivalent checks, branch/worktree state, changed files, and residual risk." "PreToolUse"
            break
        }

        if ($lower -match '\b(drop|truncate)\b|\bdelete\s+from\b|\bupdate\s+[\w\.\[\]`"]+\s+set\b|\binsert\s+into\b|\bmigrate\b|\bprisma\s+migrate\b|\bsequelize\s+db:migrate\b') {
            if ($lower -match '(select\s+|explain\s+|preview|dry-run|dry run|plan)' -and $lower -notmatch '\b(drop|truncate|delete\s+from|update\s+[\w\.\[\]`"]+\s+set|insert\s+into)\b') {
                Add-Context "warn" "database_route preview detected. Keep it read-only, redact private data, and record row-count/impact evidence." "PreToolUse"
                break
            }
            Block-PreTool "database write/migration/destructive command. Use database_route checklist and redacted operator evidence unless explicitly approved."
            break
        }

        if ($lower -match '(ssh\s|scp\s|rsync\s)') {
            $remoteMutation = '(sudo\s+su|rm\s+-|mv\s+|chmod\s+|chown\s+|>\s*|tee\s+|systemctl\s+(restart|reload|start|stop|enable|disable)|service\s+\w+\s+(restart|reload|start|stop)|docker\s+compose\s+(up|down)|kubectl\s+(apply|delete|rollout|scale)|helm\s+(upgrade|install|delete)|npm\s+run\s+deploy|pnpm\s+deploy|migrate)'
            if ($lower -match 'harness:server-inspection' -and $lower -notmatch $remoteMutation) {
                Add-Context "info" "server_inspection read-only marker detected. Redact output and do not read .env/private keys/database URLs." "PreToolUse"
                break
            }
            Block-PreTool "remote server command needs server_inspection marker, no raw credentials, and read-only command shape unless the Human approved deployment/server mutation."
            break
        }

        if ($lower -match '(kubectl\s+(apply|delete|rollout|scale)|helm\s+(upgrade|install|delete)|systemctl\s+(restart|reload|start|stop|enable|disable)|service\s+\w+\s+(restart|reload|start|stop)|docker\s+compose\s+up|docker\s+compose\s+down|npm\s+run\s+deploy|pnpm\s+deploy|vercel\s+--prod|flyctl\s+deploy|railway\s+up)') {
            if ($lower -match '(dry-run|dry run|--dry-run|configtest|config-test|nginx\s+-t|plan)') {
                Add-Context "warn" "deployment_route dry-run/config-test detected. Do not mutate production; record rollback and smoke-check evidence." "PreToolUse"
                break
            }
            Block-PreTool "remote deploy/reload/restart or production-adjacent command. Use deployment_route checklist and operator boundary."
            break
        }

        if ($lower -match '(chrome user data|user-data-dir|cookies|login|logged-in|credentialed browser|default profile)') {
            Add-Context "warn" "browser/profile state mentioned. Use a dedicated profile or explicit Human approval; avoid personal logged-in state." "PreToolUse"
            break
        }

        Write-HookJson @{}
        break
    }
    "PostToolUse" {
        $changed = Get-ChangedFilesSummary
        $warnings = @()
        if ($changed -match '\.env|\.vs|\.sqlite|id_rsa|id_ed25519|\.pem|\.key') {
            $warnings += "Changed files include local/runtime/secret-like path. Run scripts/scope-check.ps1 before completion."
        }
        if ($changed -match 'node_modules|dist/|build/|tmp/|temp/') {
            $warnings += "Changed files include generated/runtime output. Confirm it is not committed."
        }
        $level = if ($warnings.Count -gt 0) { "warn" } else { "info" }
        $message = "Changed files snapshot:`n" + $changed
        if ($warnings.Count -gt 0) {
            $message += "`nWarnings:`n" + ($warnings -join "`n")
        }
        Add-Context $level $message "PostToolUse"
        break
    }
    "SubagentStart" {
        Add-Context "info" "Child executor context: use templates/child-task.md. Stay within allowed files, avoid secrets/.env/production/database/browser profiles, verify before reporting, and return changed files, checks, skipped checks, risks, and next step." "SubagentStart"
        break
    }
    "SubagentStop" {
        $text = Get-PayloadText $payload
        if ($text -notmatch '(?i)changed files' -or $text -notmatch '(?i)(checks run|verification)' -or $text -notmatch '(?i)(risk|residual)') {
            Block-Stop "Child report is missing changed files, verification/checks, or risk summary. Use templates/child-report.md."
            break
        }
        Write-HookJson @{}
        break
    }
    "PreCompact" {
        $text = Get-PayloadText $payload
        if ($text -match '(?i)(S3|S4|review_gated|deployment_route|database_route|security|permission|public API|production)' -and $text -notmatch '(?i)(handoff|next action|verification|residual risk)') {
            Block-Stop "High-risk compaction needs a handoff snapshot with route/S-level, changed files, verification, residual risk, forbidden actions, and next step."
            break
        }
        Add-Context "warn" "Before compaction, write or preserve templates/handoff.md state: goal, constraints, route/S-level, decisions, changed files, verification, open risk, key commands, server alias status, and next action." "PreCompact"
        break
    }
    "Stop" {
        $text = Get-PayloadText $payload
        if ($text -match '(?i)(discussion / no code changes|no code changes|S0)') {
            Write-HookJson @{}
            break
        }
        if (-not (Has-ChangedFiles) -and $text -match '(?i)(no files changed|clean worktree|read-only)') {
            Write-HookJson @{}
            break
        }
        if ($text -match '(?i)verification|checks run|commands/checks|not-verified|allowed reason|residual risk|verified') {
            Write-HookJson @{}
            break
        }
        Block-Stop "Final response appears to be missing verification evidence or an allowed not-verified reason. For S1+ add route/S-level, files changed, checks run, result, skipped checks, and residual risk."
        break
    }
    default {
        Add-Context "info" ("Unknown hook event received by v2.2 harness: {0}" -f $Event) $Event
        break
    }
}
