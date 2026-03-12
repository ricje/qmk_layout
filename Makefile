QMK_HOME ?= /Users/ricje/qmk_firmware
KEYBOARD ?= ergodox_ez
KEYMAP ?= ricje
KEYMAP_SRC := ergodox_ez/keymaps/$(KEYMAP)
KEYMAP_DST := $(QMK_HOME)/keyboards/$(KEYBOARD)/keymaps/$(KEYMAP)
FIRMWARE := $(QMK_HOME)/$(KEYBOARD)_base_$(KEYMAP).hex

.PHONY: help sync install compile flash clean

help:
	@printf "%s\n" \
		"Available targets:" \
		"  make sync     - copy the keymap into qmk_firmware" \
		"  make install  - alias for sync" \
		"  make compile  - copy and compile the firmware" \
		"  make flash    - copy and flash the firmware" \
		"  make clean    - remove QMK build artifacts" \
		"" \
		"Optional variables:" \
		"  QMK_HOME=$(QMK_HOME)" \
		"  KEYBOARD=$(KEYBOARD)" \
		"  KEYMAP=$(KEYMAP)" \
		"" \
		"Examples:" \
		"  make compile" \
		"  make flash QMK_HOME=$$HOME/qmk_firmware"

sync:
	rsync -a $(KEYMAP_SRC)/ $(KEYMAP_DST)/

install: sync

compile: sync
	cd $(QMK_HOME) && qmk compile -kb $(KEYBOARD) -km $(KEYMAP)

flash: sync
	cd $(QMK_HOME) && qmk flash -kb $(KEYBOARD) -km $(KEYMAP)

clean:
	cd $(QMK_HOME) && qmk clean -kb $(KEYBOARD) -km $(KEYMAP)
