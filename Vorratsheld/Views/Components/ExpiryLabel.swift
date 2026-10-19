//
//  ExpiryLabel.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import Foundation

func expiryLabel(daysLeft: Int) -> String {
    if daysLeft < 0 { return S.expiryExpiredDays(-daysLeft) }
    if daysLeft == 0 { return S.expiryToday }
    if daysLeft == 1 { return S.expiryTomorrow }
    return S.expiryInDays(daysLeft)
}
