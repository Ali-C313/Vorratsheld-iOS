//
//  AppLanguage.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import Foundation

// Name jeweils in der eigenen Sprache
enum AppLanguage: String, CaseIterable, Identifiable {
    case deutsch = "de"
    case english = "en"
    case tuerkce = "tr"
    case arabic = "ar"
    case francais = "fr"
    case espanol = "es"
    case italiano = "it"
    case polski = "pl"
    case russian = "ru"
    case ukrainian = "uk"

    var id: String { rawValue }
    var code: String { rawValue }

    var nativeName: String {
        switch self {
        case .deutsch: return "Deutsch"
        case .english: return "English"
        case .tuerkce: return "Türkçe"
        case .arabic: return "العربية"
        case .francais: return "Français"
        case .espanol: return "Español"
        case .italiano: return "Italiano"
        case .polski: return "Polski"
        case .russian: return "Русский"
        case .ukrainian: return "Українська"
        }
    }
}
