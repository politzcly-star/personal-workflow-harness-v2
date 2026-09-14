# Dot-source only. Trust root is supplied by a trusted launcher, never repository state.
function Test-HarnessAuthorization {
    param($Envelope, [string]$Command, [string]$ProjectRoot, [string]$Cwd,
          [string]$Target, [string]$Version)
    try {
        if (-not $env:HARNESS_AUTHORITY_PUBLIC_KEY_XML -or -not $Envelope -or
            -not $Cwd -or -not $Target -or -not $Version) { return $false }
        if (-not $Envelope.Payload -or -not $Envelope.Signature -or
            ([string]$Envelope.Payload).Length -gt 65536) { return $false }
        $bytes = [Convert]::FromBase64String([string]$Envelope.Payload)
        $signature = [Convert]::FromBase64String([string]$Envelope.Signature)
        $rsa = New-Object Security.Cryptography.RSACryptoServiceProvider
        $rsa.PersistKeyInCsp = $false
        try {
            $rsa.FromXmlString($env:HARNESS_AUTHORITY_PUBLIC_KEY_XML)
            if ($rsa.KeySize -lt 2048 -or -not $rsa.VerifyData($bytes, 'SHA256', $signature)) { return $false }
        } finally { $rsa.Dispose() }
        $jsonOptions = @{ ErrorAction = 'Stop' }
        if ((Get-Command ConvertFrom-Json).Parameters.ContainsKey('DateKind')) { $jsonOptions.DateKind = 'String' }
        $grant = [Text.Encoding]::UTF8.GetString($bytes) | ConvertFrom-Json @jsonOptions
        if ($grant.schema_version -ne 1 -or -not $grant.id -or $grant.repeat_safe -isnot [bool] -or $grant.repeat_safe -ne $true -or
            -not $grant.health_checks -or -not $grant.abort_conditions -or -not $grant.rollback) { return $false }
        # Require absolute canonical paths. Relative cwd must not depend on the Hook process cwd.
        foreach ($p in @($ProjectRoot, $Cwd, $grant.project_root, $grant.cwd)) {
            if (-not [IO.Path]::IsPathRooted([string]$p)) { return $false }
        }
        if ([IO.Path]::GetFullPath($grant.project_root).TrimEnd('\','/') -ine [IO.Path]::GetFullPath($ProjectRoot).TrimEnd('\','/') -or
            [IO.Path]::GetFullPath($grant.cwd).TrimEnd('\','/') -ine [IO.Path]::GetFullPath($Cwd).TrimEnd('\','/') -or
            $grant.target -cne $Target -or $grant.version -cne $Version) { return $false }
        if ([string]$grant.not_before -notmatch 'Z$' -or [string]$grant.expires_at -notmatch 'Z$') { return $false }
        $start = [DateTimeOffset]::Parse($grant.not_before).ToUniversalTime()
        $end = [DateTimeOffset]::Parse($grant.expires_at).ToUniversalTime()
        $now = [DateTimeOffset]::UtcNow
        if ($end -le $start -or ($end - $start).TotalHours -gt 24 -or $now -lt $start -or $now -ge $end) { return $false }
        $sha = [Security.Cryptography.SHA256]::Create()
        try { $hash = ([BitConverter]::ToString($sha.ComputeHash([Text.Encoding]::UTF8.GetBytes($Command)))).Replace('-','').ToLowerInvariant() }
        finally { $sha.Dispose() }
        return @($grant.command_sha256 | Where-Object { $_ -cmatch '^[a-f0-9]{64}$' -and $_ -ceq $hash }).Count -gt 0
    } catch { return $false }
}
