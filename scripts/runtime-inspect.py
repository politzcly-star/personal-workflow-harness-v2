"""Read-only local configuration inventory. Never probes providers or grants authority."""
import argparse
import json
from pathlib import Path
import tomllib
import re


SAFE_NAME = re.compile(r'[a-z][a-z0-9_-]{0,79}\Z')
SAFE_MODELS = {'gpt-6-astra', 'gpt-6-sol', 'gpt-6-luna',
               'gpt-5.6-sol', 'gpt-5.6-terra', 'gpt-5.6-luna', 'gpt-5.5'}
EFFORTS = {'none', 'minimal', 'low', 'medium', 'high', 'xhigh', 'max', 'ultra'}


def configured_value(value, pattern=None, allowed=None):
    """Report bounded public settings; never echo arbitrary configuration text."""
    if value is None:
        return None
    if isinstance(value, str) and len(value) <= 80 and (
            (pattern is not None and pattern.fullmatch(value)) or
            (allowed is not None and value in allowed)):
        return value
    return 'redacted_or_invalid'


def registration_target(root, value):
    """Inspect only simple paths inside this project's agent directory."""
    if not isinstance(value, str) or not value.strip():
        return 'not_configured'
    parts = value.replace('\\', '/').split('/')
    if len(parts) != 2 or parts[0] != 'agents' or not parts[1].endswith('.toml'):
        return 'outside_agent_directory'
    if not SAFE_NAME.fullmatch(parts[1][:-5]):
        return 'outside_agent_directory'
    target = root / '.codex/agents' / parts[1]
    if target.is_symlink():
        return 'outside_agent_directory'
    return 'exists' if target.is_file() else 'missing_target'


def inspect(root):
    root = Path(root).resolve()
    if (root / '.codex').is_symlink() or (root / '.codex/agents').is_symlink():
        raise ValueError('configuration links are not supported')
    path = root / '.codex/config.toml'
    if path.is_symlink():
        raise ValueError('configuration link is not supported')
    if path.exists() and not path.is_file():
        raise ValueError('configuration is not a file')
    config = tomllib.loads(path.read_text(encoding='utf-8-sig')) if path.is_file() else {}
    agents = config.get('agents', {})
    if not isinstance(agents, dict):
        raise ValueError('invalid agents configuration')
    registrations = []
    for key, entry in sorted(agents.items()):
        if not isinstance(key, str) or not SAFE_NAME.fullmatch(key):
            continue
        if not isinstance(entry, dict) or 'config_file' not in entry:
            continue
        target = entry['config_file']
        status = registration_target(root, target)
        registrations.append({'role': key, 'target_status': status,
                              'target_file': Path(target.replace('\\', '/')).name
                              if status == 'exists' else None})
    roles = []
    for path in sorted((root / '.codex/agents').glob('*.toml')):
        if path.is_symlink():
            raise ValueError('role link is not supported')
        data = tomllib.loads(path.read_text(encoding='utf-8-sig'))
        # Only non-secret, bounded public role metadata is exposed.
        name = data.get('name')
        if not isinstance(name, str) or not SAFE_NAME.fullmatch(name):
            raise ValueError('invalid role name')
        metadata_valid = all(isinstance(data.get(key), str) and bool(data[key].strip())
                             for key in ('name', 'description', 'developer_instructions'))
        matching = [item for item in registrations if item['role'] in (name, path.stem)]
        if any(item['target_status'] == 'exists' and item['target_file'] == path.name
               for item in matching):
            legacy_status = 'matches_definition'
        elif any(item['target_status'] == 'exists' for item in matching):
            legacy_status = 'wrong_definition'
        elif any(item['target_status'] == 'missing_target' for item in matching):
            legacy_status = 'missing_target'
        elif matching:
            legacy_status = 'invalid_target'
        else:
            legacy_status = 'absent'
        roles.append({'role': name, 'file': path.name,
                      'standalone_definition': 'valid_metadata' if metadata_valid else 'invalid_metadata',
                      'legacy_registration': legacy_status,
                      'registration_present': legacy_status == 'matches_definition',
                      'configured_model': configured_value(data.get('model'), allowed=SAFE_MODELS),
                      'configured_reasoning_effort': configured_value(
                          data.get('model_reasoning_effort'), allowed=EFFORTS),
                      'runtime_consumed': 'unverified'})
    limits = {}
    for key in ('model_context_window', 'model_auto_compact_token_limit'):
        value = config.get(key)
        if value is not None and (type(value) is not int or value <= 0):
            raise ValueError('invalid context configuration')
        limits[key] = {'project_config_value': value, 'effective_runtime_value': 'unavailable'}
    return {'schema_version': 1, 'kind': 'static_inventory_not_live_readiness',
            'context': limits, 'roles': roles, 'legacy_registrations': registrations,
            'hooks_file_present': (root / '.codex/hooks.json').is_file(),
            'hooks_invoked': 'unverified', 'actual_model': 'unverified',
            'delegation_permission': 'check_current_user_and_platform_instructions',
            'production_authorization': 'unverified',
            'signed_request_runner_present': (root / '.codex/hooks/invoke-authorized.ps1').is_file(),
            'note': 'No auth/global config/transcripts read, no API/network calls, no model calls. Project values are not effective runtime facts. A runner file is not a trusted grant or proven client integration.'}


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--project', type=Path, default=Path(__file__).resolve().parents[1])
    args = parser.parse_args()
    try:
        print(json.dumps(inspect(args.project), ensure_ascii=False, indent=2))
    except (OSError, ValueError, TypeError):
        parser.exit(2, 'Invalid or unreadable local configuration; contents omitted.\n')
