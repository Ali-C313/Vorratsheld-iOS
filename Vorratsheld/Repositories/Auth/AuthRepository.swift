//
//  AuthRepository.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 19.10.26.
//

import Foundation

protocol AuthRepository {
    // nil, wenn niemand eingeloggt ist
    var currentUserId: String? { get }
    var currentEmail: String { get }
    var currentDisplayName: String { get }

    // geben die uid zurück
    func login(email: String, password: String) async throws -> String
    func register(email: String, password: String) async throws -> String

    func updateDisplayName(_ name: String) async throws

    // Firebase verlangt vor Passwort-, E-Mail-Änderung und Löschen eine frische Anmeldung
    func reauthenticate(password: String) async throws
    func changePassword(to newPassword: String) async throws
    // Neue Adresse gilt erst nach Klick auf den Link in der Mail
    func changeEmail(to newEmail: String) async throws

    func deleteAccount() async throws
    func logout() throws
}
