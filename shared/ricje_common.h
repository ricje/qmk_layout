#pragma once

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

#define ___ KC_TRNS
#define XXX KC_NO

#define HM_A GUI_T(KC_A)
#define HM_S ALT_T(KC_S)
#define HM_D CTL_T(KC_D)
#define HM_F SFT_T(KC_F)
#define HM_J RSFT_T(KC_J)
#define HM_K LCTL_T(KC_K)
#define HM_L LALT_T(KC_L)
#define HM_SCLN RGUI_T(KC_SCLN)

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

static bool is_shift_home_row_mod(uint16_t keycode) {
    switch (keycode) {
        case HM_F:
        case HM_J:
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

uint16_t get_tapping_term(uint16_t keycode, keyrecord_t *record) {
    if (is_alt_home_row_mod(keycode)) {
        return 200;
    }

    if (is_home_row_mod(keycode)) {
        return 200;
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

uint16_t get_flow_tap_term(uint16_t keycode, keyrecord_t *record, uint16_t prev_keycode) {
    if (is_shift_home_row_mod(keycode)) {
        return 0;
    }

    if (is_home_row_mod(keycode) && is_shift_home_row_mod(prev_keycode)) {
        return 0;
    }

    return is_flow_tap_key(keycode) && is_flow_tap_key(prev_keycode) ? FLOW_TAP_TERM : 0;
}

bool get_hold_on_other_key_press(uint16_t keycode, keyrecord_t *record) {
    return false;
}

bool get_permissive_hold(uint16_t keycode, keyrecord_t *record) {
    return is_shift_home_row_mod(keycode);
}

bool get_chordal_hold(uint16_t tap_hold_keycode, keyrecord_t *tap_hold_record, uint16_t other_keycode, keyrecord_t *other_record) {
    if (is_shift_home_row_mod(tap_hold_keycode)) {
        return true;
    }

    return get_chordal_hold_default(tap_hold_record, other_record);
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
