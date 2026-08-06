#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$repo_root"

sha256sum -c evidence/requirements.sha256
python3 -c 'import pathlib, tomllib; tomllib.loads(pathlib.Path("evidence/gates.toml").read_text())'
cargo metadata --no-deps --format-version 1 >/dev/null
sh -n tooling/smoke-test.sh

requirements_digest=$(sha256sum REQUIREMENTS.md | awk '{print $1}')
for report in research/architectures/A.md research/architectures/B.md research/architectures/C.md; do
    test -f "$report"
    test "$(sed -n 's/^requirements_digest: //p' "$report")" = "$requirements_digest"
    test "$(sed -n 's/^verdict: //p' "$report")" = "NO-GO"
done

git diff --check

