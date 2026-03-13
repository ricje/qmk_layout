#include QMK_KEYBOARD_H
#include "version.h"

enum layers {
    BASE,
    NAVIGATION,
    SYMBOLS,
    FUNCTION,
};

enum custom_keycodes {
    DESKTOP_NEXT = SAFE_RANGE,
    DESKTOP_PREV,
};

// Short aliases keep the matrix readable without changing behavior.
#define ___ KC_TRNS
#define XXX KC_NO

// Home-row mods on the base layer.
#define HM_A GUI_T(KC_A)
#define HM_S ALT_T(KC_S)
#define HM_D CTL_T(KC_D)
#define HM_F SFT_T(KC_F)
#define HM_J RSFT_T(KC_J)
#define HM_K RCTL_T(KC_K)
#define HM_L RALT_T(KC_L)
#define HM_SCLN RGUI_T(KC_SCLN)

// Thumb cluster access points.
#define TH_NAV MO(NAVIGATION)
#define TH_SYM MO(SYMBOLS)
#define TH_FN MO(FUNCTION)

static bool is_home_row_mod(uint16_t keycode) {
    switch (keycode) {
        case HM_A:
        case HM_S:
        case HM_D:
        case HM_F:
        case HM_J:
        case HM_K:
        case HM_L:
        case HM_SCLN:
            return true;
        default:
            return false;
    }
}

static bool is_alt_home_row_mod(uint16_t keycode) {
    switch (keycode) {
        case HM_S:
        case HM_L:
            return true;
        default:
            return false;
    }
}

static bool is_vim_repeat_home_row_mod(uint16_t keycode) {
    switch (keycode) {
        case HM_A:
        case HM_S:
        case HM_D:
        case HM_F:
        case HM_J:
        case HM_K:
        case HM_L:
        case HM_SCLN:
            return true;
        default:
            return false;
    }
}

