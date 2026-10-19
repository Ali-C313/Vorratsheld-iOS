//
//  HTTPError.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import Foundation

enum HTTPError: String, Error, LocalizedError {
    case invalidURL = "Ungültige URL."
    case fetchFailed = "Daten laden fehlgeschlagen."

    var errorDescription: String? {
        rawValue
    }
}
