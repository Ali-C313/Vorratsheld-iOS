//
//  FireUser.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import Foundation
import FirebaseFirestore

struct FireUser: Codable, Identifiable {
    @DocumentID var id: String?
    var firstName: String = ""
    var lastName: String = ""
    // Base64-JPEG
    var photoBase64: String? = nil

    var fullName: String {
        "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
    }
}
