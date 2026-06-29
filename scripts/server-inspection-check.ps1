param(
    [Parameter(Mandatory = $true)]
    [string]$HostAlias,
    [string]$RemoteCommand = "",
    [switch]$Run,
    [switch]$Strict
)

$ErrorActionPreference = "Stop"
$failed = $false

function Write-Check {
    param(
        [string]$Status,
        [string]$Message
    )
    Write-Output ("[{0}] {1}" -f $Status, $Message)
}

function Test-UnsafeRemoteCommand {
    param([string]$Command)
    if (-not $Command) {
        return $false
    }
    $lower = $Command.ToLowerInvariant()
    return ($lower -match "(\.env|id_rsa|id_ed25519|private\s+key|database_url|cookie|token|password|secret|sshpass|sudo\s+su|rm\s+-|mv\s+|chmod\s+|chown\s+|systemctl\s+(restart|reload|start|stop|enable|disable)|service\s+\w+\s+(restart|reload|start|stop)|docker\s+compose\s+(up|down)|kubectl\s+(apply|delete|rollout|scale)|helm\s+(upgrade|install|delete)|npm\s+run\s+deploy|pnpm\s+deploy|migrate)")
}

if ($HostAlias -match "[:/@\\\s]" -or $HostAlias -match "(?i)(password|token|secret|key=)") {
    Write-Check "FAIL" "HostAlias must be a simple SSH config alias, not a raw user@host string or secret-bearing value"
    exit 1
}

if (Test-UnsafeRemoteCommand $RemoteCommand) {
    Write-Check "FAIL" "RemoteCommand appears unsafe or secret-seeking; use a read-only command and redacted evidence"
    exit 1
}

if (-not (Get-Command ssh -ErrorAction SilentlyContinue)) {
    Write-Check "FAIL" "ssh command not found"
    exit 1
}

Write-Check "INFO" ("host alias: {0}" -f $HostAlias)

$sshConfig = & ssh -G $HostAlias 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Check "WARN" "ssh -G could not resolve the alias; confirm SSH config or host availability"
    if ($Strict) { $failed = $true }
} else {
    $configMap = @{}
    foreach ($line in $sshConfig) {
        if ($line -match "^(hostname|user|port)\s+(.+)$") {
            $configMap[$matches[1]] = $matches[2]
        }
    }
    if ($configMap.ContainsKey("hostname")) { Write-Check "INFO" ("hostname configured: {0}" -f $configMap["hostname"]) }
    if ($configMap.ContainsKey("user")) { Write-Check "INFO" ("user configured: {0}" -f $configMap["user"]) }
    if ($configMap.ContainsKey("port")) { Write-Check "INFO" ("port configured: {0}" -f $configMap["port"]) }
    Write-Check "OK" "ssh alias resolved without printing identity files or secrets"
}

if ($Run) {
    if (-not $RemoteCommand) {
        Write-Check "FAIL" "-Run requires -RemoteCommand"
        exit 1
    }
    Write-Check "INFO" "running read-only command with BatchMode=yes"
    & ssh -o BatchMode=yes -- $HostAlias $RemoteCommand
    if ($LASTEXITCODE -ne 0) {
        Write-Check "FAIL" "remote read-only command failed or required interactive credentials"
        $failed = $true
    } else {
        Write-Check "OK" "remote read-only command completed"
    }
} else {
    Write-Check "INFO" "dry-run only; pass -Run with a read-only RemoteCommand to execute"
}

if ($failed) {
    exit 1
}

Write-Check "OK" "server-inspection-check complete"
exit 0
