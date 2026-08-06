#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$repo_root"

sha256sum -c evidence/architecture-gate.sha256
python3 -c 'import pathlib, tomllib; d = tomllib.loads(pathlib.Path("evidence/architecture-gate.toml").read_text()); assert d["result"] == "BLOCKED_NO_WINNER"; assert d["submissions"] == 3; assert d["survivors"] == 0; assert not d["primitive_tournament_started"]; assert not d["spec_digest_issued"]; assert not d["cipher_released"]'
git diff --check

