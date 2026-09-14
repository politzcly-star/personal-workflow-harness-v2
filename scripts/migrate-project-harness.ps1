param(
    [Parameter(Mandatory = $true)] [string]$ProjectPath,
    [switch]$Apply,
    [switch]$DryRun,
    [switch]$ReplaceConfig,
    [switch]$ReplaceHooks,
    [switch]$ReplaceLegacyAgents,
    # Compatibility name: overwrite verified owned files, never archive/delete.
    [switch]$ArchiveLegacyHarness
)

$ErrorActionPreference = 'Stop'
if ($Apply -and $DryRun) {
    Write-Output '[BLOCKED] -Apply and -DryRun are mutually exclusive; zero writes'
    exit 2
}
$harnessRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$projectRoot = [IO.Path]::GetFullPath($ProjectPath)
# The standard TOML parser validates the whole document before surgical edits.
# No downloaded dependencies, generated helper files, or secret-bearing diagnostics.
$python = Get-Command python -ErrorAction SilentlyContinue
if (-not $python) {
    Write-Output '[BLOCKED] Python 3.11+ (python on PATH) is required; zero writes'
    exit 2
}
$worker = @'
import copy
import hashlib
import json
import os
from pathlib import Path
import re
import stat
import subprocess
import sys

try:
    import tomllib
except ImportError:
    print('[BLOCKED] Python 3.11+ is required; zero writes')
    sys.exit(2)

class Blocker(Exception):
    pass

def require(condition, message):
    if not condition:
        raise Blocker(message)

source = Path(sys.argv[1]).absolute()
root = Path(sys.argv[2]).absolute()
apply, replace_config, replace_hooks, replace_agents, upgrade_owned = (
    value == 'True' for value in sys.argv[3:8]
)
observed = {}
writes = {}
plans = []
START = '<!-- production-harness-v2:start -->'
END = '<!-- production-harness-v2:end -->'
MANIFEST = '.codex/harness-owned.json'
ROLES = ('luna-qa', 'terra-worker', 'luna-verifier', 'sol-planner')
RUNTIME = (
    '.codex/hooks/authorize-command.ps1', '.codex/hooks/harness-hook.ps1', '.codex/hooks/validate-report.ps1',
    '.codex/hooks/invoke-authorized.ps1',
    'scripts/goal-state.ps1', 'scripts/validate-config.py', 'templates/goal-contract.md', 'templates/context-capsule.md',
    'scripts/runtime-inspect.py', 'scripts/verification-evidence.py',
    'scripts/branch-finish-check.ps1', 'scripts/scope-check.ps1', 'scripts/evaluate-efficiency.py',
    'templates/release-authorization.json', 'templates/verification-evidence.json',
    'scripts/stop-check.ps1', 'templates/branch-finish.md', 'templates/deployment-checklist.md', 'templates/database-checklist.md', 'templates/server-inspection.md',
) + tuple('.codex/agents/' + role + '.toml' for role in ROLES)
POLICIES = (
    'docs/route-policy.md', 'docs/model-routing-policy.md', 'docs/capability-policy.md',
    'docs/skill-routing-policy.md', 'docs/cost-efficiency-policy.md', 'docs/autonomous-goal-workflow.md',
    'docs/context-memory.md', 'docs/context-compression-policy.md',
    'docs/parent-child-execution.md', 'docs/reporting-policy.md',
    'docs/developer-efficiency-mode.md', 'docs/verification-and-guardrails.md',
    'docs/hook-tuning.md', 'docs/install-hooks-upgrade.md',
    'docs/git-network-policy.md', 'docs/runtime-readiness-policy.md',
    'templates/task-brief.md', 'templates/verification-report.md',
    'templates/child-task.md', 'templates/child-report.md', 'templates/handoff.md',
    'templates/project-agents.md', 'templates/feature-plan.md', 'scripts/health-check.ps1',
)
# Reviewed install closure, not a recursive copy of source docs/tests/history.
# Validate even missing-only inputs when the target already has its own copy.
REQUIRED_SOURCES = RUNTIME + POLICIES + (
    '.codex/config.toml', '.codex/hooks.json', 'templates/project-profile.md',
)

