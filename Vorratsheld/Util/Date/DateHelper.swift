//
//  DateHelper.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import Foundation

enum DateHelper {
    static let dayMs: Int64 = 24 * 60 * 60 * 1000

    static func nowMillis() -> Int64 {
        Int64(Date().timeIntervalSince1970 * 1000)
    }

    // Gespeichert ist Mitternacht in UTC, daraus wird der Kalendertag
    static func expiryDateToLocalDay(_ expiryDate: Int64) -> LocalDay {
        let days = expiryDate >= 0 ? expiryDate / dayMs : (expiryDate - dayMs + 1) / dayMs
        return LocalDay(epochDay: Int(days))
    }

    // negativ = abgelaufen
    static func daysUntilExpiry(_ expiryDate: Int64) -> Int {
        expiryDateToLocalDay(expiryDate).epochDay - LocalDay.today().epochDay
    }

    static func expiryUrgency(for expiryDate: Int64) -> ExpiryUrgency {
        let days = daysUntilExpiry(expiryDate)
        if days < 0 { return .abgelaufen }
        if days <= 3 { return .baldAblaufend }
        if days <= 10 { return .inKuerze }
        return .unkritisch
    }

    // z. B. 04.10.2026
    static func formatDate(_ dateMillis: Int64) -> String {
        format(expiryDateToLocalDay(dateMillis))
    }

    // Lokales Datum für echte Zeitpunkte (das MHD selbst ist schon ein Kalendertag)
    static func formatLocalDate(_ millis: Int64) -> String {
        format(LocalDay(localDate: Date(timeIntervalSince1970: TimeInterval(millis) / 1000)))
    }

    private static func format(_ day: LocalDay) -> String {
        String(format: "%02d.%02d.%d", day.day, day.month, day.year)
    }
}
