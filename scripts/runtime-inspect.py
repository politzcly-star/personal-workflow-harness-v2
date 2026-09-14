"""Read-only local configuration inventory. Never probes providers or grants authority."""
import argparse
import json
from pathlib import Path
import tomllib


def inspect(root):
    root = Path(root).resolve()
    path = root / '.codex/config.toml'
    if path.exists() and not path.is_file():
        raise ValueError('configuration is not a file')
    config = tomllib.loads(path.read_text(encoding='utf-8-sig')) if path.is_file() else {}
    agents = config.get('agents', {})
    if not isinstance(agents, dict):
        raise ValueError('invalid agents configuration')
    roles = []
    for path in sorted((root / '.codex/agents').glob('*.toml')):
        data = tomllib.loads(path.read_text(encoding='utf-8-sig'))
        # Only non-secret, bounded public role metadata is exposed.
        name = data.get('name')
        if not isinstance(name, str) or len(name) > 80:
            raise ValueError('invalid role name')
        registrations = (agents.get(name), agents.get(path.stem))
        roles.append({'role': name, 'file': path.name,
                      'registration_present': any(isinstance(item, dict) and isinstance(item.get('config_file'), str) and bool(item['config_file'].strip()) for item in registrations),
                      'runtime_consumed': 'unverified'})
    limits = {}
    for key in ('model_context_window', 'model_auto_compact_token_limit'):
        value = config.get(key)
        if value is not None and (type(value) is not int or value <= 0):
            raise ValueError('invalid context configuration')
        limits[key] = {'project_config_value': value, 'effective_runtime_value': 'unavailable'}
    return {'schema_version': 1, 'kind': 'static_inventory_not_live_readiness',
            'context': limits, 'roles': roles,
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
