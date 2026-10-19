//
//  AuthRepositoryMock.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 19.10.26.
//

import Foundation

class AuthRepositoryMock: AuthRepository {

    private var userId: String? = "preview"

    var currentUserId: String? {
        userId
    }

    var currentEmail: String {
        "ali@example.com"
    }

    var currentDisplayName: String {
        "Ali Chehab"
    }

    func login(email: String, password: String) async throws -> String {
        userId = "preview"
        return "preview"
    }

    func register(email: String, password: String) async throws -> String {
        userId = "preview"
        return "preview"
    }

    func updateDisplayName(_ name: String) async throws {}
    func reauthenticate(password: String) async throws {}
    func changePassword(to newPassword: String) async throws {}
    func changeEmail(to newEmail: String) async throws {}

    func deleteAccount() async throws {
        userId = nil
    }

    func logout() throws {
        userId = nil
    }
}