def guard(path):
    # Resolve alone is insufficient: reject junctions/symlinks even pointing inside.
    for part in (*reversed(path.parents), path):
        if os.path.lexists(part):
            info = part.lstat()
            require(not stat.S_ISLNK(info.st_mode) and
                    not (getattr(info, 'st_file_attributes', 0) & 0x400),
                    'linked/reparse path is not safe: ' + str(part))
            if part != path:
                require(part.is_dir(), 'parent is not a directory: ' + str(part))
    require(not path.exists() or not path.is_file() or path.stat().st_nlink == 1,
            'hard-linked file is not safe: ' + str(path))

def safe(base, relative):
    path = base / relative
    require(not Path(relative).is_absolute() and '..' not in Path(relative).parts
            and path.resolve().is_relative_to(base.resolve()), 'path escapes allowed root')
    guard(path)
    return path

def read(path, required=False):
    guard(path)
    require(not path.exists() or path.is_file(), 'expected a regular file: ' + str(path))
    data = path.read_bytes() if path.exists() else None
    require(data is not None or not required, 'required source is missing: ' + str(path))
    if path in observed:
        require(observed[path] == data, 'file changed during preflight: ' + str(path))
    observed[path] = data
    return data

def utf8(data):
    return data.decode('utf-8-sig')

def src(relative):
    return read(safe(source, relative), required=True)

def target(relative):
    return read(safe(root, relative))

def stage(relative, data, description):
    path = safe(root, relative)
    old = read(path)
    if old != data:
        writes[path] = data
        plans.append(description + ' ' + relative)
    else:
        plans.append('keep current ' + relative)

def digest(data):
    return hashlib.sha256(data).hexdigest()

def parse_json(data):
    def pairs(items):
        obj = {}
        for key, value in items:
            require(key not in obj, 'duplicate JSON keys are ambiguous')
            obj[key] = value
        return obj
    return json.loads(utf8(data), object_pairs_hook=pairs,
                      parse_constant=lambda _: require(False, 'invalid JSON constant'))

def json_bytes(value):
    return (json.dumps(value, ensure_ascii=False, indent=2) + '\n').encode('utf-8')

def git(*args):
    try:
        proc = subprocess.run(['git', '-C', str(source), *args], stdout=subprocess.PIPE,
                              stderr=subprocess.DEVNULL, timeout=30)
        return proc.stdout if proc.returncode == 0 else None
    except (OSError, subprocess.TimeoutExpired):
        return None

history_cache = {}
def known_versions(relative):
    if relative not in history_cache:
        versions = []
        current = read(safe(source, relative))
        if current is not None:
            versions.append(current)
        log = git('log', '--format=%H', '--', relative)
        for revision in (log or b'').decode('ascii').splitlines():
            value = git('show', revision + ':' + relative)
            if value is not None:
                versions.append(value)
        history_cache[relative] = versions
    return history_cache[relative]

def same_text(left, right):
    return utf8(left).replace('\r\n', '\n') == utf8(right).replace('\r\n', '\n')

def owned(relative, data):
    if relative in ownership:
        return digest(data) == ownership[relative]
    return any(same_text(data, version) for version in known_versions(relative))

def install(relative, permission=True):
    new = src(relative)
    utf8(new)
    old = target(relative)
    if old is not None and old != new:
        require(owned(relative, old), 'unrecognized/customized owned-file collision: ' + relative)
        require(permission, 'existing owned file differs; use -ReplaceHooks: ' + relative)
    stage(relative, new, 'overwrite owned' if old is not None else 'install')
    ownership[relative] = digest(new)

def instructions(data):
    text = utf8(data)
    match = re.search(r'```text\s*\n(.*?)\n```', text, re.S)
    return match.group(1).strip() if match else text.strip()

