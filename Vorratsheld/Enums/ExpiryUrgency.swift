//
//  ExpiryUrgency.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import Foundation

enum ExpiryUrgency {
    case abgelaufen
    case baldAblaufend   // <= 3 Tage
    case inKuerze        // <= 10 Tage
    case unkritisch
}
