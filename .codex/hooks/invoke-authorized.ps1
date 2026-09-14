[CmdletBinding()]
param([Parameter(Mandatory=$true)][string]$RequestPath, [switch]$Execute)

# A transport for an externally signed exact command, NOT an approval issuer.
# Default is validation only. Never load/generate a trust root from repository files.
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
. (Join-Path $PSScriptRoot 'authorize-command.ps1')
try {
    $file = Get-Item -LiteralPath $RequestPath -ErrorAction Stop
    if ($file.PSIsContainer -or $file.Length -gt 96KB -or ($file.Attributes -band [IO.FileAttributes]::ReparsePoint)) { throw 'invalid request file' }
    $request = Get-Content -Raw -Encoding UTF8 -LiteralPath $file.FullName | ConvertFrom-Json -ErrorAction Stop
    if ($request -is [array] -or $request -is [string]) { throw 'request must be an object' }
    $command = [string]$request.command
    $cwd = [string]$request.cwd
    if (-not $command.Trim() -or -not [IO.Path]::IsPathRooted($cwd) -or -not (Test-Path -LiteralPath $cwd -PathType Container)) { throw 'command and absolute existing cwd required' }
    if (-not (Test-HarnessAuthorization -Envelope $request.harness_authorization -Command $command -ProjectRoot $root -Cwd $cwd -Target $request.harness_target -Version $request.harness_version)) { throw 'external exact-command authorization is missing, expired or mismatched' }
    # Apply the same secret/scope checks to the INNER command. A signed envelope
    # does not bypass the frozen Goal boundary or the secret safeguards.
    $payload = @{tool_name='exec_command'; tool_input=@{cmd=$command; cwd=$cwd; harness_authorization=$request.harness_authorization; harness_target=$request.harness_target; harness_version=$request.harness_version}} | ConvertTo-Json -Depth 12 -Compress
    $decision = (& (Join-Path $PSScriptRoot 'harness-hook.ps1') -Event PreToolUse -HookInput $payload) | ConvertFrom-Json -ErrorAction Stop
    if ($decision.hookSpecificOutput.permissionDecision -eq 'deny') { throw 'inner command was rejected by the scope/secret/authority checker' }
    if (-not $Execute) { Write-Output '[OK] external grant and inner command validated; nothing executed'; exit 0 }
    # Revalidate immediately before execution; the signed command must pin any
    # mutable runner/artifact itself. Grant issuer owns replay and target locks.
    if (-not (Test-HarnessAuthorization -Envelope $request.harness_authorization -Command $command -ProjectRoot $root -Cwd $cwd -Target $request.harness_target -Version $request.harness_version)) { throw 'authorization expired before execution' }
    $processCwd = [Environment]::CurrentDirectory
    Push-Location -LiteralPath $cwd
    try {
        [Environment]::CurrentDirectory = $cwd
        $global:LASTEXITCODE = 0
        & ([ScriptBlock]::Create($command))
        if (-not $?) { throw 'authorized command failed' }
        $code = $LASTEXITCODE
    } finally { [Environment]::CurrentDirectory = $processCwd; Pop-Location }
    exit $code
} catch {
    # Do not echo the request, command, grant contents or exception data.
    Write-Output '[FAIL] authorized runner rejected or failed the request; inspect redacted authority/scope/exit evidence'
    exit 1
}
