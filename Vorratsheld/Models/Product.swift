//
//  Product.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import Foundation
import FirebaseFirestore

struct Product: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var userId: String
    var barcode: String = ""
    var name: String
    var imageUrl: String? = nil
    var location: StorageLocation = .kuehlschrank
    var expiryDate: Int64            // Ablaufdatum in ms (Mitternacht UTC), wie in der Android-Version
    var quantity: Int = 1
    var isFavorite: Bool = false     // Landet beim Löschen auf der Einkaufsliste
    var addedAt: Int64 = DateHelper.nowMillis()

    // In Firestore heißt das Feld "favorite"
    enum CodingKeys: String, CodingKey {
        case id, userId, barcode, name, imageUrl, location, expiryDate, quantity, addedAt
        case isFavorite = "favorite"
    }
}
