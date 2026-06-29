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

function Additional-Context {
    param(
        [string]$Message,
        [string]$HookEvent = $Event
    )
    Write-HookJson @{
        hookSpecificOutput = @{
            hookEventName = $HookEvent
            additionalContext = $Message
        }
    }
}

function Block-PreTool {
    param([string]$Reason)
    Write-HookJson @{
        hookSpecificOutput = @{
            hookEventName = "PreToolUse"
            permissionDecision = "deny"
            permissionDecisionReason = $Reason
        }
    }
}

function Block-Stop {
    param([string]$Reason)
    Write-HookJson @{
        decision = "block"
        reason = $Reason
    }
}

function Get-ChangedFilesSummary {
    Push-Location $repoRoot
    try {
        $status = git status --short 2>$null
        if ($LASTEXITCODE -ne 0 -or -not $status) {
            return "No changed files detected by git status."
        }
        return (($status | Select-Object -First 30) -join "`n")
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
            "docs/capability-policy.md",
            "docs/verification-and-guardrails.md",
            "templates/project-profile.md"
        )
        $missing = @()
        foreach ($file in $required) {
            if (-not (Test-Path -LiteralPath (Join-Path $repoRoot $file))) {
                $missing += $file
            }
        }
        $status = if ($missing.Count -eq 0) { "all required harness files found" } else { "missing: " + ($missing -join ", ") }
        Additional-Context ("v2.1 production harness active. Read order: README.md > AGENTS.md > project profile > route/capability/verification docs. Route first, use parent-router + child-executor for non-trivial work, verify before completion, and use branch_finish before push/PR/merge/cleanup. Status: {0}" -f $status) "SessionStart"
        break
    }
    "PreToolUse" {
        $text = Get-PayloadText $payload
        $lower = $text.ToLowerInvariant()

        if ($lower -match "(\.env($|[^a-z0-9])|\.env\.|id_rsa|id_ed25519|private\s+key|begin\s+(rsa|openssh|private)\s+key)") {
            Block-PreTool "Blocked by v2.1 harness: tool call appears to read, print, or modify secrets/private key material. Use redacted presence summaries instead."
            break
        }

        if ($lower -match "(sshpass|password\s*=|pass\s*=|token\s*=|secret\s*=)") {
            Block-PreTool "Blocked by v2.1 harness: command appears to embed credentials. Configure SSH alias/agent or operator session instead."
            break
        }

        if ($lower -match "(rm\s+-rf|remove-item[^`n]*(recurse)[^`n]*(force)|git\s+reset\s+--hard|git\s+checkout\s+--\s|git\s+clean\s+-[a-z]*f|git\s+branch\s+(-d|--delete)|git\s+worktree\s+remove)") {
            Block-PreTool "Blocked by v2.1 harness: destructive filesystem or git reset/checkout command needs explicit fresh Human approval and route justification."
            break
        }

        if ($lower -match "(git\s+push|git\s+merge|gh\s+pr\s+create|git\s+checkout\s+(main|master)|git\s+switch\s+(main|master))") {
            Additional-Context "v2.1 branch_finish reminder: before push/PR/merge, run scripts/branch-finish-check.ps1 or document equivalent checks, changed files, branch/worktree state, and residual risk." "PreToolUse"
            break
        }

        if ($lower -match "\b(drop|truncate)\b|\bdelete\s+from\b|\bupdate\s+[\w\.\[\]`"]+\s+set\b|\bmigrate\b|\bprisma\s+migrate\b|\bsequelize\s+db:migrate\b") {
            Block-PreTool "Blocked by v2.1 harness: database write/migration/destructive command. Use database_route checklist and redacted operator evidence unless explicitly approved."
            break
        }

        if ($lower -match "(ssh\s|scp\s|rsync\s)") {
            if ($lower -match "harness:server-inspection" -and $lower -notmatch "(sudo\s+su|rm\s+-|mv\s+|chmod\s+|chown\s+|>\s*|tee\s+|systemctl\s+(restart|reload|start|stop|enable|disable)|service\s+\w+\s+(restart|reload|start|stop)|docker\s+compose\s+(up|down)|kubectl\s+(apply|delete|rollout|scale)|helm\s+(upgrade|install|delete)|npm\s+run\s+deploy|pnpm\s+deploy|migrate)") {
                Additional-Context "v2.1 server_inspection reminder: SSH/scp/rsync access is only for approved read-only inspection through preconfigured no-secret access. Redact output and do not read .env/private keys/database URLs." "PreToolUse"
                break
            }
            Block-PreTool "Blocked by v2.1 harness: remote server command needs server_inspection marker, no raw credentials, and read-only command shape."
            break
        }

        if ($lower -match "(kubectl\s+(apply|delete|rollout|scale)|helm\s+(upgrade|install|delete)|systemctl\s+(restart|reload|start|stop|enable|disable)|service\s+\w+\s+(restart|reload|start|stop)|docker\s+compose\s+up|docker\s+compose\s+down|npm\s+run\s+deploy|pnpm\s+deploy|vercel\s+--prod|flyctl\s+deploy|railway\s+up)") {
            Block-PreTool "Blocked by v2.1 harness: remote deploy/reload/restart or production-adjacent command. Use deployment_route checklist and operator boundary."
            break
        }

        if ($lower -match "(chrome user data|user-data-dir|cookies|login|logged-in|credentialed browser|default profile)") {
            Additional-Context "v2.1 harness warning: browser/profile state mentioned. Use a dedicated profile or explicit Human approval; avoid personal logged-in state." "PreToolUse"
            break
        }

        Write-HookJson @{}
        break
    }
    "PostToolUse" {
        $changed = Get-ChangedFilesSummary
        $warnings = @()
        if ($changed -match "\.env|\.vs|\.sqlite|id_rsa|id_ed25519|\.pem|\.key") {
            $warnings += "Changed files include local/runtime/secret-like path. Run scripts/scope-check.ps1 before completion."
        }
        if ($changed -match "node_modules|dist/|build/|tmp/|temp/") {
            $warnings += "Changed files include generated/runtime output. Confirm it is not committed."
        }
        $message = "Changed files snapshot:`n" + $changed
        if ($warnings.Count -gt 0) {
            $message += "`nWarnings:`n" + ($warnings -join "`n")
        }
        Additional-Context $message "PostToolUse"
        break
    }
    "SubagentStart" {
        Additional-Context "Child executor context: use templates/child-task.md. Stay within allowed files, do not touch secrets/.env/production/database/browser profiles, verify before reporting, and return changed files, checks, skipped checks, risks, and next step." "SubagentStart"
        break
    }
    "SubagentStop" {
        $text = Get-PayloadText $payload
        if ($text -notmatch "(?i)changed files" -or $text -notmatch "(?i)(checks run|verification)" -or $text -notmatch "(?i)(risk|residual)") {
            Block-Stop "Child report is missing changed files, verification/checks, or risk summary. Use templates/child-report.md."
            break
        }
        Write-HookJson @{}
        break
    }
    "PreCompact" {
        Additional-Context "Before compaction, write a handoff snapshot with templates/handoff.md: route, layer, parent/child state, changed files, verification evidence, open issues, risk state, and next action." "PreCompact"
        break
    }
    "Stop" {
        $text = Get-PayloadText $payload
        if ($text -match "(?i)verification|checks run|commands/checks|not-verified|allowed reason|residual risk") {
            Write-HookJson @{}
            break
        }
        Block-Stop "Final response appears to be missing verification evidence or an allowed not-verified reason. Add route, files changed, checks run, result, skipped checks, and residual risk."
        break
    }
    default {
        Additional-Context ("Unknown hook event received by v2.1 harness: {0}" -f $Event) $Event
        break
    }
}
