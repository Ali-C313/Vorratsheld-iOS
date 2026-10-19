//
//  Strings.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import Foundation

// Übersetzungen stehen in Localizable.xcstrings
enum S {
    static var legalImprintText: String { L.tr("legal_imprint_text") }
    static var legalTermsText: String { L.tr("legal_terms_text") }
    static var legalPrivacyText: String { L.tr("legal_privacy_text") }
    static var appName: String { L.tr("app_name") }
    static var actionBack: String { L.tr("action_back") }
    static var actionCancel: String { L.tr("action_cancel") }
    static var actionSave: String { L.tr("action_save") }
    static var actionDelete: String { L.tr("action_delete") }
    static var actionAdd: String { L.tr("action_add") }
    static var actionApply: String { L.tr("action_apply") }
    static var storageFridge: String { L.tr("storage_fridge") }
    static var storagePantry: String { L.tr("storage_pantry") }
    static var favorite: String { L.tr("favorite") }
    static var email: String { L.tr("email") }
    static var password: String { L.tr("password") }
    static var loginTitle: String { L.tr("login_title") }
    static var loginButton: String { L.tr("login_button") }
    static var loginToRegister: String { L.tr("login_to_register") }
    static var registerTitle: String { L.tr("register_title") }
    static var registerButton: String { L.tr("register_button") }
    static var registerPasswordConfirm: String { L.tr("register_password_confirm") }
    static var registerToLogin: String { L.tr("register_to_login") }
    static var errorPasswordsMismatch: String { L.tr("error_passwords_mismatch") }
    static var errorPasswordTooShort: String { L.tr("error_password_too_short") }
    static var errorLoginFailed: String { L.tr("error_login_failed") }
    static var errorRegisterFailed: String { L.tr("error_register_failed") }
    static var errorNotLoggedIn: String { L.tr("error_not_logged_in") }
    static var errorNoEmail: String { L.tr("error_no_email") }
    static var overviewSettings: String { L.tr("overview_settings") }
    static var overviewScan: String { L.tr("overview_scan") }
    static var overviewShoppingList: String { L.tr("overview_shopping_list") }
    static var overviewEmpty: String { L.tr("overview_empty") }
    static func overviewFavoriteUpdated(_ p1: String) -> String { L.tr("overview_favorite_updated", p1) }
    static var urgencyExpired: String { L.tr("urgency_expired") }
    static var urgencySoon: String { L.tr("urgency_soon") }
    static var urgencyShort: String { L.tr("urgency_short") }
    static var urgencyOk: String { L.tr("urgency_ok") }
    static func expiryExpiredDays(_ p1: Int) -> String { L.tr("expiry_expired_days", p1) }
    static var expiryToday: String { L.tr("expiry_today") }
    static var expiryTomorrow: String { L.tr("expiry_tomorrow") }
    static func expiryInDays(_ p1: Int) -> String { L.tr("expiry_in_days", p1) }
    static var productEditTitle: String { L.tr("product_edit_title") }
    static var productNewTitle: String { L.tr("product_new_title") }
    static var productName: String { L.tr("product_name") }
    static var productLocation: String { L.tr("product_location") }
    static var productExpiry: String { L.tr("product_expiry") }
    static var productFavoriteHint: String { L.tr("product_favorite_hint") }
    static var productDeleteTitle: String { L.tr("product_delete_title") }
    static func productDeleteText(_ p1: String) -> String { L.tr("product_delete_text", p1) }
    static var errorProductNotFound: String { L.tr("error_product_not_found") }
    static func errorSaveFailed(_ p1: String) -> String { L.tr("error_save_failed", p1) }
    static func errorDeleteFailed(_ p1: String) -> String { L.tr("error_delete_failed", p1) }
    static var shoppingTitle: String { L.tr("shopping_title") }
    static var shoppingEmpty: String { L.tr("shopping_empty") }
    static var scanNoPermission: String { L.tr("scan_no_permission") }
    static var scanAllowCamera: String { L.tr("scan_allow_camera") }
    static var scanOpenSettings: String { L.tr("scan_open_settings") }
    static var notificationChannelName: String { L.tr("notification_channel_name") }
    static var notificationChannelDescription: String { L.tr("notification_channel_description") }
    static var notificationOneExpiring: String { L.tr("notification_one_expiring") }
    static func notificationManyExpiring(_ p1: Int) -> String { L.tr("notification_many_expiring", p1) }
    static var reminderTitle: String { L.tr("reminder_title") }
    static func reminderBody(_ p1: String) -> String { L.tr("reminder_body", p1) }
    static var settingsTitle: String { L.tr("settings_title") }
    static var settingsProfileIncomplete: String { L.tr("settings_profile_incomplete") }
    static var settingsSectionApp: String { L.tr("settings_section_app") }
    static var settingsLanguage: String { L.tr("settings_language") }
    static var settingsSectionSupport: String { L.tr("settings_section_support") }
    static var settingsHelp: String { L.tr("settings_help") }
    static var settingsTerms: String { L.tr("settings_terms") }
    static var settingsPrivacy: String { L.tr("settings_privacy") }
    static var settingsImprint: String { L.tr("settings_imprint") }
    static func settingsVersion(_ p1: String) -> String { L.tr("settings_version", p1) }
    static var settingsLogout: String { L.tr("settings_logout") }
    static var logoutDialogTitle: String { L.tr("logout_dialog_title") }
    static var logoutDialogText: String { L.tr("logout_dialog_text") }
    static var profileTitle: String { L.tr("profile_title") }
    static var profileChangePhoto: String { L.tr("profile_change_photo") }
    static var profileRemovePhoto: String { L.tr("profile_remove_photo") }
    static var profileFirstName: String { L.tr("profile_first_name") }
    static var profileLastName: String { L.tr("profile_last_name") }
    static var profileEmailHint: String { L.tr("profile_email_hint") }
    static var profileCurrentPassword: String { L.tr("profile_current_password") }
    static var profileCurrentPasswordHint: String { L.tr("profile_current_password_hint") }
    static var profileSaved: String { L.tr("profile_saved") }
    static func profileEmailVerificationSent(_ p1: String) -> String { L.tr("profile_email_verification_sent", p1) }
    static var profileSectionPassword: String { L.tr("profile_section_password") }
    static var profileNewPassword: String { L.tr("profile_new_password") }
    static var profileNewPasswordConfirm: String { L.tr("profile_new_password_confirm") }
    static var profilePasswordChanged: String { L.tr("profile_password_changed") }
    static var profileChangePasswordButton: String { L.tr("profile_change_password_button") }
    static var profileDeleteAccount: String { L.tr("profile_delete_account") }
    static var deleteAccountTitle: String { L.tr("delete_account_title") }
    static var deleteAccountText: String { L.tr("delete_account_text") }
    static var errorPasswordRequired: String { L.tr("error_password_required") }
    static var errorPhotoFailed: String { L.tr("error_photo_failed") }
    static var languageTitle: String { L.tr("language_title") }
    static var languageSystem: String { L.tr("language_system") }
    static var helpTitle: String { L.tr("help_title") }
    static var helpIntro: String { L.tr("help_intro") }
    static var helpCategory: String { L.tr("help_category") }
    static var helpCategoryProblem: String { L.tr("help_category_problem") }
    static var helpCategoryFeature: String { L.tr("help_category_feature") }
    static var helpCategoryQuestion: String { L.tr("help_category_question") }
    static var helpSubject: String { L.tr("help_subject") }
    static var helpMessage: String { L.tr("help_message") }
    static var helpReplyEmail: String { L.tr("help_reply_email") }
    static var helpSend: String { L.tr("help_send") }
    static var helpSent: String { L.tr("help_sent") }
    static var helpErrorEmpty: String { L.tr("help_error_empty") }
    static func helpErrorSend(_ p1: String) -> String { L.tr("help_error_send", p1) }
    static var loginSubtitle: String { L.tr("login_subtitle") }
    static var registerSubtitle: String { L.tr("register_subtitle") }
    static var passwordShow: String { L.tr("password_show") }
    static var passwordHide: String { L.tr("password_hide") }
    static var errorNameRequired: String { L.tr("error_name_required") }
    static var splashTagline: String { L.tr("splash_tagline") }
    static var onboardingSkip: String { L.tr("onboarding_skip") }
    static var onboardingNext: String { L.tr("onboarding_next") }
    static var onboardingStart: String { L.tr("onboarding_start") }
    static var onboarding1Title: String { L.tr("onboarding_1_title") }
    static var onboarding1Text: String { L.tr("onboarding_1_text") }
    static var onboarding2Title: String { L.tr("onboarding_2_title") }
    static var onboarding2Text: String { L.tr("onboarding_2_text") }
    static var onboarding3Title: String { L.tr("onboarding_3_title") }
    static var onboarding3Text: String { L.tr("onboarding_3_text") }
    static var onboarding4Title: String { L.tr("onboarding_4_title") }
    static var onboarding4Text: String { L.tr("onboarding_4_text") }
    static func overviewGreeting(_ p1: String) -> String { L.tr("overview_greeting", p1) }
    static var overviewGreetingAnonymous: String { L.tr("overview_greeting_anonymous") }
    static var overviewSubtitle: String { L.tr("overview_subtitle") }
    static var overviewEmptyTitle: String { L.tr("overview_empty_title") }
    static var overviewEmptyButton: String { L.tr("overview_empty_button") }
    static var statExpired: String { L.tr("stat_expired") }
    static var statSoon: String { L.tr("stat_soon") }
    static var statTotal: String { L.tr("stat_total") }
    static var scanHint: String { L.tr("scan_hint") }
    static var expiryScanButton: String { L.tr("expiry_scan_button") }
    static var expiryScanHint: String { L.tr("expiry_scan_hint") }
    static var expiryScanSearching: String { L.tr("expiry_scan_searching") }
    static var expiryScanDetected: String { L.tr("expiry_scan_detected") }
    static var expiryScanManual: String { L.tr("expiry_scan_manual") }
    static var actionEdit: String { L.tr("action_edit") }
    static var actionUndo: String { L.tr("action_undo") }
    static var productQuantity: String { L.tr("product_quantity") }
    static func productDeleted(_ p1: String) -> String { L.tr("product_deleted", p1) }
    static func productDeletedToList(_ p1: String) -> String { L.tr("product_deleted_to_list", p1) }
    static var infoAdded: String { L.tr("info_added") }
    static var infoBarcode: String { L.tr("info_barcode") }
    static var infoAddToList: String { L.tr("info_add_to_list") }
    static func infoAddedToList(_ p1: String) -> String { L.tr("info_added_to_list", p1) }
    static var shoppingAddHint: String { L.tr("shopping_add_hint") }
    static var shoppingCheck: String { L.tr("shopping_check") }
    static var shoppingClearDone: String { L.tr("shopping_clear_done") }
    static var shoppingDoneSection: String { L.tr("shopping_done_section") }
    static var shoppingEmptyTitle: String { L.tr("shopping_empty_title") }
    static func shoppingProgress(_ p1: Int, _ p2: Int) -> String { L.tr("shopping_progress", p1, p2) }
    static var torchOn: String { L.tr("torch_on") }
    static var torchOff: String { L.tr("torch_off") }
    static var settingsSectionSecurity: String { L.tr("settings_section_security") }
    static var settingsAppLock: String { L.tr("settings_app_lock") }
    static var stateOn: String { L.tr("state_on") }
    static var stateOff: String { L.tr("state_off") }
    static var lockTitle: String { L.tr("lock_title") }
    static var lockEnterPin: String { L.tr("lock_enter_pin") }
    static var lockWrongPin: String { L.tr("lock_wrong_pin") }
    static func lockWait(_ p1: Int) -> String { L.tr("lock_wait", p1) }
    static var lockForgotPin: String { L.tr("lock_forgot_pin") }
    static var lockForgotText: String { L.tr("lock_forgot_text") }
    static var lockUsePin: String { L.tr("lock_use_pin") }
    static var lockBiometricReason: String { L.tr("lock_biometric_reason") }
    static var applockTitle: String { L.tr("applock_title") }
    static var applockIntro: String { L.tr("applock_intro") }
    static var applockEnable: String { L.tr("applock_enable") }
    static var applockEnableHint: String { L.tr("applock_enable_hint") }
    static func applockUnlockWith(_ p1: String) -> String { L.tr("applock_unlock_with", p1) }
    static var applockNoBiometrics: String { L.tr("applock_no_biometrics") }
    static var applockTimeout: String { L.tr("applock_timeout") }
    static var applockChangePin: String { L.tr("applock_change_pin") }
    static var biometricFaceId: String { L.tr("biometric_face_id") }
    static var biometricTouchId: String { L.tr("biometric_touch_id") }
    static var biometricFingerprint: String { L.tr("biometric_fingerprint") }
    static var biometricFace: String { L.tr("biometric_face") }
    static var biometricGeneric: String { L.tr("biometric_generic") }
    static var timeoutImmediately: String { L.tr("timeout_immediately") }
    static var timeout1min: String { L.tr("timeout_1min") }
    static var timeout5min: String { L.tr("timeout_5min") }
    static var timeoutStart: String { L.tr("timeout_start") }
    static var pinCreate: String { L.tr("pin_create") }
    static var pinCreateHint: String { L.tr("pin_create_hint") }
    static var pinConfirm: String { L.tr("pin_confirm") }
    static var pinConfirmHint: String { L.tr("pin_confirm_hint") }
    static var pinMismatch: String { L.tr("pin_mismatch") }
    static var pinCurrent: String { L.tr("pin_current") }
    static var pinCurrentHint: String { L.tr("pin_current_hint") }
}
