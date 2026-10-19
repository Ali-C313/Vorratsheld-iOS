//
//  LocalDay.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import Foundation

// Datum ohne Uhrzeit, gerechnet in UTC wie in der Android-Version
struct LocalDay: Hashable, Comparable {
    let year: Int
    let month: Int
    let day: Int

    static let utcCalendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC") ?? .current
        return calendar
    }()

    // nil bei ungültigen Daten wie 31.02.
    init?(year: Int, month: Int, day: Int) {
        guard (1...12).contains(month), (1...31).contains(day),
              let date = LocalDay.utcCalendar.date(from: DateComponents(year: year, month: month, day: day)) else { return nil }
        let check = LocalDay.utcCalendar.dateComponents([.year, .month, .day], from: date)
        guard check.year == year, check.month == month, check.day == day else { return nil }
        self.year = year
        self.month = month
        self.day = day
    }

    init(epochDay: Int) {
        let date = Date(timeIntervalSince1970: TimeInterval(epochDay) * 86_400)
        let parts = LocalDay.utcCalendar.dateComponents([.year, .month, .day], from: date)
        year = parts.year ?? 1970
        month = parts.month ?? 1
        day = parts.day ?? 1
    }

    init(localDate: Date) {
        let parts = Calendar.current.dateComponents([.year, .month, .day], from: localDate)
        self = LocalDay(year: parts.year ?? 1970, month: parts.month ?? 1, day: parts.day ?? 1) ?? LocalDay(epochDay: 0)
    }

    static func today() -> LocalDay {
        LocalDay(localDate: Date())
    }

    var epochDay: Int {
        let date = LocalDay.utcCalendar.date(from: DateComponents(year: year, month: month, day: day)) ?? Date(timeIntervalSince1970: 0)
        return Int((date.timeIntervalSince1970 / 86_400).rounded(.down))
    }

    // Mitternacht UTC in ms, so steht das MHD in Firestore
    var millis: Int64 { Int64(epochDay) * DateHelper.dayMs }

    // Mittag in lokaler Zeit, damit der DatePicker keinen Tag verrutscht
    var localDate: Date {
        Calendar.current.date(from: DateComponents(year: year, month: month, day: day, hour: 12)) ?? Date()
    }

    func adding(days: Int) -> LocalDay {
        LocalDay(epochDay: epochDay + days)
    }

    func endOfMonth() -> LocalDay {
        let nextMonth = month == 12
            ? LocalDay(year: year + 1, month: 1, day: 1)
            : LocalDay(year: year, month: month + 1, day: 1)
        return (nextMonth ?? self).adding(days: -1)
    }

    static func < (lhs: LocalDay, rhs: LocalDay) -> Bool {
        lhs.epochDay < rhs.epochDay
    }
}
