#!/usr/bin/env bash
set -euo pipefail
repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
versions=$(sed -nE 's|.*ghcr.io/laxxx-lab/lx-family-planner:([0-9]+\.[0-9]+\.[0-9]+)"[[:space:]]*$|\1|p' "$repo_dir/lx-family/build.yaml")
if [ "$(printf '%s\n' "$versions" | wc -l)" -ne 2 ] || [ "$(printf '%s\n' "$versions" | sort -u | wc -l)" -ne 1 ]; then
  echo 'Ungültige oder unterschiedliche Upstream-Versionen in build.yaml' >&2
  exit 1
fi
printf '%s\n' "$versions" | head -n1
