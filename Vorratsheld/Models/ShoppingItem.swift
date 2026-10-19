//
//  ShoppingItem.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import Foundation
import FirebaseFirestore

struct ShoppingItem: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var userId: String
    var name: String
    var quantity: Int = 1
    var checked: Bool = false
    var imageUrl: String? = nil
    var addedAt: Int64 = DateHelper.nowMillis()
}
