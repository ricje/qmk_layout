# QMK Userspace for ErgoDox EZ and Corne

This repository is now structured as a standard QMK userspace.

It contains:

- `keyboards/ergodox_ez/keymaps/ricje`
- `keyboards/crkbd/rev4_1/standard/keymaps/ricje`
- `qmk.json` with the default build targets

The ErgoDox keymap is a clean QMK port of your previous Oryx configuration.

The Corne keymap is an analogous version adapted to `crkbd/rev4_1/standard` and tuned with the same home-row mod strategy.

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

Keymaps live in standard userspace paths:

`keyboards/ergodox_ez/keymaps/ricje`
`keyboards/crkbd/rev4_1/standard/keymaps/ricje`

Default build targets live in:

`qmk.json`

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

The locally compiled firmware is collected into:

`build/firmware/ergodox_ez_base_ricje.hex`
`build/firmware/crkbd_rev4_1_standard_ricje.uf2`

The generated layout references are collected into:

`build/layouts/ergodox/ricje.oryx-like.svg`
`build/layouts/crkbd/ricje.oryx-like.svg`
`build/layouts/ergodox/ricje.oryx-like.pdf`
`build/layouts/crkbd/ricje.oryx-like.pdf`

The `Makefile` uses this path by default through `QMK_HOME`, but you can override it:

```sh
make compile-ergodox QMK_HOME=$HOME/qmk_firmware
make compile-crkbd QMK_HOME=$HOME/qmk_firmware
make compile-all QMK_HOME=$HOME/qmk_firmware
```

To change where the collected firmware files are stored:

```sh
make compile-all ARTIFACT_DIR=out/firmware
```

To regenerate only the layout references:

```sh
make layout-artifacts
```

This requires `keymap-drawer` and `cairosvg` to be installed locally.

To build with the same container image used by GitHub Actions instead of your
host QMK installation:

```sh
make ci-build
```

This runs `ghcr.io/qmk/qmk_cli:latest`, clones `qmk/qmk_firmware` inside a
temporary workspace, points `qmk` at that checkout, and runs
`qmk userspace-compile`.

By default on macOS this uses Apple's `container` runtime. To force Docker
instead:

```sh
make ci-build CI_RUNTIME=docker
```

## Notes

- The `NAVIGATION` and `SYMBOLS` layers are accessible from the thumb cluster.
- `DESKTOP_NEXT` and `DESKTOP_PREV` send `Alt+Ctrl+Right/Left`.
- The right-side LEDs indicate the active layer, matching the original Oryx export.
- Home-row mods have been tuned in QMK to reduce accidental modifier activation while typing.

## CI

This repository includes a GitHub Actions workflow in:

`.github/workflows/qmk-ci.yml`

It builds the targets listed in `qmk.json` on every push to `main`, on pull requests, and on manual dispatch:

- `ergodox_ez:ricje`
- `crkbd/rev4_1/standard:ricje`

Successful runs upload the compiled firmware files as workflow artifacts.

## Customization

The main file is:

`keyboards/ergodox_ez/keymaps/ricje/keymap.c`

Good next steps if you want to keep evolving this layout:

- FR / BEPO / US layout changes
- macOS or Linux specific behavior
- further home-row mod tuning
- gaming or dev-specific layers
- macros
- combos
- tap dance
