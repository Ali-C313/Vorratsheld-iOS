//
//  ExpiryDateParser.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import Foundation

// Sucht im erkannten Verpackungstext das Ablaufdatum (MHD)
enum ExpiryDateParser {

    // Wörter, hinter denen meistens das MHD steht
    private static let expiryKeywords = [
        "MHD", "MINDESTENS", "HALTBAR", "VERBRAUCH", "ZU VERBR",
        "BEST BEFORE", "BEST BY", "BB", "BBE", "USE BY", "EXP",
        "CONSOMMER", "DLC", "DDM", "CONSUMARSI", "SCAD", "CONSUMIR", "CAD",
        "NAJLEPIEJ", "SPOŻYĆ", "SKT", "TETT", "ГОДЕН", "ГОДНО", "ВЖИТИ"
    ]

    // Herstell- und Packdatum sollen nicht als MHD durchgehen
    private static let productionKeywords = ["HERG", "PROD", "PACK", "FABR", "ИЗГОТ", "ВИГОТ"]

    private static let months: [String: Int] = [
        "JAN": 1, "FEB": 2, "MÄR": 3, "MAR": 3, "MRZ": 3, "APR": 4,
        "MAI": 5, "MAY": 5, "JUN": 6, "JUL": 7, "AUG": 8, "SEP": 9,
        "OKT": 10, "OCT": 10, "NOV": 11, "DEZ": 12, "DEC": 12
    ]

    private static let dayMonthYear = regex(#"(?<!\d)(\d{1,2}) ?[./\-] ?(\d{1,2}) ?[./\-] ?(\d{4}|\d{2})(?!\d)"#)
    private static let spacedDayMonthYear = regex(#"(?<!\d)(\d{2}) (\d{2}) (\d{4}|\d{2})(?!\d)"#)
    private static let yearMonthDay = regex(#"(?<!\d)(\d{4})[./\-](\d{1,2})[./\-](\d{1,2})(?!\d)"#)
    private static let monthYear = regex(#"(?<![\d./\-])(\d{1,2}) ?[./\-] ?(\d{4})(?!\d)"#)
    private static let shortMonthYear = regex(#"(?<![\d./\-])(\d{2}) ?[./] ?(\d{2})(?![\d./\-])"#)
    private static let monthName = regex(
        #"(?<!\d)(?:(\d{1,2})\.? ?)?(JAN|FEB|MÄR|MAR|MRZ|APR|MAI|MAY|JUN|JUL|AUG|SEP|OKT|OCT|NOV|DEZ|DEC)[A-ZÄ]*\.? ?(\d{4}|\d{2})(?!\d)"#
    )

    // Typische Lesefehler der Texterkennung neben Ziffern
    private static let lookalikes: [Character: Character] = [
        "O": "0", "Q": "0", "I": "1", "L": "1", "|": "1", "S": "5", "B": "8"
    ]

    private struct Candidate {
        let date: LocalDay
        let score: Int
    }

    static func parse(_ text: String) -> LocalDay? {
        let clean = normalize(text)
        let ns = clean as NSString
        let fullRange = NSRange(location: 0, length: ns.length)
        var candidates: [Candidate] = []

        func group(_ match: NSTextCheckingResult, _ index: Int) -> String {
            let range = match.range(at: index)
            return range.location == NSNotFound ? "" : ns.substring(with: range)
        }

        func number(_ match: NSTextCheckingResult, _ index: Int) -> Int {
            Int(group(match, index)) ?? 0
        }

        func add(_ match: NSTextCheckingResult, _ date: LocalDay?, _ baseScore: Int, needsKeyword: Bool = false) {
            guard let date, isPlausible(date) else { return }
            let start = match.range.location
            let from = max(start - 30, 0)
            let before = ns.substring(with: NSRange(location: from, length: start - from)) as NSString
            let expiryAt = expiryKeywords.map { lastIndex(of: $0, in: before) }.max() ?? -1
            let productionAt = productionKeywords.map { lastIndex(of: $0, in: before) }.max() ?? -1
            let hasKeyword = expiryAt > productionAt
            if needsKeyword && !hasKeyword { return }
            var score = baseScore
            if hasKeyword { score += 5 }
            if productionAt > expiryAt { score -= 4 }
            candidates.append(Candidate(date: date, score: score))
        }

        for m in dayMonthYear.matches(in: clean, range: fullRange) {
            add(m, LocalDay(year: year(group(m, 3)), month: number(m, 2), day: number(m, 1)), 3)
        }
        for m in spacedDayMonthYear.matches(in: clean, range: fullRange) {
            add(m, LocalDay(year: year(group(m, 3)), month: number(m, 2), day: number(m, 1)), 2)
        }
        for m in yearMonthDay.matches(in: clean, range: fullRange) {
            add(m, LocalDay(year: number(m, 1), month: number(m, 2), day: number(m, 3)), 3)
        }
        for m in monthYear.matches(in: clean, range: fullRange) {
            add(m, LocalDay(year: number(m, 2), month: number(m, 1), day: 1)?.endOfMonth(), 2)
        }
        for m in shortMonthYear.matches(in: clean, range: fullRange) {
            add(m, LocalDay(year: year(group(m, 2)), month: number(m, 1), day: 1)?.endOfMonth(), 1, needsKeyword: true)
        }
        for m in monthName.matches(in: clean, range: fullRange) {
            let day = group(m, 1)
            let month = months[group(m, 2)] ?? 0
            let y = year(group(m, 3))
            let date = day.isEmpty
                ? LocalDay(year: y, month: month, day: 1)?.endOfMonth()
                : LocalDay(year: y, month: month, day: Int(day) ?? 0)
            add(m, date, 3)
        }

        // Bei Gleichstand das spätere Datum, das frühere ist oft das Packdatum
        return candidates.max { a, b in
            a.score != b.score ? a.score < b.score : a.date < b.date
        }?.date
    }

    private static func regex(_ pattern: String) -> NSRegularExpression {
        try! NSRegularExpression(pattern: pattern)
    }

    private static func lastIndex(of keyword: String, in text: NSString) -> Int {
        let range = text.range(of: keyword, options: .backwards)
        return range.location == NSNotFound ? -1 : range.location
    }

    private static func normalize(_ text: String) -> String {
        let upper = Array(text.uppercased())
        var chars = upper
        for i in upper.indices {
            guard let replacement = lookalikes[upper[i]] else { continue }
            let prev: Character? = i > 0 ? upper[i - 1] : nil
            let next: Character? = i + 1 < upper.count ? upper[i + 1] : nil
            let nearNumber = isNumberPart(prev) || isNumberPart(next)
            if nearNumber && !(prev?.isLetter ?? false) && !(next?.isLetter ?? false) {
                chars[i] = replacement
            }
        }
        return String(chars)
    }

    private static func isNumberPart(_ c: Character?) -> Bool {
        guard let c else { return false }
        return (c.isASCII && c.isNumber) || "./-".contains(c)
    }

    private static func year(_ raw: String) -> Int {
        raw.count == 2 ? 2000 + (Int(raw) ?? 0) : (Int(raw) ?? 0)
    }

    // Abgelaufen bis vor einem Jahr oder bis zu zehn Jahre in der Zukunft
    private static func isPlausible(_ date: LocalDay) -> Bool {
        let diff = date.epochDay - LocalDay.today().epochDay
        return (-366...3660).contains(diff)
    }
}
