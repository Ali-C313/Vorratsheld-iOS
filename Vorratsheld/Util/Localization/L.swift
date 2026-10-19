//
//  L.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import Foundation

// Texte in der gewählten Sprache, fehlt eine Übersetzung kommt Deutsch
enum L {
    private(set) static var bundle: Bundle = makeBundle(AppSettings.language)
    private static let fallback: Bundle = lprojBundle("de") ?? .main

    static func tr(_ key: String, _ args: CVarArg...) -> String {
        let text = lookup(key)
        return args.isEmpty ? text : String(format: text, locale: locale, arguments: args)
    }

    static var currentCode: String {
        AppSettings.language ?? Bundle.main.preferredLocalizations.first ?? "de"
    }

    static var locale: Locale { Locale(identifier: currentCode) }

    static var isRightToLeft: Bool { currentCode.hasPrefix("ar") }

    // nil = Systemsprache
    static func setLanguage(_ code: String?) {
        AppSettings.language = code
        bundle = makeBundle(code)
    }

    private static func lookup(_ key: String) -> String {
        let value = bundle.localizedString(forKey: key, value: nil, table: nil)
        if value != key { return value }
        return fallback.localizedString(forKey: key, value: key, table: nil)
    }

    private static func makeBundle(_ code: String?) -> Bundle {
        lprojBundle(code ?? Bundle.main.preferredLocalizations.first ?? "de") ?? .main
    }

    private static func lprojBundle(_ code: String) -> Bundle? {
        guard let path = Bundle.main.path(forResource: code, ofType: "lproj") else { return nil }
        return Bundle(path: path)
    }
}
