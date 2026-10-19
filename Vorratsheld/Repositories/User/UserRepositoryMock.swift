//
//  UserRepositoryMock.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 19.10.26.
//

import Foundation

class UserRepositoryMock: UserRepository {

    private var user: FireUser? = FireUser(firstName: "Ali", lastName: "Chehab")

    func fetchUser(id: String) async throws -> FireUser? {
        user
    }

    func saveUser(_ user: FireUser, id: String) throws {
        self.user = user
    }

    func deleteUser(id: String) async throws {
        user = nil
    }
}
