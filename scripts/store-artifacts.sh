#!/bin/sh

set -eu

artifact_dir="${1:?artifact directory is required}"
shift

mkdir -p "$artifact_dir"

for artifact_name in "$@"; do
	if [ -f "$artifact_name" ]; then
		mv -f "$artifact_name" "$artifact_dir/$artifact_name"
	fi
done
