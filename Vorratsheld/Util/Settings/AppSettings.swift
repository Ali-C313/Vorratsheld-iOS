//
//  AppSettings.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import Foundation

enum AppSettings {
    private static let keyLanguage = "app_language"
    private static let keyOnboardingDone = "onboarding_done"
    private static var defaults: UserDefaults { .standard }

    // nil = Systemsprache
    static var language: String? {
        get { defaults.string(forKey: keyLanguage) }
        set { defaults.set(newValue, forKey: keyLanguage) }
    }

    static var onboardingDone: Bool {
        get { defaults.bool(forKey: keyOnboardingDone) }
        set { defaults.set(newValue, forKey: keyOnboardingDone) }
    }
}
