# Firmware QMK custom pour ErgoDox EZ (1re génération)

Ce dépôt contient maintenant un port QMK propre de ta configuration Oryx actuelle pour `ergodox_ez`, sans dépendance au module Oryx.

Le keymap `ricje` conserve le comportement de ton layout existant :

- `BASE` avec home-row mods
- `NAVIGATION` pour chiffres, flèches et édition
- `SYMBOLS` pour les symboles
- `FUNCTION` pour les touches F et modificateurs
- deux macros de changement de bureau virtuel

## Structure

Copiez le dossier suivant dans un checkout QMK standard :

`ergodox_ez/keymaps/ricje`

Exemple :

```sh
cp -R ergodox_ez/keymaps/ricje ~/src/qmk_firmware/keyboards/ergodox_ez/keymaps/
cd ~/src/qmk_firmware
qmk compile -kb ergodox_ez -km ricje
```

Pour flasher :

```sh
qmk flash -kb ergodox_ez -km ricje
```

Le firmware compilé localement se retrouve dans :

`/Users/ricje/qmk_firmware/ergodox_ez_base_ricje.hex`

## Notes

- Les layers `NAVIGATION` et `SYMBOLS` sont accessibles depuis les pouces.
- Les macros `DESKTOP_NEXT` et `DESKTOP_PREV` envoient `Alt+Ctrl+Right/Left`.
- Les LEDs de droite indiquent le layer actif comme dans ton export Oryx.

## Personnalisation

Le fichier principal est :

`ergodox_ez/keymaps/ricje/keymap.c`

Si vous voulez, l'étape suivante peut être de l'améliorer sans repartir de zéro :

- disposition FR / BEPO / US
- touches macOS ou Linux
- tuning des home-row mods
- layer gaming / dev
- macros
- combos
- tap dance
