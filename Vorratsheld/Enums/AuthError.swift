//
//  AuthError.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 19.10.26.
//

import Foundation

enum AuthError: String, Error, LocalizedError {
    case notLoggedIn = "Nicht eingeloggt."

    var errorDescription: String? {
        rawValue
    }
}
