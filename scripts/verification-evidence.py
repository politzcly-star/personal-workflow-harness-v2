"""Run an already-authorized LOCAL check, or verify its content-bound freshness.

Not a sandbox, permission grant, production verifier, or proof against forged reports.
The integration owner must check that check_id/command and environment identity cover
the required acceptance. External services require fresh observation, not this cache.

run and default verify support working-tree-only development checks, including
preexisting unstaged edits, while binding the unchanged index identity as well.
Delivery callers MUST use verify --require-index-match: this additionally requires
agreement between tracked working-tree content and index blobs, before and after the
check and at reuse. Ordinary local reuse must not be presented as staged acceptance.
No staged blob contents or clean/textconv filters are read/executed. Ordinary Git
text/eol/autocrlf CRLF-to-LF normalization is supported using read-only attributes
and config. Custom filter, working-tree-encoding, ident and legacy crlf attributes
are unsupported for delivery (local reuse remains available). Preserve project
conversions and use a separately verified delivery path; rerunning cannot fix them.
Stage the intended exact content before checking, then reuse while content/index and
environment remain unchanged; there is no per-stage mandatory test rerun.
"""
import argparse
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import time


def digest(data):
    return hashlib.sha256(data).hexdigest()


def safe_path(root, path):
    path = Path(path)
    path = path if path.is_absolute() else root / path
    if '..' in path.parts or not path.absolute().is_relative_to(root):
        raise ValueError('path outside project')
    for part in (path, *path.parents):
        if part == root.parent:
            break
        if part.is_symlink() or (part.exists() and part.resolve() != part.absolute()):
            raise ValueError('linked path not accepted')
        if part.exists() and (getattr(part.lstat(), 'st_file_attributes', 0) & 0x400):
            raise ValueError('reparse path not accepted')
        if part.is_file() and part.stat().st_nlink != 1:
            raise ValueError('hard-linked file not accepted')
    return path


def evidence_path(root, path):
    path = safe_path(root, path)
    if not path.is_relative_to(root / '.codex/harness-state/verification') or path.suffix != '.json':
        raise ValueError('evidence must be a JSON file in .codex/harness-state/verification/')
    return path


def conversion_policy(root, names):
    # Metadata only: unlike ls-files --eol/hash-object --path, this does not
    # inspect staged blob contents or invoke a user-defined conversion process.
    raw = subprocess.run(['git', '-C', str(root), 'check-attr', '-z', '--stdin',
                          'text', 'eol', 'filter', 'working-tree-encoding', 'ident', 'crlf'],
                         input=b''.join(name.encode('utf-8') + b'\0' for name in names),
                         capture_output=True, check=True).stdout.split(b'\0')
    attributes = {}
    for i in range(0, len(raw) - 1, 3):
        name, key, value = raw[i:i+3]
        attributes.setdefault(name.decode('utf-8'), {})[key] = value
    config = subprocess.run(['git', '-C', str(root), 'config', '--get', 'core.autocrlf'],
                            capture_output=True)
    if config.returncode not in (0, 1):
        config.check_returncode()
    autocrlf = config.stdout.strip().lower()
    if autocrlf not in (b'', b'false', b'no', b'off', b'0', b'true', b'yes', b'on', b'1', b'input'):
        raise ValueError('invalid autocrlf configuration')
    return attributes, autocrlf in (b'true', b'yes', b'on', b'1', b'input')


def index_bytes(content, attributes, autocrlf):
    inactive = (b'unspecified', b'unset')
    if any(attributes.get(key, b'unspecified') not in inactive
           for key in (b'filter', b'working-tree-encoding', b'ident', b'crlf')):
        return None  # Unsupported conversions must not masquerade as acceptance.
    text = attributes.get(b'text', b'unspecified')
    eol = attributes.get(b'eol', b'unspecified')
    if text not in (b'set', b'unset', b'auto', b'unspecified') or eol not in (*inactive, b'lf', b'crlf'):
        return None
    if text == b'unset':
        return content
    normalize = text in (b'set', b'auto') or eol in (b'lf', b'crlf') or autocrlf
    automatic = text == b'auto' or (text == b'unspecified' and eol not in (b'lf', b'crlf'))
    # Conservative subset of Git auto-text detection: never normalize binary
    # controls or lone CRs. Explicit text declarations permit CRLF replacement.
    if automatic and (b'\r' in content.replace(b'\r\n', b'')
                      or any(byte < 32 and byte not in (9, 10, 13) or byte == 127 for byte in content)):
        normalize = False
    return content.replace(b'\r\n', b'\n') if normalize else content


