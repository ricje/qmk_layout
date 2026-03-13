#!/bin/sh

set -eu

docker_bin="${1:-docker}"
image="${2:-ghcr.io/qmk/qmk_cli:latest}"
repo_root="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
work_root="$(mktemp -d "${TMPDIR:-/tmp}/qmk-ci.XXXXXX")"

cleanup() {
	rm -rf "$work_root"
}

trap cleanup EXIT INT TERM

printf '%s\n' "Using QMK CI image: $image"
printf '%s\n' "Preparing temporary QMK firmware checkout in: $work_root"

"$docker_bin" run --rm \
	-v "$repo_root:/workspace/userspace" \
	-v "$work_root:/tmp/qmk-ci" \
	-w /workspace/userspace \
		"$image" \
		bash -lc '
			set -euo pipefail
			qmk_bin=/opt/uv/tools/qmk/bin/qmk
			git clone --depth=1 --branch master --recurse-submodules https://github.com/qmk/qmk_firmware.git /tmp/qmk-ci/qmk_firmware
			"$qmk_bin" config user.qmk_home="/tmp/qmk-ci/qmk_firmware"
			"$qmk_bin" userspace-compile
		'
