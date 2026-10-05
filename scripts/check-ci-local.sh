#!/usr/bin/env bash
# Render every stack. Does not start containers.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT}"

if ! command -v docker >/dev/null 2>&1; then
  echo "docker is required" >&2
  exit 1
fi

fail=0
for app in apps/*; do
  name="$(basename "${app}")"
  env_file="tests/${name}.env"
  if [[ ! -f "${env_file}" ]]; then
    echo "missing ${env_file}" >&2
    fail=1
    continue
  fi
  echo "==> ${name}"
  if ! docker compose --env-file "${env_file}" -f "${app}/compose.yaml" config --quiet; then
    fail=1
  fi
done

if [[ "${fail}" -ne 0 ]]; then
  exit 1
fi
echo "compose config passed"