def snapshot(root):
    top = subprocess.run(['git', '-C', str(root), 'rev-parse', '--show-toplevel'], capture_output=True, check=True).stdout.decode().strip()
    if Path(top).resolve() != root:
        raise ValueError('project must be the actual Git root')
    # Hash Git's NUL-delimited path/mode/blob/stage identities, not .git/index
    # bytes (whose stat cache may be refreshed without a semantic change).
    # ls-files reads index metadata only, never the staged blob's secret contents.
    index_raw = subprocess.run(['git', '-C', str(root), 'ls-files', '--stage', '-z'], capture_output=True, check=True).stdout
    entries = {}
    for entry in index_raw.split(b'\0'):
        if not entry:
            continue
        identity, name = entry.split(b'\t', 1)
        entries.setdefault(name.decode('utf-8'), []).append(identity.split())
    raw = subprocess.run(['git', '-C', str(root), 'ls-files', '--cached', '--others', '--exclude-standard', '-z'], capture_output=True, check=True).stdout
    attributes, autocrlf = conversion_policy(root, entries)
    hashes = {}
    index_matches = True
    for name in sorted(set(raw.decode('utf-8').split('\0')) - {''}):
        if name.startswith('.codex/harness-state/'):
            continue
        path = safe_path(root, name)
        # Never read credentials to construct a verification fingerprint.
        base = path.name.lower()
        if ((base == '.env' or base.startswith('.env.')) and base not in ('.env.example', '.env.sample', '.env.template')) or base in ('id_rsa', 'id_ed25519') or path.suffix.lower() in ('.pem', '.key'):
            raise ValueError('secret-like source path cannot be fingerprinted')
        if path.is_dir():
            raise ValueError('submodule/directory requires its own verification strategy')
        content = path.read_bytes() if path.exists() else None
        hashes[name] = digest(content) if content is not None else None
        for mode, oid, stage in entries.get(name, []):
            # Never trust stat-only diff shortcuts, assume-unchanged or sparse
            # flags. Compute the Git blob identity from these already-safe bytes.
            if (content is None or stage != b'0' or mode not in (b'100644', b'100755')
                    or len(oid) not in (40, 64)):
                index_matches = False
                continue
            normalized = index_bytes(content, attributes.get(name, {}), autocrlf)
            matches = False
            if normalized is not None:
                # Raw equality also covers existing CRLF blobs that Git's auto
                # conversion deliberately leaves unchanged. Normalization may
                # only remove declared CRLFs, never arbitrary source differences.
                for candidate in (content, normalized):
                    blob = hashlib.new('sha1' if len(oid) == 40 else 'sha256')
                    blob.update(b'blob ' + str(len(candidate)).encode('ascii') + b'\0')
                    blob.update(candidate)
                    matches |= blob.hexdigest().encode('ascii') == oid
            if not matches:
                index_matches = False
            if os.name != 'nt' and bool(path.stat().st_mode & 0o100) != (mode == b'100755'):
                index_matches = False
    if any(name not in hashes and not name.startswith('.codex/harness-state/') for name in entries):
        index_matches = False
    # A staged deletion restored as an untracked file is also a tree mismatch.
    # Names/status only, with rename/content conversion disabled: no blob reads.
    deleted = subprocess.run(['git', '-C', str(root), 'diff', '--cached', '--name-only',
                              '--diff-filter=D', '--no-renames', '--no-ext-diff',
                              '--no-textconv', '-z', '--'], capture_output=True, check=True).stdout
    for name in deleted.decode('utf-8').split('\0'):
        if name and not name.startswith('.codex/harness-state/') and safe_path(root, name).exists():
            index_matches = False
    if not hashes:
        raise ValueError('empty source snapshot')
    return dict(source_sha256=digest(json.dumps(hashes, sort_keys=True, ensure_ascii=False).encode('utf-8')),
                index_sha256=digest(index_raw), index_matches_worktree=index_matches)


