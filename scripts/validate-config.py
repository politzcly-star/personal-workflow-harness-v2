"""Static canonical configuration validation, not a live provider/role probe."""
from pathlib import Path
import json
import re
import tomllib

root = Path(__file__).resolve().parents[1]
config = tomllib.loads((root/'.codex/config.toml').read_text(encoding='utf-8-sig'))
manifest_path = root/'.codex/harness-owned.json'
if manifest_path.exists():
    manifest = json.loads(manifest_path.read_text(encoding='utf-8-sig'))
    assert isinstance(manifest, dict) and set(manifest) == {'version', 'files'}, 'invalid ownership manifest schema'
    assert type(manifest['version']) is int and manifest['version'] == 1 and isinstance(manifest['files'], dict) and manifest['files'], 'invalid ownership manifest version/files'
    for path, digest in manifest['files'].items():
        assert isinstance(path, str) and not Path(path).is_absolute() and '\\' not in path and ':' not in path and '..' not in path.split('/'), 'invalid ownership path'
        assert isinstance(digest, str) and re.fullmatch('[0-9a-f]{64}', digest), 'invalid ownership hash'
else:
    assert 'model' not in config and 'model_reasoning_effort' not in config, 'canonical config must inherit root choice'
assert config['agents']['max_threads'] == 4 and config['agents']['max_depth'] == 1
for name in ('luna-qa', 'terra-worker', 'luna-verifier', 'sol-planner'):
    role = tomllib.loads((root/f'.codex/agents/{name}.toml').read_text(encoding='utf-8-sig'))
    assert role['name'] and role['description'] and role['model'] and role['developer_instructions']
    assert role['sandbox_mode'] == ('workspace-write' if name == 'terra-worker' else 'read-only')
print('[OK] TOML and optional role boundaries valid (not live routing proof)')
