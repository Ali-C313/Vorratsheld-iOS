//
//  UserRepositoryImpl.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 19.10.26.
//

import Foundation
import FirebaseFirestore

class UserRepositoryImpl: UserRepository {

    private let database = FirebaseManager.shared.database

    func fetchUser(id: String) async throws -> FireUser? {
        let document = try await database.collection(CollectionNames.users).document(id).getDocument()
        guard document.exists else { return nil }
        return try document.data(as: FireUser.self)
    }

    func saveUser(_ user: FireUser, id: String) throws {
        try database.collection(CollectionNames.users).document(id).setData(from: user)
    }

    func deleteUser(id: String) async throws {
        try await database.collection(CollectionNames.users).document(id).delete()
    }
}
