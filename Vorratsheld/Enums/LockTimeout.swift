//
//  LockTimeout.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import Foundation

enum LockTimeout: String, CaseIterable, Identifiable {
    case immediately = "IMMEDIATELY"
    case oneMinute = "ONE_MINUTE"
    case fiveMinutes = "FIVE_MINUTES"
    case onStartOnly = "ON_START_ONLY"

    var id: String { rawValue }

    var seconds: Int {
        switch self {
        case .immediately: return 0
        case .oneMinute: return 60
        case .fiveMinutes: return 300
        case .onStartOnly: return -1
        }
    }

    var label: String {
        switch self {
        case .immediately: return S.timeoutImmediately
        case .oneMinute: return S.timeout1min
        case .fiveMinutes: return S.timeout5min
        case .onStartOnly: return S.timeoutStart
        }
    }
}
