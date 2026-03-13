#!/bin/sh

set -eu

runtime="${1:-docker}"
docker_bin="${2:-docker}"
image="${3:-ghcr.io/qmk/qmk_cli:latest}"
repo_root="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
work_root="$(mktemp -d "${TMPDIR:-/tmp}/qmk-ci.XXXXXX")"

cleanup() {
	rm -rf "$work_root"
}

trap cleanup EXIT INT TERM

printf '%s\n' "Using QMK CI image: $image"
printf '%s\n' "Using container runtime: $runtime"
printf '%s\n' "Preparing temporary QMK firmware checkout in: $work_root"

case "$runtime" in
docker)
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
	;;
container)
	container run --rm \
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
	;;
*)
	printf '%s\n' "Unsupported CI runtime: $runtime" >&2
	exit 2
	;;
esac
