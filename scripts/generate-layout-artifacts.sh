#!/bin/sh

set -eu

artifact_root="${1:?artifact root is required}"
keyboard="${2:?keyboard slug is required}"
keymap_name="${3:?keymap name is required}"

require_command() {
	if ! command -v "$1" >/dev/null 2>&1; then
		printf '%s\n' "Missing required command: $1" >&2
		exit 1
	fi
}

require_command keymap
require_command qmk
require_command cairosvg

repo_root="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
qmk_home="${QMK_HOME:-$HOME/qmk_firmware}"
tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/layout-artifacts.XXXXXX")"
cleanup() {
	rm -rf "$tmp_dir"
}
trap cleanup EXIT INT TERM

case "$keyboard" in
ergodox)
	qmk_keyboard="ergodox_ez"
	qmk_draw_info="$qmk_home/keyboards/ergodox_ez/info.json"
	keymap_path="$repo_root/keyboards/ergodox_ez/keymaps/$keymap_name/keymap.c"
	layout_name="LAYOUT_ergodox_pretty"
	output_dir="$artifact_root/ergodox/docs"
	ghost_keys="0 1 2 3 4 5 6 7 8 9 10 11 12 13 54 55 56 61 62 63 64 65 66 67 68 69 71 72 73 74"
	footer_text="ErgoDox EZ $keymap_name layout"
	;;
crkbd)
	qmk_keyboard="crkbd/rev4_1/standard"
	qmk_draw_info="$qmk_home/keyboards/crkbd/rev4_1/info.json"
	keymap_path="$repo_root/keyboards/crkbd/rev4_1/standard/keymaps/$keymap_name/keymap.c"
	layout_name="LAYOUT_split_3x6_3"
	output_dir="$artifact_root/crkbd/docs"
	ghost_keys=""
	footer_text="Corne $keymap_name layout"
	;;
*)
	printf '%s\n' "Unsupported keyboard slug: $keyboard" >&2
	exit 2
	;;
esac

mkdir -p "$output_dir"

json_out="$output_dir/$keymap_name.keymap.json"
yaml_out="$output_dir/$keymap_name.oryx-like.yaml"
svg_out="$output_dir/$keymap_name.oryx-like.svg"
pdf_out="$output_dir/$keymap_name.oryx-like.pdf"
config_path="$tmp_dir/keymap-drawer.config.yaml"

cat >"$config_path" <<'EOF'
draw_config:
  append_colon_to_layer_header: false
  footer_text: __FOOTER_TEXT__
  shrink_wide_legends: 6
  svg_extra_style: |
    svg.keymap {
      font-family: "Avenir Next", "Inter", sans-serif;
      fill: #1f2937;
      background: linear-gradient(180deg, #fff7ed 0%, #fffaf5 100%);
    }
    rect.key {
      fill: #fffaf5;
      stroke: #f59e0b;
      stroke-width: 1.4;
    }
    rect.held, rect.combo.held {
      fill: #fde68a;
    }
    rect.combo, rect.combo-separate {
      fill: #fed7aa;
    }
    rect.ghost, rect.combo.ghost {
      fill: #b45309;
      fill-opacity: 0.05;
      stroke: #b45309;
      stroke-opacity: 0.25;
      stroke-dasharray: 3 5;
      stroke-width: 1.3;
    }
    rect.key.ghost + text,
    g.key.ghost text {
      fill-opacity: 0;
    }
    text.label {
      fill: #b45309;
      font-weight: 800;
      letter-spacing: 0.08em;
    }

parse_config:
  layer_legend_map:
    BASE: Base
    NAVIGATION: Nav
    SYMBOLS: Sym
    FUNCTION: Fn
  qmk_keycode_map:
    COMM: ","
    DOT: "."
    SLSH: "/"
    EQL: "="
    MINS: "-"
    EXLM: "!"
    AT: "@"
    HASH: "#"
    DLR: "$"
    PERC: "%"
    CIRC: "^"
    AMPR: "&"
    ASTR: "*"
    LPRN: "("
    RPRN: ")"
    LBRC: "["
    RBRC: "]"
    BSLS: "\\"
    GRV: "`"
    UNDS: "_"
    PLUS: "+"
    LCBR: "{"
    RCBR: "}"
    PIPE: "|"
    TILD: "~"
    BSPC: Bksp
    DEL: Del
    ESC: Esc
    ENT: Enter
    TAB: Tab
    SPC: Space
    QUOT: "'"
    LSFT: Shift
    RSFT: Shift
    LALT: Alt
    RALT: Alt
    LCTL: Ctrl
    RCTL: Ctrl
    LGUI: Gui
    RGUI: Gui
    PGUP: PgUp
    PGDN: PgDn
    RGHT: Right
    LEFT: Left
    DOWN: Down
    UP: Up
    HOME: Home
    END: End
    PAUS: Pause
    MEH: Meh
    HYPR: Hyper
  raw_binding_map:
    XXX: ""
    HM_A: {t: A, h: Gui}
    HM_S: {t: S, h: Alt}
    HM_D: {t: D, h: Ctrl}
    HM_F: {t: F, h: Shift}
    HM_J: {t: J, h: Shift}
    HM_K: {t: K, h: Ctrl}
    HM_L: {t: L, h: Alt}
    HM_SCLN: {t: ";", h: Gui}
    TH_NAV: {t: Nav}
    TH_SYM: {t: Sym}
    TH_FN: {t: Fn}
    DESKTOP_NEXT: {t: Desk, h: "->"}
    DESKTOP_PREV: {t: Desk, h: "<-"}
EOF

python3 - "$config_path" "$footer_text" <<'PY'
from pathlib import Path
import sys

config_path = Path(sys.argv[1])
footer_text = sys.argv[2]
config_path.write_text(config_path.read_text().replace("__FOOTER_TEXT__", f"{footer_text} · Oryx-like"))
PY

qmk c2json "$keymap_path" -kb "$qmk_keyboard" -km "$keymap_name" --no-cpp -o "$json_out"
keymap -c "$config_path" parse -q "$json_out" -l BASE NAVIGATION SYMBOLS FUNCTION -o "$yaml_out"

if [ -n "$ghost_keys" ]; then
	# shellcheck disable=SC2086
	keymap -c "$config_path" draw -j "$qmk_draw_info" -l "$layout_name" -g $ghost_keys -o "$svg_out" "$yaml_out"
else
	keymap -c "$config_path" draw -j "$qmk_draw_info" -l "$layout_name" -o "$svg_out" "$yaml_out"
fi

cairosvg "$svg_out" -o "$pdf_out"
