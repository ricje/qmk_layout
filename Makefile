QMK ?= qmk
KEYMAP ?= ricje
QMK_HOME ?= /Users/ricje/qmk_firmware
QMK_BIN_DIR ?= /Users/ricje/.local/bin
ARM_GCC_BIN ?= /Applications/ArmGNUToolchain/15.2.rel1/arm-none-eabi/bin
DOCKER ?= docker
CI_RUNTIME ?= container
QMK_CI_IMAGE ?= ghcr.io/qmk/qmk_cli:latest
ARTIFACT_DIR ?= build/firmware
LAYOUT_ARTIFACT_DIR ?= build/layouts

ERGODOX_KEYBOARD ?= ergodox_ez
CRKBD_KEYBOARD ?= crkbd/rev4_1/standard
QMK_PATH := PATH=$(ARM_GCC_BIN):$(QMK_BIN_DIR):/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin

.PHONY: help \
	sync install compile flash clean \
	compile-all ci-build layout-artifacts \
	sync-ergodox install-ergodox compile-ergodox flash-ergodox clean-ergodox \
	sync-crkbd install-crkbd compile-crkbd flash-crkbd clean-crkbd

help:
	@printf "%s\n" \
		"Available targets:" \
		"  make compile         - alias for compile-ergodox" \
		"  make flash           - alias for flash-ergodox" \
		"  make clean           - alias for clean-ergodox" \
		"  make compile-all     - build all targets from qmk.json" \
		"  make ci-build        - build all targets in the GitHub Actions container" \
		"  make layout-artifacts - generate layout reference SVGs for all keyboards" \
		"  make compile-ergodox - build the ErgoDox firmware" \
		"  make flash-ergodox   - flash the ErgoDox firmware" \
		"  make clean-ergodox   - clean the ErgoDox build" \
		"  make compile-crkbd   - build the Corne firmware" \
		"  make flash-crkbd     - flash the Corne firmware" \
		"  make clean-crkbd     - clean the Corne build" \
		"" \
		"Optional variables:" \
		"  QMK=$(QMK)" \
		"  KEYMAP=$(KEYMAP)" \
		"  QMK_HOME=$(QMK_HOME)" \
		"  DOCKER=$(DOCKER)" \
		"  CI_RUNTIME=$(CI_RUNTIME)" \
		"  QMK_CI_IMAGE=$(QMK_CI_IMAGE)" \
		"  ARTIFACT_DIR=$(ARTIFACT_DIR)" \
		"  LAYOUT_ARTIFACT_DIR=$(LAYOUT_ARTIFACT_DIR)" \
		"  ERGODOX_KEYBOARD=$(ERGODOX_KEYBOARD)" \
		"  CRKBD_KEYBOARD=$(CRKBD_KEYBOARD)" \
		"  ARM_GCC_BIN=$(ARM_GCC_BIN)" \
		"" \
		"Examples:" \
		"  make compile-ergodox" \
		"  make compile-crkbd" \
		"  make compile-all" \
		"  make layout-artifacts" \
		"  make ci-build" \
		"  make ci-build CI_RUNTIME=container"

sync: sync-ergodox

install: install-ergodox

compile: compile-ergodox

flash: flash-ergodox

clean: clean-ergodox

sync-ergodox:
	@printf "%s\n" "No sync needed in QMK userspace mode."

install-ergodox: sync-ergodox

compile-ergodox:
	env $(QMK_PATH) $(QMK) compile -kb $(ERGODOX_KEYBOARD) -km $(KEYMAP)
	./scripts/store-artifacts.sh "$(ARTIFACT_DIR)" "ergodox_ez_base_$(KEYMAP).hex"
	QMK_HOME=$(QMK_HOME) ./scripts/generate-layout-artifacts.sh "$(LAYOUT_ARTIFACT_DIR)" ergodox "$(KEYMAP)"

flash-ergodox:
	env $(QMK_PATH) $(QMK) flash -kb $(ERGODOX_KEYBOARD) -km $(KEYMAP)

clean-ergodox:
	env $(QMK_PATH) $(QMK) clean -kb $(ERGODOX_KEYBOARD) -km $(KEYMAP)

sync-crkbd:
	@printf "%s\n" "No sync needed in QMK userspace mode."

install-crkbd: sync-crkbd

compile-crkbd:
	env $(QMK_PATH) QMK_HOME=$(QMK_HOME) $(QMK) compile -kb $(CRKBD_KEYBOARD) -km $(KEYMAP)
	./scripts/store-artifacts.sh "$(ARTIFACT_DIR)" "crkbd_rev4_1_standard_$(KEYMAP).uf2"
	QMK_HOME=$(QMK_HOME) ./scripts/generate-layout-artifacts.sh "$(LAYOUT_ARTIFACT_DIR)" crkbd "$(KEYMAP)"

flash-crkbd:
	env $(QMK_PATH) QMK_HOME=$(QMK_HOME) $(QMK) flash -kb $(CRKBD_KEYBOARD) -km $(KEYMAP)

clean-crkbd:
	env $(QMK_PATH) QMK_HOME=$(QMK_HOME) $(QMK) clean -kb $(CRKBD_KEYBOARD) -km $(KEYMAP)

compile-all:
	env $(QMK_PATH) QMK_HOME=$(QMK_HOME) $(QMK) userspace-compile
	./scripts/store-artifacts.sh "$(ARTIFACT_DIR)" \
		"ergodox_ez_base_$(KEYMAP).hex" \
		"crkbd_rev4_1_standard_$(KEYMAP).uf2"
	QMK_HOME=$(QMK_HOME) ./scripts/generate-layout-artifacts.sh "$(LAYOUT_ARTIFACT_DIR)" ergodox "$(KEYMAP)"
	QMK_HOME=$(QMK_HOME) ./scripts/generate-layout-artifacts.sh "$(LAYOUT_ARTIFACT_DIR)" crkbd "$(KEYMAP)"

layout-artifacts:
	QMK_HOME=$(QMK_HOME) ./scripts/generate-layout-artifacts.sh "$(LAYOUT_ARTIFACT_DIR)" ergodox "$(KEYMAP)"
	QMK_HOME=$(QMK_HOME) ./scripts/generate-layout-artifacts.sh "$(LAYOUT_ARTIFACT_DIR)" crkbd "$(KEYMAP)"

ci-build:
	./scripts/ci-build.sh "$(CI_RUNTIME)" "$(DOCKER)" "$(QMK_CI_IMAGE)"
