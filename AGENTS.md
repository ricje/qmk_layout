# Repository Notes

## Build Strategy

- Prefer native local builds for fast validation.
- Use `make compile-ergodox`, `make compile-crkbd`, or `make compile-all` by default.
- Use `make ci-build` only when parity with GitHub Actions matters.
- `ci-build` defaults to Apple's `container` runtime on macOS.
- Docker remains available via `make ci-build CI_RUNTIME=docker`.

## QMK Environment

- Default local QMK checkout path is `QMK_HOME=/Users/ricje/qmk_firmware`.
- Native build commands should pass `QMK_HOME` through when required.
- Layout artifact generation depends on `QMK_HOME` to find local QMK `info.json` files.

## Build Artifacts

- Do not leave generated firmware files in the repository root.
- Local firmware artifacts belong in `build/<keyboard>/`.
- Local layout reference artifacts belong in `build/<keyboard>/docs/`.
- `build/` should not be committed.

## Layout References

- Layout references are generated for both keyboards:
  - ErgoDox EZ
  - Corne (`crkbd/rev4_1/standard`)
- The canonical style is `oryx-like`.
- Generate them with `make layout-artifacts` or as part of native compile targets.
- Generated files include:
  - `.keymap.json`
  - `.oryx-like.yaml`
  - `.oryx-like.svg`
  - `.oryx-like.pdf`

## Rendering Details

- Use `keymap-drawer` to build layout references.
- Use `cairosvg` to convert SVG outputs to PDF.
- The ErgoDox reference should keep unused positions visible as ghost keys.
- The Corne reference currently has no always-empty positions to ghost.

## Home Row Mod Behavior

- Both ErgoDox and Corne should preserve quick-tap repeat on all home-row mods:
  - `A/S/D/F`
  - `J/K/L/;`
- Double-tap behavior should favor tap/repeat instead of hold for those keys.

## GitHub Actions

- The workflow builds targets from `qmk.json`.
- The ErgoDox artifact filename must match `ergodox_ez_base_ricje*.hex`.
- CI should also generate and upload layout artifacts (`.svg` and `.pdf`).
- `release-on-layout-change.yml` is the publishing workflow for `main`.
- Releases use CalVer tags in the form `YYYY.MM.DD` or `YYYY.MM.DD.N`.
- Automatic releases should only trigger when layout-related files change:
  - `keyboards/**/keymaps/ricje/**`
  - `qmk.json`
  - `scripts/generate-layout-artifacts.sh`

## Editing Guidance

- Keep repository instructions pragmatic and minimal.
- Prefer adding automation to scripts/Makefile rather than documenting manual multi-step flows.
- If changing layout generation, keep local and CI behavior aligned.
