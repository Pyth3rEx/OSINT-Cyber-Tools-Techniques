#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root_dir="$(cd "${script_dir}/.." && pwd)"
upstream_dir="${KALI_LIVE_DIR:-${root_dir}/upstream/live-build-config}"

"${script_dir}/sync-config.sh"

cd "${upstream_dir}"
./build.sh --verbose --installer "$@"
