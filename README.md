# Custom QMK Firmware for ErgoDox EZ (1st generation)

This repository contains a clean QMK port of your current Oryx configuration for `ergodox_ez`, without depending on the Oryx module.

The `ricje` keymap keeps the behavior of your current layout:

- `BASE` with home-row mods
- `NAVIGATION` for numbers, arrows, and editing
- `SYMBOLS` for symbols
- `FUNCTION` for F-keys and modifier access
- two virtual desktop switching macros

## Structure

Copy this directory into a standard QMK checkout:

`ergodox_ez/keymaps/ricje`

Example:

```sh
cp -R ergodox_ez/keymaps/ricje ~/src/qmk_firmware/keyboards/ergodox_ez/keymaps/
cd ~/src/qmk_firmware
qmk compile -kb ergodox_ez -km ricje
```

Or from this repository:

```sh
make compile
```

To flash:

```sh
qmk flash -kb ergodox_ez -km ricje
```

Or:

```sh
make flash
```

The locally compiled firmware is written to:

`/Users/ricje/qmk_firmware/ergodox_ez_base_ricje.hex`

The `Makefile` uses this path by default through `QMK_HOME`, but you can override it:

```sh
make compile QMK_HOME=$HOME/qmk_firmware
```

## Notes

- The `NAVIGATION` and `SYMBOLS` layers are accessible from the thumb cluster.
- `DESKTOP_NEXT` and `DESKTOP_PREV` send `Alt+Ctrl+Right/Left`.
- The right-side LEDs indicate the active layer, matching the original Oryx export.
- Home-row mods have been tuned in QMK to reduce accidental modifier activation while typing.

## Customization

The main file is:

`ergodox_ez/keymaps/ricje/keymap.c`

Good next steps if you want to keep evolving this layout:

- FR / BEPO / US layout changes
- macOS or Linux specific behavior
- further home-row mod tuning
- gaming or dev-specific layers
- macros
- combos
- tap dance