def run_check(root, path, check_id, environment_id, argv):
    root = Path(root).resolve()
    path = evidence_path(root, path)
    if not check_id.strip() or not environment_id.strip() or not argv:
        raise ValueError('check, environment and exact argv required')
    # A newer interrupted/failed attempt must not leave an older PASS reusable.
    # State is excluded from source hashing; this is not independent proof.
    path.parent.mkdir(parents=True, exist_ok=True)
    safe_path(root, path)
    path.write_text(json.dumps({'schema_version': 1, 'kind': 'local_check_in_progress'})+'\n', encoding='utf-8')
    before = snapshot(root)
    started = datetime.now(timezone.utc).isoformat()
    tick = time.monotonic()
    # No shell interpolation. The caller still needs authority for this program
    # and its effects; wrapping a protected command does not authorize it.
    result = subprocess.run(argv, cwd=root, check=False)
    after = snapshot(root)
    record = dict(schema_version=1, kind='local_check_freshness', project_root=str(root),
                  check_id=check_id, environment_id=environment_id,
                  command_sha256=digest(json.dumps(argv, ensure_ascii=False).encode('utf-8')),
                  source_sha256=before['source_sha256'],
                  source_unchanged=before['source_sha256'] == after['source_sha256'],
                  index_sha256=before['index_sha256'],
                  index_unchanged=before['index_sha256'] == after['index_sha256'],
                  index_matches_worktree=before['index_matches_worktree'] and after['index_matches_worktree'],
                  exit_code=result.returncode, started_utc=started,
                  finished_utc=datetime.now(timezone.utc).isoformat(),
                  elapsed_seconds=round(time.monotonic()-tick, 3),
                  note='Freshness only; locally editable evidence is not authority or independent proof. Environment identity must be re-established by caller. Delivery verify additionally requires unchanged index identity and tracked worktree/index agreement (ordinary Git text EOL normalization supported); a working-tree check alone is not staged acceptance.')
    path.parent.mkdir(parents=True, exist_ok=True)
    safe_path(root, path)
    path.write_text(json.dumps(record, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
    return result.returncode == 0 and before == after


def verify(root, path, check_id, environment_id, require_index_match=False):
    root = Path(root).resolve()
    path = evidence_path(root, path)
    if not check_id.strip() or not environment_id.strip() or path.stat().st_size > 16384:
        raise ValueError('bounded evidence, check and environment required')
    data = json.loads(path.read_text(encoding='utf-8-sig'))
    if not isinstance(data, dict):
        raise ValueError('invalid evidence object')
    if data.get('schema_version') != 1 or data.get('kind') != 'local_check_freshness':
        return False
    if data.get('project_root') != str(root) or data.get('check_id') != check_id or data.get('environment_id') != environment_id:
        return False
    if type(data.get('exit_code')) is not int or data['exit_code'] != 0 or data.get('source_unchanged') is not True:
        return False
    if not re.fullmatch('[a-f0-9]{64}', str(data.get('command_sha256', ''))):
        return False
    # Old records without index binding cannot establish freshness under this contract.
    if (not re.fullmatch('[a-f0-9]{64}', str(data.get('index_sha256', '')))
            or data.get('index_unchanged') is not True
            or type(data.get('index_matches_worktree')) is not bool):
        return False
    if require_index_match and data['index_matches_worktree'] is not True:
        return False
    try:
        start = datetime.fromisoformat(data['started_utc'])
        end = datetime.fromisoformat(data['finished_utc'])
        if start.tzinfo is None or end.tzinfo is None or not start <= end <= datetime.now(timezone.utc):
            return False
    except (KeyError, TypeError, ValueError):
        return False
    current = snapshot(root)
    return (data.get('source_sha256') == current['source_sha256']
            and data['index_sha256'] == current['index_sha256']
            and (not require_index_match or current['index_matches_worktree']))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('action', choices=['run', 'verify'])
    parser.add_argument('--project', type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument('--evidence', required=True)
    parser.add_argument('--check-id', required=True)
    parser.add_argument('--environment-id', required=True)
    parser.add_argument('--require-index-match', action='store_true',
                        help='verify only: require tracked worktree/index agreement (ordinary Git text EOL normalization supported) for staged delivery acceptance')
    # Split program argv before argparse so -- never becomes shell syntax.
    args_raw = sys.argv[1:]
    program = []
    if '--' in args_raw:
        i = args_raw.index('--'); program = args_raw[i+1:]; args_raw = args_raw[:i]
    args = parser.parse_args(args_raw)
    try:
        if args.action == 'run':
            if args.require_index_match:
                raise ValueError('require-index-match is a verify-only acceptance option')
            ok = run_check(args.project, args.evidence, args.check_id, args.environment_id, program)
        else:
            if program:
                raise ValueError('verify does not execute commands')
            ok = verify(args.project, args.evidence, args.check_id, args.environment_id,
                        require_index_match=args.require_index_match)
        if ok:
            if args.action == 'run':
                print('[OK] local check recorded; staged acceptance requires verify --require-index-match')
            elif args.require_index_match:
                print('[OK] local check evidence is current for source and matching index')
            else:
                print('[OK] local worktree evidence is current with bound index identity; not staged acceptance')
        else:
            print('[FAIL] failed, stale or source/index-mismatched evidence; align intended content/index and rerun affected checks when changed')
        raise SystemExit(0 if ok else 1)
    except (OSError, ValueError, TypeError, subprocess.SubprocessError):
        parser.exit(2, 'Evidence cannot be recorded/verified; no PASS established. Sensitive details omitted.\n')
