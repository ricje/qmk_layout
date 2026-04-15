#include QMK_KEYBOARD_H
#include "version.h"
#include "../../../../../../shared/ricje_common.h"

// clang-format off
const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
    [BASE] = LAYOUT_split_3x6_3_ex2(
        KC_DEL,  KC_Q,    KC_W,    KC_E,    KC_R,    KC_T,    OSM(MOD_MEH),         DESKTOP_NEXT, KC_Y,    KC_U,    KC_I,    KC_O,    KC_P,    KC_BSPC,
        KC_ESC,  HM_A,    HM_S,    HM_D,    HM_F,    KC_G,    OSM(MOD_HYPR),        DESKTOP_PREV, KC_H,    HM_J,    HM_K,    HM_L,    HM_SCLN, KC_QUOT,
        KC_LSFT, KC_Z,    KC_X,    KC_C,    KC_V,    KC_B,                           KC_N,         KC_M,    KC_COMM, KC_DOT,  KC_SLSH, KC_RSFT,
                                   KC_ESC,  TH_NAV,  KC_SPC,                         KC_ENT,       TH_SYM,  KC_TAB
    ),

    [NAVIGATION] = LAYOUT_split_3x6_3_ex2(
        KC_EQL,  KC_1,    KC_2,    KC_3,    KC_4,    KC_5,    XXX,                   KC_PAUS,      KC_6,    KC_7,    KC_8,    KC_9,    KC_0,    KC_MINS,
        ___,     KC_LGUI, KC_LALT, KC_LCTL, KC_LSFT, XXX,    XXX,                    XXX,          KC_LEFT, KC_DOWN, KC_UP,   KC_RGHT, KC_BSPC, XXX,
        ___,     XXX,     XXX,     XXX,     XXX,     XXX,                            KC_HOME,      KC_PGDN, KC_PGUP, KC_END,  KC_DEL,  ___,
                                   ___,     ___,     KC_SPC,                         KC_ENT,       ___,     ___
    ),

    [SYMBOLS] = LAYOUT_split_3x6_3_ex2(
        XXX,     KC_EXLM, KC_AT,   KC_HASH, KC_DLR,  KC_PERC, XXX,                   XXX,          KC_CIRC, KC_AMPR, KC_ASTR, KC_LPRN, KC_RPRN, KC_BSPC,
        ___,     KC_LGUI, KC_LALT, KC_LCTL, KC_LSFT, XXX,    XXX,                    XXX,          KC_MINS, KC_EQL,  KC_LBRC, KC_RBRC, KC_BSLS, KC_GRV,
        ___,     XXX,     XXX,     XXX,     XXX,     XXX,                            KC_UNDS,      KC_PLUS, KC_LCBR, KC_RCBR, KC_PIPE, KC_TILD,
                                   ___,     ___,     KC_SPC,                         KC_ENT,       ___,     ___
    ),

    [FUNCTION] = LAYOUT_split_3x6_3_ex2(
        XXX,     KC_F1,   KC_F2,   KC_F3,   KC_F4,   KC_F5,   DM_REC1,                        DM_PLY1,        KC_F6,   KC_F7,   KC_F8,   KC_F9,   KC_F10,  KC_F11,
        ___,     KC_LGUI, KC_LALT, KC_LCTL, KC_LSFT, XXX,     DM_REC2,                        DM_PLY2,        XXX,    KC_RSFT, KC_RCTL, KC_RALT, KC_RGUI, KC_F12,
        ___,     XXX,     XXX,     XXX,     XXX,     DM_RSTP,                                XXX,            XXX,    XXX,    XXX,    XXX,    XXX,
                                   ___,     ___,     KC_SPC,                                  KC_ENT,          ___,    ___
    ),
};
// clang-format on
