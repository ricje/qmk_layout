#!/bin/sh

set -eu

output_dir="${1:?output directory is required}"
keymap="${2:?keymap is required}"
shift 2

if [ "$#" -eq 0 ]; then
	printf "%s\n" "At least one keyboard is required." >&2
	exit 1
fi

qmk="${QMK:-qmk}"
root_compile_commands="compile_commands.json"

mkdir -p "$output_dir"
rm -f "$output_dir"/*.compile_commands.json

for keyboard in "$@"; do
	safe_keyboard=$(printf "%s" "$keyboard" | tr '/:' '__')
	printf "Generating clangd compilation database for %s:%s\n" "$keyboard" "$keymap"
	"$qmk" compile --compiledb -kb "$keyboard" -km "$keymap"
	cp "$root_compile_commands" "$output_dir/$safe_keyboard.compile_commands.json"
done

python3 - "$root_compile_commands" "$output_dir"/*.compile_commands.json <<'PY'
import json
import sys
from pathlib import Path

output_path = Path(sys.argv[1])
input_paths = [Path(path) for path in sys.argv[2:]]

merged = []
for input_path in input_paths:
    with input_path.open() as handle:
        merged.extend(json.load(handle))

with output_path.open("w") as handle:
    json.dump(merged, handle, indent=4)
    handle.write("\n")

print(f"Wrote {len(merged)} compile commands to {output_path}")
PY