def merge_agents():
    body = instructions(src('templates/project-agents.md'))
    require(body and START not in body and END not in body, 'invalid AGENTS template markers')
    block = START + '\n' + body + '\n' + END
    old = target('AGENTS.md')
    text = utf8(old) if old is not None else ''
    require(text.count(START) == text.count(END) and text.count(START) <= 1,
            'AGENTS.md has duplicate or incomplete managed markers')
    require('production-harness-' not in text.replace(START, '').replace(END, ''),
            'AGENTS.md has unknown Harness markers')
    if START in text:
        start, end = text.index(START), text.index(END) + len(END)
        require(start < text.index(END), 'AGENTS.md managed markers are reversed')
        outside = text[:start] + text[end:]
    else:
        outside = text
    legacy = re.search(r'(?m)^#{1,2} (?:Production Harness|AI Workflow Operating System)', outside)
    if legacy:
        require(replace_agents, 'legacy AGENTS rules require -ReplaceLegacyAgents')
        # A title does not prove the following project instructions are disposable.
        # Only a known revision/template prefix is removed; retain its entire tail.
        boundaries = [m.start() for m in re.finditer(
            r'(?m)^# (?:Directory guide[ \t]*\r?$|Project Conventions for [^\r\n]+)', text)]
        candidates = known_versions('AGENTS.md') + known_versions('templates/project-agents.md')
        split_at = boundaries[0] if boundaries else len(text)
        prefix = text[:split_at].strip()
        recognized = False
        for candidate in candidates:
            for form in (utf8(candidate).strip(), instructions(candidate)):
                boundary = re.search(r'(?m)^# (?:Directory guide[ \t]*\r?$|Project Conventions for [^\r\n]+)', form)
                form = form[:boundary.start()].strip() if boundary else form
                if prefix.replace('\r\n', '\n') == form.replace('\r\n', '\n'):
                    recognized = True
        require(recognized, 'unrecognized legacy AGENTS prefix; explicitly mark the owned span after review')
        text = text[split_at:]
        # Retain conventions even after the old managed block.
        if START in text:
            text = text[:text.index(START)] + block + text[text.index(END) + len(END):]
        else:
            text = block + ('\n\n' + text if text else '\n')
    elif START in text:
        text = text[:start] + block + text[end:]
    else:
        text = text + ('\n\n' if text and not text.endswith('\n\n') else '') + block + '\n'
    stage('AGENTS.md', text.encode('utf-8'), 'merge managed block; preserve project conventions in')

def statements(text):
    # TOML-aware spans: fake [agents]/keys inside strings and arrays stay opaque.
    start = i = depth = 0
    quote = None
    while i < len(text):
        char = text[i]
        if quote:
            if char == '\\' and quote[0] == '"':
                i += 2
                continue
            if text.startswith(quote, i):
                i += len(quote)
                quote = None
                continue
        elif char in ('"', "'"):
            quote = char * (3 if text.startswith(char * 3, i) else 1)
            i += len(quote)
            continue
        elif char == '#':
            end = text.find('\n', i)
            i = len(text) if end < 0 else end
            continue
        elif char in '[{':
            depth += 1
        elif char in ']}':
            depth -= 1
        if char == '\n' and not quote and depth == 0:
            yield start, i + 1, text[start:i + 1]
            start = i + 1
        i += 1
    if start < len(text):
        yield start, len(text), text[start:]

def leaf_path(value):
    path = []
    while isinstance(value, dict) and len(value) == 1:
        key, value = next(iter(value.items()))
        path.append(key)
    return tuple(path)

