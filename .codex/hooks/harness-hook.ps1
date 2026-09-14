param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("SessionStart", "PreToolUse", "PreCompact", "PostCompact")]
    [string]$Event,
    [Parameter(ValueFromPipeline = $true)] [string]$HookInput
)

$ErrorActionPreference = "Stop"
$root = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
. (Join-Path $PSScriptRoot 'authorize-command.ps1')
. (Join-Path $PSScriptRoot 'validate-report.ps1')
$raw = if ($HookInput) { $HookInput } else { [Console]::In.ReadToEnd() }
$payload = $null; $invalidInput = $false
if ($raw.Trim()) { try { $payload = $raw | ConvertFrom-Json -ErrorAction Stop } catch { $invalidInput = $true } }

function Write-HookJson([hashtable]$Object) { $Object | ConvertTo-Json -Depth 8 -Compress }
function Get-PropertyValue($Object, [string[]]$Names) { if ($null -eq $Object) { return $null }; foreach ($name in $Names) { $p = $Object.PSObject.Properties[$name]; if ($null -ne $p -and $null -ne $p.Value) { return $p.Value } }; $null }
function Deny([string]$Reason) { Write-HookJson @{ hookSpecificOutput = @{ hookEventName = "PreToolUse"; permissionDecision = "deny"; permissionDecisionReason = "[block] $Reason" } } }
function Add-Context([string]$Message) { Write-HookJson @{ hookSpecificOutput = @{ hookEventName = "SessionStart"; additionalContext = "[info] $Message" } } }
function Test-SecretLike([string]$Text) {
    # Placeholder/schema names are not credentials. This is a heuristic, not a secret scanner.
    if ($Text -match '(?i)(-----BEGIN (?:RSA |OPENSSH |EC )?PRIVATE KEY-----|authorization\s*:\s*bearer\s+(?!\$|<|REDACTED|PLACEHOLDER)[a-z0-9._~-]{8,})') { return $true }
    foreach ($m in [regex]::Matches($Text, '(?i)\b(?:api[_-]?key|secret|token|password|database_url|connectionstring)\s*[:=]\s*["'']?([^\s"'',;]+)')) {
        $v = $m.Groups[1].Value
        if ($v -match '^(?:\$|<|\{|\[|process\.env\.|os\.environ|env:)' -or $v -match '^(?i:REDACTED|PLACEHOLDER|EXAMPLE|DUMMY|TEST|STRING|NONE|NULL|FALSE|TRUE)(?:$|[_-])') { continue }
        if ($v.Length -ge 8) { return $true }
    }
    return $false
}
function Get-ActiveGoal {
    $statePath = Join-Path $root ".codex/harness-state/active-goal.json"
    if (-not (Test-Path -LiteralPath $statePath -PathType Leaf)) { return $null }
    try {
        $state = Get-Content -Raw -LiteralPath $statePath | ConvertFrom-Json -ErrorAction Stop
        if ($state.Status -ne 'ACTIVE' -or -not $state.ContractPath -or -not $state.ContractHash) { return $null }
        if ($null -eq $state.ContextEpoch -or [string]$state.ContextEpoch -notmatch '^\d+$') { return $null }
        if ($state.GoalId -notmatch '^[A-Za-z0-9][A-Za-z0-9_-]{0,79}$') { return $null }
        $contract = [IO.Path]::GetFullPath((Join-Path $root $state.ContractPath))
        if (-not $contract.StartsWith($root.TrimEnd('\') + '\', [StringComparison]::OrdinalIgnoreCase)) { return $null }
        $capsule = Join-Path (Split-Path $statePath -Parent) "capsule-$($state.GoalId).md"
        if (-not (Test-Path -LiteralPath $contract -PathType Leaf)) { return $null }
        if ((Get-FileHash -LiteralPath $contract -Algorithm SHA256).Hash.ToLowerInvariant() -ne [string]$state.ContractHash) { return $null }
        # Progress is advisory. Bad capsule data is never injected, but cannot
        # revoke an otherwise intact frozen scope. Contract failure still blocks.
        $capsuleSafe = $false
        try { if ((Test-Path -LiteralPath $capsule -PathType Leaf) -and (Get-Item -LiteralPath $capsule).Length -le 16KB) {
            $capsuleText = Get-Content -Raw -LiteralPath $capsule
            $epoch = [regex]::Match($capsuleText, '(?im)^Context epoch:\s*(\d+)\s*$')
            $capsuleSafe = $epoch.Success -and [string]$epoch.Groups[1].Value -eq [string]$state.ContextEpoch -and
                -not (Test-SecretLike $capsuleText) -and (Get-FileHash -LiteralPath $capsule -Algorithm SHA256).Hash.ToLowerInvariant() -eq [string]$state.CapsuleHash
        } } catch { $capsuleSafe = $false }
        $contractText = Get-Content -Raw -LiteralPath $contract
        $match = [regex]::Match($contractText, '(?s)<!-- harness:allowed-paths:start -->\s*(.*?)\s*<!-- harness:allowed-paths:end -->')
        $allowed = if ($match.Success) { @($match.Groups[1].Value -split "`r?`n" | ForEach-Object { ($_.Trim() -replace '^-\s*','') } | Where-Object { $_ }) } else { @() }
        return @{ State=$state; Contract=$contract; Allowed=$allowed; CapsuleSafe=$capsuleSafe }
    } catch { return $null }
}
function Test-AllowedPath([string]$Path, [string[]]$Allowed) {
    if (-not $Path -or -not $Allowed -or $Allowed.Count -eq 0) { return $false }
    try {
        $full = if ([IO.Path]::IsPathRooted($Path)) { [IO.Path]::GetFullPath($Path) } else { [IO.Path]::GetFullPath((Join-Path $root $Path)) }
        if (-not $full.StartsWith($root.TrimEnd('\') + '\', [StringComparison]::OrdinalIgnoreCase)) { return $false }
        $p = $full.Substring($root.Length + 1).Replace('\','/')
    } catch { return $false }
    foreach ($entry in $Allowed) { $a = ($entry -replace '\\','/').Trim(); if ($a -match '(^|/)\.\.(/|$)' -or [IO.Path]::IsPathRooted($a)) { continue }; $a = $a -replace '^\./',''; if ($p -ieq $a -or ($a.EndsWith('/') -and $p.StartsWith($a, [StringComparison]::OrdinalIgnoreCase))) { return $true } }
    $false
}
function Get-PatchTargets([string]$Patch) { @([regex]::Matches($Patch, '(?im)^\*\*\* (?:(?:Update|Add|Delete) File|Move to): (.+?)\s*$') | ForEach-Object { $_.Groups[1].Value.Trim() }) }
function Test-CompletionReportArgument([string]$Command) {
    $match = [regex]::Match($Command, '(?i)-reportpath\s+(?:"([^"]+)"|''([^'']+)''|([^\s]+))')
    if (-not $match.Success) { return $false }
    $path = @($match.Groups[1].Value, $match.Groups[2].Value, $match.Groups[3].Value | Where-Object { $_ })[0]
    try {
        $full = if ([IO.Path]::IsPathRooted($path)) { [IO.Path]::GetFullPath($path) } else { [IO.Path]::GetFullPath((Join-Path $root $path)) }
        if (-not $full.StartsWith($root.TrimEnd('\') + '\', [StringComparison]::OrdinalIgnoreCase) -or -not (Test-Path -LiteralPath $full -PathType Leaf)) { return $false }
        $text = Get-Content -Raw -LiteralPath $full
        return Test-HarnessCompletionReport -Text $text -ExpectedTaskId $goal.State.GoalId
    } catch { return $false }
}

if ($Event -eq 'PreCompact') { Write-HookJson @{}; exit 0 }
if ($Event -eq 'PostCompact') { Write-HookJson @{}; exit 0 }
if ($Event -eq 'SessionStart') {
    $source = [string](Get-PropertyValue $payload @('source','session_source'))
    $goal = Get-ActiveGoal
    if ($source -match '(?i)compact|resume' -and $goal -and $goal.CapsuleSafe) { Add-Context "active Goal $($goal.State.GoalId), epoch $($goal.State.ContextEpoch): read frozen contract $($goal.State.ContractPath) and bounded capsule pointer before work; do not reload transcripts." }
    elseif ($source -match '(?i)compact|resume' -and $goal) { Add-Context "frozen Goal scope is intact but progress capsule is unavailable/unsafe; do not inject it. Reconstruct progress from current local evidence and checkpoint without changing the contract. Do not restart the task or refetch Git merely because of recovery." }
    elseif ($source -match '(?i)compact|resume') { Add-Context "no safe active Goal capsule was injected; reload repository authority files only." }
    else { Add-Context "v6.1 harness: the selected root owns an authorized objective through implementation, acceptance, repair and risk-based independent review without phase-by-phase confirmation. S-level sets evidence, not model identity. Production requires a concrete release envelope." }
    exit 0
}

if ($invalidInput -or $null -eq $payload -or $payload -is [array] -or $payload -is [string]) { Deny 'malformed PreToolUse input; no safe decision possible.'; exit 0 }
$toolName = [string](Get-PropertyValue $payload @('tool_name','toolName','name')); $toolName = $toolName.ToLowerInvariant()
if (-not $toolName) { Deny 'PreToolUse input is missing tool identity.'; exit 0 }
$input = Get-PropertyValue $payload @('tool_input','toolInput','input','arguments')
$command = if ($input -is [string]) { $input } else { [string](Get-PropertyValue $input @('command','cmd','script','text','code')) }
$isPatch = $toolName -match 'apply[_-]?patch'; $isCommand = $toolName -match 'shell|exec_command|terminal|powershell|(^|__)exec$|(^|__)command$'
$goal = Get-ActiveGoal
$invalidGoal = (Test-Path -LiteralPath (Join-Path $root '.codex/harness-state/active-goal.json')) -and -not $goal
if ($isPatch) {
    $patchText = if ($input -is [string]) { $input } else { [string](Get-PropertyValue $input @('patch','text')) }
    $targets = @(Get-PatchTargets $patchText)
    if ($invalidGoal) { Deny 'active Goal state is invalid; diagnose/restore valid continuity before writes.'; exit 0 }
    if (Test-SecretLike $patchText) { Deny 'patch appears to embed real credentials.'; exit 0 }
    foreach ($target in $targets) {
        if ($target -match '(?i)(?:^|[/\\])\.env(?:\..+)?$|(?:^|[/\\])id_(?:rsa|ed25519)$|\.(?:pem|key)$' -and $target -notmatch '(?i)(?:^|[/\\])\.env\.(?:example|sample|template)$') { Deny 'patch targets a secret-like file. Record only a redacted presence summary.'; exit 0 }
    }
    if ($goal) {
        foreach ($target in $targets) {
            $normalizedTarget = if ([IO.Path]::IsPathRooted($target)) { $target } else { Join-Path $root $target }
            try { $normalizedTarget = [IO.Path]::GetFullPath($normalizedTarget).Substring($root.Length + 1).Replace('\','/') } catch { Deny 'invalid patch target'; exit 0 }
            if ($normalizedTarget -eq ($goal.State.ContractPath -replace '\\','/') -or $normalizedTarget -match '^(\.codex/(harness-state|hooks|agents|config)|scripts/(goal-state|scope-check|stop-check)\.ps1|AGENTS\.md|docs/.*policy\.md|docs/verification-and-guardrails\.md)') { Deny 'active Goal contract or Harness authorization-policy self-modification is denied.'; exit 0 }
            if (-not (Test-AllowedPath $target $goal.Allowed)) { Deny 'patch target is outside the frozen Goal allowed scope.'; exit 0 }
        }
        if ($targets.Count -eq 0) { Deny 'ambiguous patch has no parseable target under an active Goal.'; exit 0 }
    }
    Write-HookJson @{}; exit 0
}
if (-not $isCommand) { Write-HookJson @{}; exit 0 }
if (-not $command.Trim()) { Deny 'command-bearing tool has no inspectable command; adapter required.'; exit 0 }
$lower = $command.ToLowerInvariant()
# A whole literal diagnostic is not an executed deployment/mkdir/SQL command.
if ($command -match '^\s*(?:Write-Output|Write-Host)\s+(?:''[^'']*''|"[^"$`]*")\s*$' -and -not (Test-SecretLike $command)) { Write-HookJson @{}; exit 0 }
$mkdirMatch = [regex]::Match($command, '^\s*mkdir\s+(?:"([^"$`]+)"|''([^'']+)''|([a-zA-Z0-9_./\\-]+))\s*$')
if ($goal -and $mkdirMatch.Success) {
    $dir = @($mkdirMatch.Groups[1].Value, $mkdirMatch.Groups[2].Value, $mkdirMatch.Groups[3].Value | Where-Object { $_ })[0]
    try {
        $cwd = [string](Get-PropertyValue $input @('workdir','cwd'))
        if (-not $cwd) { $cwd = [string](Get-PropertyValue $payload @('workdir','cwd')) }
        if (-not $cwd -or -not [IO.Path]::IsPathRooted($cwd)) { throw 'missing absolute execution directory' }
        $cwd = [IO.Path]::GetFullPath($cwd)
        $inputCwd = [string](Get-PropertyValue $input @('cwd'))
        if ($inputCwd -and [IO.Path]::GetFullPath($inputCwd) -ine $cwd) { throw 'conflicting execution directories' }
        $destination = if ([IO.Path]::IsPathRooted($dir)) { [IO.Path]::GetFullPath($dir) } else { [IO.Path]::GetFullPath((Join-Path $cwd $dir)) }
        if (Test-AllowedPath ($destination.TrimEnd('/','\') + '/.directory-scope-probe') $goal.Allowed) { Write-HookJson @{}; exit 0 }
    } catch { Deny 'mkdir scope requires an unambiguous absolute execution directory.'; exit 0 }
}
if (($goal -or $invalidGoal) -and $lower -match '(set-content|add-content|clear-content|out-file|copy-item|move-item|rename-item|remove-item|new-item|\bmkdir\b|\bcp\s|\bmv\s|>\s*[^\s]+)') { Deny 'ambiguous shell write under frozen/invalid Goal; use exact scoped patch or separately reviewed runner.'; exit 0 }
if ($lower -match '(begin\s+(rsa|openssh|private)\s+key|private\s+key-----)') { Deny 'tool call appears to expose private-key material.'; exit 0 }
if ($lower -match '\b(get-content|type|cat|gc|select-string|sls|rg|grep|open|notepad|code)\b[^\r\n]{0,200}(\.env(?!\.(?:example|sample|template)\b)($|[^a-z0-9])|id_rsa|id_ed25519|\.pem|\.key)') { Deny 'tool call appears to read a secret-like file.'; exit 0 }
if (Test-SecretLike $command) { Deny 'command appears to embed credentials.'; exit 0 }
$protectedReason = $null
if ($lower -match '(\brm\s+(?:-[a-z]+\s+)*-[a-z]*[rf]\b|\brmdir\s+/s\b|remove-item\b|git\s+reset\s+--hard|git\s+checkout\s+--\s|git\s+clean\s+-[a-z]*f|git\s+branch\s+(?:-[dD]|--delete)|git\s+worktree\s+remove)') { $protectedReason = 'destructive filesystem/Git action' }
$memorySchema = $command -match '^\s*sqlite3\s+:memory:\s+["'']CREATE\s+TABLE\s+[a-zA-Z_][a-zA-Z0-9_]*\s*\([a-zA-Z0-9_, ()]+\);?["'']\s*$'
if (-not $memorySchema -and (($lower -match '\b(psql|mysql|sqlite3|sqlcmd|mongosh)\b' -and $lower -match '\b(drop|truncate|delete|update|insert|alter|create|replace)\b') -or $lower -match '\b(prisma|sequelize|knex|alembic)\b[^\r\n]*(migrate|upgrade|downgrade|db\s+push)')) { $protectedReason = 'database mutation/migration' }
if ($lower -match '\bsystemctl\b[^\r\n;&|]*\s(restart|reload|start|stop|enable|disable)\b|\bservice\s+\w+\s+(restart|reload|start|stop)|\bdocker(?:-compose)?\b[^\r\n;&|]*\s(up|down|restart)\b|\bkubectl\b[^\r\n;&|]*\s(apply|delete|rollout|scale|create|replace|patch|edit|set|exec)\b|\bhelm\b[^\r\n;&|]*\s(upgrade|install|delete|uninstall|rollback)\b|(?:npm|pnpm|yarn)\s+(?:run\s+)?deploy|\bvercel\s+--prod|\bflyctl\s+deploy|\brailway\s+up') { $protectedReason = 'deployment/restart' }
if ($lower -match '\b(ssh|scp|rsync)\b') {
    # Entire command must be a single simple status query; no options, substitutions or chaining.
    $readOnly = $command -match '^\s*ssh\s+[a-zA-Z0-9_.-]+\s+[''"](?:systemctl\s+(?:status|is-active)\s+[a-zA-Z0-9_.@-]+|uname(?:\s+-a)?|uptime|df\s+-h|free\s+-m)[''"]\s*#\s*harness:server-inspection\s*$'
    if (-not $readOnly) { $protectedReason = 'remote operation outside narrow inspection form' }
}
if ($protectedReason) {
    $cwd = [string](Get-PropertyValue $input @('cwd','workdir'))
    if (-not $cwd) { $cwd = [string](Get-PropertyValue $payload @('cwd','workdir')) }
    $grant = Get-PropertyValue $input @('harness_authorization')
    $target = [string](Get-PropertyValue $input @('harness_target'))
    $version = [string](Get-PropertyValue $input @('harness_version'))
    if (-not (Test-HarnessAuthorization -Envelope $grant -Command $command -ProjectRoot $root -Cwd $cwd -Target $target -Version $version)) { Deny "$protectedReason requires concrete external authority; prepare once, never self-approve a marker."; exit 0 }
}
if ($goal -and $lower -match 'scripts[\\/]goal-state\.ps1' -and $lower -match '(?i)-action\s+(initialize|activate)\b') { Deny 'active Goal authorization contract replacement is denied.'; exit 0 }
if ($goal -and $lower -match 'scripts[\\/]goal-state\.ps1' -and $lower -match '(?i)-action\s+close\b') {
    if ($lower -match 'harness:goal-close' -and (Test-CompletionReportArgument $command)) { Write-HookJson @{}; exit 0 }
    Deny 'Close requires harness:goal-close and a concrete passing completion ReportPath.'; exit 0
}
if ($goal -and $lower -match '\.codex[\\/]harness-state[\\/]' -and $lower -match '(set-content|add-content|out-file|copy-item|move-item|remove-item|>\s*[^\s]+)') { Deny 'active Goal authorization-state mutation is denied.'; exit 0 }
if ($goal -and $lower -match '(set-content|add-content|out-file|copy-item|move-item|>\s*[^\s]+)') { Deny 'shell mutation is ambiguous under an active Goal; use an exact allowed apply_patch target.'; exit 0 }
Write-HookJson @{}
