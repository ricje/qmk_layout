# Custom QMK Firmware for ErgoDox EZ and Corne

This repository contains a clean QMK port of your current Oryx configuration for `ergodox_ez`, without depending on the Oryx module.

It also contains an analogous `crkbd` keymap for a Corne v4.1, adapted from the ErgoDox layout and tuned with the same home-row mod strategy.

The `ricje` ErgoDox keymap keeps the behavior of your current layout:

- `BASE` with home-row mods
- `NAVIGATION` for numbers, arrows, and editing
- `SYMBOLS` for symbols
- `FUNCTION` for F-keys and modifier access
- two virtual desktop switching macros

The `crkbd` variant mirrors the same logic within a 3x6_3 layout and keeps:

- the same alpha block
- the same home-row mods
- the same `NAVIGATION`, `SYMBOLS`, and `FUNCTION` layers
- the same `DESKTOP_NEXT` and `DESKTOP_PREV` macros
- the same home-row mod tuning for `Alt`

## Structure

Copy one of these directories into a standard QMK checkout:

`ergodox_ez/keymaps/ricje`
`crkbd/keymaps/ricje`

Example:

```sh
cp -R ergodox_ez/keymaps/ricje ~/src/qmk_firmware/keyboards/ergodox_ez/keymaps/
cp -R crkbd/keymaps/ricje ~/src/qmk_firmware/keyboards/crkbd/rev4_1/standard/keymaps/
cd ~/src/qmk_firmware
qmk compile -kb ergodox_ez -km ricje
PATH=/Applications/ArmGNUToolchain/15.2.rel1/arm-none-eabi/bin:$PATH qmk compile -kb crkbd/rev4_1/standard -km ricje
```

Or from this repository:

```sh
make compile-ergodox
```

For the Corne:

```sh
make compile-crkbd
```

To flash:

```sh
qmk flash -kb ergodox_ez -km ricje
```

Or:

```sh
make flash-ergodox
```

For the Corne:

```sh
make flash-crkbd
```

The locally compiled firmware is written to:

`/Users/ricje/qmk_firmware/ergodox_ez_base_ricje.hex`
`/Users/ricje/qmk_firmware/crkbd_rev4_1_standard_ricje.uf2`

The `Makefile` uses this path by default through `QMK_HOME`, but you can override it:

```sh
make compile-ergodox QMK_HOME=$HOME/qmk_firmware
make compile-crkbd QMK_HOME=$HOME/qmk_firmware
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