def merge_config():
    source_config = tomllib.loads(utf8(src('.codex/config.toml')))
    desired = {('agents', 'max_threads'): 4, ('agents', 'max_depth'): 1}
    for role in ROLES:
        key = role.replace('-', '_')
        config = source_config.get('agents', {}).get(key, {})
        require(isinstance(config, dict), 'source role registration must be a table')
        for field in ('description', 'config_file'):
            if field in config:
                require(isinstance(config[field], str), 'source role fields must be strings')
                if field == 'config_file':
                    require(config[field].replace('\\', '/') == 'agents/' + role + '.toml',
                            'source role config_file must use its portable relative path')
                desired[('agents', key, field)] = config[field]
    old = target('.codex/config.toml')
    text = utf8(old) if old is not None else ''
    parsed = tomllib.loads(text)
    expected = copy.deepcopy(parsed)
    for path, value in desired.items():
        table = expected
        for key in path[:-1]:
            table = table.setdefault(key, {})
            require(isinstance(table, dict), 'managed config table conflicts with a scalar/array')
        if path[-1] in table and (table[path[-1]] != value or type(table[path[-1]]) is not type(value)):
            require(replace_config, 'managed config field differs; use -ReplaceConfig: ' + '.'.join(path))
        table[path[-1]] = value
    spans, headers = {}, {}
    section = ()
    for begin, end, statement in statements(text):
        stripped = statement.strip()
        if not stripped or stripped.startswith('#'):
            continue
        if stripped.startswith('['):
            # Parse quoted table names with tomllib rather than splitting on dots.
            require(not stripped.startswith('[[') or 'agents' not in stripped,
                    'array-of-tables for managed agents is ambiguous')
            if stripped.startswith('[['):
                section = ('<unmanaged-array>',)
            else:
                section = leaf_path(tomllib.loads(statement + '\n__migration_probe__ = 0'))[:-1]
                headers[section] = end
            continue
        match = re.match(r'([\s\S]*?)=', statement)
        require(match is not None, 'unrecognized TOML assignment')
        key_path = leaf_path(tomllib.loads(match.group(1) + '= 0'))
        path = section + key_path
        for managed in desired:
            require(not (managed[:len(path)] == path and path != managed),
                    'inline/dotted managed table is ambiguous; use explicit [agents] tables')
        if path in desired:
            require(len(key_path) == 1 and section == path[:-1],
                    'dotted managed fields require explicit [agents] tables')
            spans[path] = (begin, end, statement, match.end())
    changes = []
    additions = {}
    for path, value in desired.items():
        literal = json.dumps(value, ensure_ascii=False)
        if path in spans:
            begin, end, statement, value_start = spans[path]
            scalar = re.fullmatch(r'([ \t]*)(?:[+-]?[0-9_]+|"(?:[^"\\\r\n]|\\.)*"|\x27[^\x27\r\n]*\x27)([ \t]*(?:#[^\r\n]*)?\r?\n?)', statement[value_start:])
            require(scalar is not None, 'managed value has unsupported syntax: ' + '.'.join(path))
            changes.append((begin, end, statement[:value_start] + scalar[1] + literal + scalar[2]))
        else:
            additions.setdefault(path[:-1], []).append(path[-1] + ' = ' + literal + '\n')
    for table, lines in additions.items():
        if table in headers:
            offset = headers[table]
            prefix = '' if text[:offset].endswith('\n') else '\n'
            changes.append((offset, offset, prefix + ''.join(lines)))
        else:
            changes.append((len(text), len(text), '\n[' + '.'.join(table) + ']\n' + ''.join(lines)))
    for begin, end, replacement in sorted(changes, key=lambda item: (item[0], item[1]), reverse=True):
        text = text[:begin] + replacement + text[end:]
    require(tomllib.loads(text) == expected, 'config merge could not prove preservation')
    stage('.codex/config.toml', text.encode('utf-8'), 'merge managed fields only in')

COMMAND = re.compile(
    r'^(?:pwsh|powershell)(?:\.exe)? -NoProfile -ExecutionPolicy Bypass -File '
    r'(?P<quote>[\x22\x27]?)(?:\./)?\.codex[/\\]hooks[/\\]'
    r'(?P<script>harness-hook|authorize-command)\.ps1(?P=quote)'
    r'(?: -Event (?P<event>[A-Za-z]+))?$', re.I)

