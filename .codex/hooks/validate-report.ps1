# A consistency check of a final summary, not independent proof that tests ran.
function Test-HarnessCompletionReport {
    param([string]$Text, [string]$ExpectedTaskId)
    $statuses = [regex]::Matches($Text, '(?im)^Status:[ \t]*([^\r\n]*)\r?$')
    if ($statuses.Count -ne 1 -or $statuses[0].Groups[1].Value.Trim() -notmatch '^(?i:complete|passed|GO)$') { return $false }
    $ids = [regex]::Matches($Text, '(?im)^Task ID:[ \t]*([^\r\n]*)\r?$')
    if ($ids.Count -ne 1 -or -not $ids[0].Groups[1].Value.Trim()) { return $false }
    if ($ExpectedTaskId -and $ids[0].Groups[1].Value.Trim() -cne $ExpectedTaskId) { return $false }
    if ($Text -match '\bTODO\b') { return $false }
    # Only report-schema fields delimit sections. A named check such as
    # "persistence: BLOCKED" remains part of Checks Run, even on its own line.
    $headers = 'Task ID|Status|Decision|Baseline and scope|Changed Files|Acceptance evidence|Checks Run(?: And Results)?|Checks skipped(?: \(reason and compensation\))?|Focused repair loops|Repair History|Independent read-only review|Scope Guard|Unsupported claims avoided|Residual Risk|Cost / elapsed / Human interventions|Next Recommended Action'
    foreach ($field in @('Changed Files','Checks Run(?: And Results)?','Scope Guard','Residual Risk','Next Recommended Action')) {
        $sections = [regex]::Matches($Text, '(?ims)^' + $field + ':[ \t]*(.*?)(?=^(?:' + $headers + '):|\z)')
        if ($sections.Count -ne 1 -or -not $sections[0].Groups[1].Value.Trim()) { return $false }
        $current = $sections[0].Groups[1].Value -replace '(?i)(?<![\w.])0[ \t]+(?:failed|failures)\b', 'zero unsuccessful checks'
        if ($field -match '^(Checks|Scope)' -and $current -match '(?i)\b(FAIL|FAILED|FAILURES|BLOCKED|NO-GO|NOT[- ]VERIFIED)\b') { return $false }
    }
    return $true
}