// clang-format off
const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
    // Base layer with home-row mods and thumb access to navigation/symbol layers.
    [BASE] = LAYOUT_ergodox_pretty(
        ___,     ___,     ___,     ___,     ___,     ___,     ___,                                   ___,        ___,               ___,               ___,               ___,               ___,     ___,
        KC_DEL,  KC_Q,    KC_W,    KC_E,    KC_R,    KC_T,    KC_MEH,                                DESKTOP_NEXT, KC_Y,            KC_U,              KC_I,              KC_O,              KC_P,    KC_BSPC,
        KC_ESC,  HM_A,    HM_S,    HM_D,    HM_F,    KC_G,                                       KC_H,              HM_J,             HM_K,             HM_L,             HM_SCLN, KC_QUOT,
        KC_LSFT, KC_Z,    KC_X,    KC_C,    KC_V,    KC_B,    KC_HYPR,                               DESKTOP_PREV, KC_N,            KC_M,              KC_COMM,           KC_DOT,            KC_SLSH, KC_RSFT,
        ___,     ___,     ___,     KC_ESC,  TH_NAV,                                                             TH_SYM,           KC_TAB,            ___,               ___,               ___,
                                                     ___,     ___,     ___,                ___,
                                                              ___,     ___,
                                   KC_SPC,  ___,     ___,                ___,     ___,     KC_ENT
    ),

    // Numbers on the left, arrows/navigation on the right.
    [NAVIGATION] = LAYOUT_ergodox_pretty(
        ___,     ___,     ___,     ___,     ___,     ___,     ___,                                   ___,     ___,     ___,     ___,     ___,     ___,     ___,
        KC_EQL,  KC_1,    KC_2,    KC_3,    KC_4,    KC_5,    XXX,                                   KC_PAUS, KC_6,    KC_7,    KC_8,    KC_9,    KC_0,    KC_MINS,
        ___,     KC_LGUI, KC_LALT, KC_LCTL, KC_LSFT, XXX,                                                        KC_LEFT, KC_DOWN, KC_UP,   KC_RGHT, KC_BSPC, XXX,
        ___,     ___,     XXX,     XXX,     XXX,     XXX,     XXX,                                   ___,     KC_HOME, KC_PGDN, KC_PGUP, KC_END,  KC_DEL,  ___,
        ___,     ___,     ___,     ___,     ___,                                                                TH_FN,   ___,     ___,     ___,     ___,
                                                     ___,     ___,     ___,                ___,
                                                              ___,     ___,
                                   ___,     ___,     ___,                ___,     ___,     ___
    ),

    // Symbols and brackets, mirroring the Oryx layout.
    [SYMBOLS] = LAYOUT_ergodox_pretty(
        ___,     ___,      ___,      ___,      ___,      ___,      ___,                                   ___,     ___,           ___,           ___,            ___,            ___,           ___,
        XXX,     KC_EXLM,  KC_AT,    KC_HASH,  KC_DLR,   KC_PERC,  XXX,                                   ___,     KC_CIRC,       KC_AMPR,       KC_ASTR,        KC_LPRN,        KC_RPRN,       ___,
        ___,     KC_LGUI,  KC_LALT,  KC_LCTL,  KC_LSFT,  ___,                                                          KC_MINS,       KC_EQL,        KC_LBRC,        KC_RBRC,        KC_BSLS,       KC_GRV,
        ___,     XXX,      XXX,      XXX,      XXX,      ___,      XXX,                                   ___,     KC_UNDS,       KC_PLUS,       KC_LCBR,        KC_RCBR,        KC_PIPE,       KC_TILD,
        ___,     ___,      ___,      ___,      TH_FN,                                                                   ___,           ___,           ___,            ___,            ___,
                                                         ___,     ___,     ___,                ___,
                                                                  ___,     ___,
                                   ___,      ___,     ___,                ___,     ___,     ___
    ),

    // Function row and modifier access.
    [FUNCTION] = LAYOUT_ergodox_pretty(
        ___,     ___,     ___,     ___,     ___,     ___,     ___,                                   ___,     ___,     ___,        ___,        ___,        ___,     ___,
        XXX,     KC_F1,   KC_F2,   KC_F3,   KC_F4,   KC_F5,   ___,                                   ___,     KC_F6,   KC_F7,      KC_F8,      KC_F9,      KC_F10,  KC_F11,
        ___,     KC_LGUI, KC_LALT, KC_LCTL, KC_LSFT, ___,                                                        XXX,     KC_RSFT,    KC_RCTL,    KC_RALT,    KC_RGUI, KC_F12,
        ___,     ___,     ___,     ___,     ___,     ___,     ___,                                   ___,     XXX,     XXX,        XXX,        XXX,        XXX,     XXX,
        ___,     ___,     ___,     ___,     ___,                                                                ___,     ___,        ___,        ___,        ___,
                                                     ___,     ___,     ___,                ___,
                                                              ___,     ___,
                                   ___,     ___,     ___,                ___,     ___,     ___
    ),
};
// clang-format on

uint16_t get_tapping_term(uint16_t keycode, keyrecord_t *record) {
    if (is_alt_home_row_mod(keycode)) {
        return 140;
    }

    if (is_home_row_mod(keycode)) {
        return 170;
    }

    return TAPPING_TERM;
}

uint16_t get_quick_tap_term(uint16_t keycode, keyrecord_t *record) {
    if (is_vim_repeat_home_row_mod(keycode)) {
        return TAPPING_TERM;
    }

    if (is_home_row_mod(keycode)) {
        return 0;
    }

    return QUICK_TAP_TERM;
}

bool get_hold_on_other_key_press(uint16_t keycode, keyrecord_t *record) {
    return is_home_row_mod(keycode) && !is_alt_home_row_mod(keycode);
}

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
    if (!record->event.pressed) {
        return true;
    }

    switch (keycode) {
        case DESKTOP_NEXT:
            SEND_STRING(SS_LALT(SS_LCTL(SS_TAP(X_RIGHT))));
            return false;
        case DESKTOP_PREV:
            SEND_STRING(SS_LALT(SS_LCTL(SS_TAP(X_LEFT))));
            return false;
        default:
            return true;
    }
}

layer_state_t layer_state_set_user(layer_state_t state) {
    uint8_t layer = get_highest_layer(state);

    ergodox_board_led_off();
    ergodox_right_led_1_off();
    ergodox_right_led_2_off();
    ergodox_right_led_3_off();

    switch (layer) {
        case NAVIGATION:
            ergodox_right_led_1_on();
            break;
        case SYMBOLS:
            ergodox_right_led_2_on();
            break;
        case FUNCTION:
            ergodox_right_led_3_on();
            break;
        default:
            break;
    }

    return state;
}