def strip_hooks(items, event, collected):
    require(isinstance(items, list), 'hook events/nested hooks must be arrays')
    kept = []
    for item in items:
        require(isinstance(item, dict), 'hook entries must be objects')
        commands = [item[key] for key in ('command', 'commandWindows') if key in item]
        mentions = any(isinstance(command, str) and re.search(
            r'(?:harness-hook|authorize-command)\.ps1', command, re.I) for command in commands)
        if mentions:
            require(item.get('type') == 'command' and set(item) <= {'type', 'command', 'commandWindows'},
                    'custom metadata/mixed Harness hook entry requires manual review')
            matches = [COMMAND.fullmatch(command) if isinstance(command, str) else None for command in commands]
            require(matches and all(matches), 'ambiguous or nonportable Harness hook command')
            require(len({(m['script'].lower(), m['event']) for m in matches}) == 1,
                    'platform hook commands disagree')
            require(all(m['event'] == event or (m['script'].lower() == 'authorize-command' and m['event'] is None)
                        for m in matches), 'Harness hook event does not match its command')
            collected.append(item)
            continue
        updated = copy.deepcopy(item)
        if 'hooks' in item:
            updated['hooks'] = strip_hooks(item['hooks'], event, collected)
            if not updated['hooks'] and set(updated) <= {'matcher', 'hooks'}:
                continue
        kept.append(updated)
    return kept

def merge_hooks():
    new = parse_json(src('.codex/hooks.json'))
    require(isinstance(new, dict) and isinstance(new.get('hooks'), dict), 'invalid source hooks schema')
    for event, items in new['hooks'].items():
        found = []
        require(not strip_hooks(items, event, found) and found, 'source hooks contain unowned entries')
    old_data = target('.codex/hooks.json')
    old = parse_json(old_data) if old_data is not None else {'version': new.get('version'), 'hooks': {}}
    require(isinstance(old, dict) and isinstance(old.get('hooks'), dict), 'invalid target hooks schema')
    require(old.get('version') == new.get('version'), 'hook schema version conflict')
    merged = copy.deepcopy(old)
    old_owned = {}
    for event, items in old['hooks'].items():
        found = []
        merged['hooks'][event] = strip_hooks(items, event, found)
        if found:
            old_owned[event] = found
    for event, items in new['hooks'].items():
        merged['hooks'].setdefault(event, []).extend(copy.deepcopy(items))
    for event in list(merged['hooks']):
        if not merged['hooks'][event] and event in old_owned and event not in new['hooks']:
            del merged['hooks'][event]
    if old_owned and merged != old:
        require(replace_hooks, 'existing Harness hook entries differ; use -ReplaceHooks')
    stage('.codex/hooks.json', old_data if old_data is not None and merged == old else json_bytes(merged),
          'merge Harness entries; preserve non-Harness hooks in')

def plan_exclude():
    try:
        def probe(*args):
            proc = subprocess.run(['git', '-C', str(root), 'rev-parse', *args],
                                  stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, timeout=15)
            return os.fsdecode(proc.stdout).strip() if proc.returncode == 0 else ''
        top = probe('--show-toplevel')
        if not top or Path(top).resolve() != root.resolve():
            plans.append('leave non-Git target without .git or Git exclude files')
            return
        exclude = Path(probe('--path-format=absolute', '--git-path', 'info/exclude'))
        common = Path(probe('--path-format=absolute', '--git-common-dir'))
        require(exclude.is_absolute() and common.is_absolute() and exclude.resolve().is_relative_to(common.resolve()),
                'Git exclude path cannot be verified')
        old = read(exclude)
        text = utf8(old) if old is not None else ''
        if '.codex/harness-state/' not in text.splitlines():
            text += ('' if not text or text.endswith('\n') else '\n') + '# Local-only autonomous Goal state\n.codex/harness-state/\n'
            writes[exclude] = text.encode('utf-8')
        plans.append('ensure runtime-state exclusion in verified Git metadata (no backup exclusion)')
    except (OSError, subprocess.TimeoutExpired):
        raise Blocker('Git metadata preflight failed')

