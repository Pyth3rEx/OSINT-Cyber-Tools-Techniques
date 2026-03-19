#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root_dir="$(cd "${script_dir}/.." && pwd)"

upstream_dir="${KALI_LIVE_DIR:-${root_dir}/upstream/live-build-config}"
upstream_url="${KALI_LIVE_URL:-https://gitlab.com/kalilinux/build-scripts/live-build-config.git}"

if [[ -d "${upstream_dir}/.git" ]]; then
    printf 'Using existing upstream checkout: %s\n' "${upstream_dir}"
    exit 0
fi

if [[ -e "${upstream_dir}" && ! -d "${upstream_dir}/.git" ]]; then
    printf 'Refusing to bootstrap into a non-git path: %s\n' "${upstream_dir}" >&2
    exit 1
fi

mkdir -p "$(dirname "${upstream_dir}")"
git clone "${upstream_url}" "${upstream_dir}"
