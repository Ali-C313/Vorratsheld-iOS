//
//  StorageLocation.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import Foundation

// Werte wie in Firestore
enum StorageLocation: String, Codable, CaseIterable, Identifiable {
    case kuehlschrank = "KUEHLSCHRANK"
    case kammer = "KAMMER"

    var id: String { rawValue }

    var label: String {
        self == .kuehlschrank ? S.storageFridge : S.storagePantry
    }

    var icon: String {
        self == .kuehlschrank ? "refrigerator" : "shippingbox"
    }
}