def main():
    global ownership
    guard(source)
    guard(root)
    require(source.is_dir() and root.is_dir(), 'source and project must be existing directories')
    require(root.resolve() != source.resolve() and not root.resolve().is_relative_to(source.resolve())
            and not source.resolve().is_relative_to(root.resolve()), 'source/project must be separate, non-nested roots')
    for relative in REQUIRED_SOURCES:
        utf8(src(relative))
    manifest_data = target(MANIFEST)
    manifest = parse_json(manifest_data) if manifest_data is not None else {'version': 1, 'files': {}}
    require(isinstance(manifest, dict) and set(manifest) == {'version', 'files'}
            and type(manifest['version']) is int and manifest['version'] == 1
            and isinstance(manifest['files'], dict), 'unsupported ownership manifest')
    ownership = manifest['files'].copy()
    require(all(path in RUNTIME + POLICIES and isinstance(value, str) and re.fullmatch('[0-9a-f]{64}', value)
                for path, value in ownership.items()), 'unknown ownership manifest entries; no cleanup attempted')
    merge_agents()
    merge_config()
    merge_hooks()
    for relative in RUNTIME:
        install(relative, replace_hooks if relative.startswith('.codex/hooks/') else True)
    for relative in POLICIES:
        old = target(relative)
        new = src(relative)
        if old is not None and old != new:
            require(owned(relative, old),
                    'unknown/customized same-name project file; cannot overwrite: ' + relative)
            require(upgrade_owned,
                    'outdated owned policy remains active; use -ArchiveLegacyHarness: ' + relative)
        install(relative)
    profile = target('docs/project-profile.md')
    if profile is None:
        text = utf8(src('templates/project-profile.md'))
        text = re.sub(r'(?m)^Project:[ \t]*\r?$', lambda _: 'Project: ' + root.name, text)
        text = re.sub(r'(?m)^Repository Root:[ \t]*\r?$', lambda _: 'Repository Root: ' + str(root), text)
        stage('docs/project-profile.md', text.encode('utf-8'), 'create missing')
    else:
        plans.append('preserve existing docs/project-profile.md byte-for-byte')
    stage(MANIFEST, json_bytes({'version': 1, 'files': ownership}), 'record owned hashes (not a backup) in')
    plan_exclude()
    for plan in plans:
        print('[PLAN] ' + plan)
    # Recheck ALL observations before the first mkdir/write.
    for path, expected in observed.items():
        guard(path)
        actual = path.read_bytes() if path.is_file() else None
        require(actual == expected, 'file changed after planning: ' + str(path))
    for path in writes:
        guard(path)
        require(not path.exists() or path.is_file(), 'write destination is not a file')
    if not apply:
        print('[OK] dry run complete; zero writes; rerun with -Apply after review')
        return
    for path, data in writes.items():
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(data)
    print('[OK] project harness migration applied in place; no backups or history cleanup')
    print('[NEXT] inspect project diff and tests; root model remains Human-selected')

print('[MODE] ' + ('APPLY' if apply else 'DRY RUN'))
try:
    main()
except Blocker as error:
    print('[BLOCKED] ' + str(error))
    print('[INFO] preflight blocked; zero project writes')
    sys.exit(2)
except (ValueError, UnicodeError):
    # Parser messages may include config values; deliberately do not echo them.
    print('[BLOCKED] invalid UTF-8/TOML/JSON or unsupported data; zero project writes')
    sys.exit(2)
except OSError:
    print('[ERROR] filesystem operation failed; inspect project state if Apply had begun')
    sys.exit(3)
'@

$worker | & $python.Source -X utf8 - $harnessRoot $projectRoot ([bool]$Apply).ToString() ([bool]$ReplaceConfig).ToString() ([bool]$ReplaceHooks).ToString() ([bool]$ReplaceLegacyAgents).ToString() ([bool]$ArchiveLegacyHarness).ToString()
exit $LASTEXITCODE
