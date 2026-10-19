//
//  FirebaseManager.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

// Singleton, damit überall dieselbe Instanz von Auth und Firestore genutzt wird
class FirebaseManager {

    static let shared = FirebaseManager()

    private init() {}

    let auth = Auth.auth()
    let database = Firestore.firestore()

    var userId: String? {
        auth.currentUser?.uid
    }
}
