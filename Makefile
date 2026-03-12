QMK_HOME ?= /Users/ricje/qmk_firmware
KEYMAP ?= ricje
ARM_GCC_BIN ?= /Applications/ArmGNUToolchain/15.2.rel1/arm-none-eabi/bin
QMK_BIN_DIR ?= /Users/ricje/.local/bin
ERGODOX_KEYBOARD ?= ergodox_ez
ERGODOX_KEYMAP_SRC := ergodox_ez/keymaps/$(KEYMAP)
ERGODOX_KEYMAP_DST := $(QMK_HOME)/keyboards/$(ERGODOX_KEYBOARD)/keymaps/$(KEYMAP)
ERGODOX_FIRMWARE := $(QMK_HOME)/$(ERGODOX_KEYBOARD)_base_$(KEYMAP).hex
CRKBD_KEYBOARD ?= crkbd/rev4_1/standard
CRKBD_KEYMAP_SRC := crkbd/keymaps/$(KEYMAP)
CRKBD_KEYMAP_DST := $(QMK_HOME)/keyboards/$(CRKBD_KEYBOARD)/keymaps/$(KEYMAP)
CRKBD_FIRMWARE := $(QMK_HOME)/crkbd_rev4_1_standard_$(KEYMAP).uf2
CRKBD_PATH := PATH=$(ARM_GCC_BIN):$(QMK_BIN_DIR):/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin

.PHONY: help \
	sync install compile flash clean \
	sync-ergodox install-ergodox compile-ergodox flash-ergodox clean-ergodox \
	sync-crkbd install-crkbd compile-crkbd flash-crkbd clean-crkbd

help:
	@printf "%s\n" \
		"Available targets:" \
		"  make sync            - alias for sync-ergodox" \
		"  make install         - alias for install-ergodox" \
		"  make compile         - alias for compile-ergodox" \
		"  make flash           - alias for flash-ergodox" \
		"  make clean           - alias for clean-ergodox" \
		"  make sync-ergodox    - copy the ErgoDox keymap into qmk_firmware" \
		"  make install-ergodox - alias for sync-ergodox" \
		"  make compile-ergodox - copy and compile the ErgoDox firmware" \
		"  make flash-ergodox   - copy and flash the ErgoDox firmware" \
		"  make clean-ergodox   - remove ErgoDox build artifacts" \
		"  make sync-crkbd    - copy the Corne keymap into qmk_firmware" \
		"  make install-crkbd - alias for sync-crkbd" \
		"  make compile-crkbd - copy and compile the Corne firmware" \
		"  make flash-crkbd   - copy and flash the Corne firmware" \
		"  make clean-crkbd   - remove Corne build artifacts" \
		"" \
		"Optional variables:" \
		"  QMK_HOME=$(QMK_HOME)" \
		"  KEYMAP=$(KEYMAP)" \
		"  ERGODOX_KEYBOARD=$(ERGODOX_KEYBOARD)" \
		"  CRKBD_KEYBOARD=$(CRKBD_KEYBOARD)" \
		"  ARM_GCC_BIN=$(ARM_GCC_BIN)" \
		"" \
		"Examples:" \
		"  make compile-ergodox" \
		"  make flash-ergodox QMK_HOME=$$HOME/qmk_firmware" \
		"  make compile-crkbd" \
		"  make flash-crkbd"

sync: sync-ergodox

install: install-ergodox

compile: compile-ergodox

flash: flash-ergodox

clean: clean-ergodox

sync-ergodox:
	rsync -a $(ERGODOX_KEYMAP_SRC)/ $(ERGODOX_KEYMAP_DST)/

install-ergodox: sync-ergodox

compile-ergodox: sync-ergodox
	cd $(QMK_HOME) && qmk compile -kb $(ERGODOX_KEYBOARD) -km $(KEYMAP)

flash-ergodox: sync-ergodox
	cd $(QMK_HOME) && qmk flash -kb $(ERGODOX_KEYBOARD) -km $(KEYMAP)

clean-ergodox:
	cd $(QMK_HOME) && qmk clean -kb $(ERGODOX_KEYBOARD) -km $(KEYMAP)

sync-crkbd:
	rsync -a $(CRKBD_KEYMAP_SRC)/ $(CRKBD_KEYMAP_DST)/

install-crkbd: sync-crkbd

compile-crkbd: sync-crkbd
	cd $(QMK_HOME) && env $(CRKBD_PATH) qmk compile -kb $(CRKBD_KEYBOARD) -km $(KEYMAP)

flash-crkbd: sync-crkbd
	cd $(QMK_HOME) && env $(CRKBD_PATH) qmk flash -kb $(CRKBD_KEYBOARD) -km $(KEYMAP)

clean-crkbd:
	cd $(QMK_HOME) && env $(CRKBD_PATH) qmk clean -kb $(CRKBD_KEYBOARD) -km $(KEYMAP)
