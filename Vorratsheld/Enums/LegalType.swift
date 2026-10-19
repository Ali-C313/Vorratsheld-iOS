//
//  LegalType.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import Foundation

enum LegalType: String, Hashable {
    case terms, privacy, imprint

    var title: String {
        switch self {
        case .terms: return S.settingsTerms
        case .privacy: return S.settingsPrivacy
        case .imprint: return S.settingsImprint
        }
    }

    var text: String {
        switch self {
        case .terms: return S.legalTermsText
        case .privacy: return S.legalPrivacyText
        case .imprint: return S.legalImprintText
        }
    }
}
