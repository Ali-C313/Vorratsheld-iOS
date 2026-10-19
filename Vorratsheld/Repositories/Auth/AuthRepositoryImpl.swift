//
//  AuthRepositoryImpl.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 19.10.26.
//

import Foundation
import FirebaseAuth

class AuthRepositoryImpl: AuthRepository {

    private let auth = FirebaseManager.shared.auth

    var currentUserId: String? {
        auth.currentUser?.uid
    }

    var currentEmail: String {
        auth.currentUser?.email ?? ""
    }

    var currentDisplayName: String {
        auth.currentUser?.displayName ?? ""
    }

    func login(email: String, password: String) async throws -> String {
        let result = try await auth.signIn(withEmail: email, password: password)
        return result.user.uid
    }

    func register(email: String, password: String) async throws -> String {
        // Passwort braucht mindestens 6 Zeichen, sonst kommt ein Fehler von Firebase
        let result = try await auth.createUser(withEmail: email, password: password)
        return result.user.uid
    }

    func updateDisplayName(_ name: String) async throws {
        let changeRequest = auth.currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        try await changeRequest?.commitChanges()
    }

    func reauthenticate(password: String) async throws {
        guard let user = auth.currentUser, let email = user.email else {
            throw AuthError.notLoggedIn
        }
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        _ = try await user.reauthenticate(with: credential)
    }

    func changePassword(to newPassword: String) async throws {
        try await auth.currentUser?.updatePassword(to: newPassword)
    }

    func changeEmail(to newEmail: String) async throws {
        try await auth.currentUser?.sendEmailVerification(beforeUpdatingEmail: newEmail)
    }

    func deleteAccount() async throws {
        try await auth.currentUser?.delete()
    }

    func logout() throws {
        try auth.signOut()
    }
}
