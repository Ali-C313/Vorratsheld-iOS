//
//  UserViewModel.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 19.10.26.
//

import Foundation
import Observation

@MainActor
@Observable
class UserViewModel {

    private let authRepository: AuthRepository
    private let userRepository: UserRepository
    private let productRepository: ProductRepository
    private let shoppingRepository: ShoppingRepository

    var user: FireUser?
    var userId: String?
    var email = ""
    var errorMessage: String?
    var message: String?
    var isLoading = false

    var isUserLoggedIn: Bool {
        userId != nil
    }

    init(
        authRepository: AuthRepository,
        userRepository: UserRepository,
        productRepository: ProductRepository,
        shoppingRepository: ShoppingRepository
    ) {
        self.authRepository = authRepository
        self.userRepository = userRepository
        self.productRepository = productRepository
        self.shoppingRepository = shoppingRepository
        checkAuth()
    }

    // Firebase merkt sich die Session, nach dem Neustart ist man noch eingeloggt
    private func checkAuth() {
        guard let currentUserId = authRepository.currentUserId else {
            print("Kein User angemeldet")
            return
        }
        userId = currentUserId
        email = authRepository.currentEmail
        fetchUser()
    }

    func login(email: String, password: String) {
        errorMessage = nil
        isLoading = true
        Task {
            do {
                userId = try await authRepository.login(email: email.trimmingCharacters(in: .whitespaces), password: password)
                self.email = authRepository.currentEmail
                fetchUser()
            } catch {
                errorMessage = error.localizedDescription
                print(error.localizedDescription)
            }
            isLoading = false
        }
    }

    func register(firstName: String, lastName: String, email: String, password: String) {
        errorMessage = nil
        isLoading = true
        Task {
            do {
                let newUserId = try await authRepository.register(email: email.trimmingCharacters(in: .whitespaces), password: password)
                let newUser = FireUser(
                    firstName: firstName.trimmingCharacters(in: .whitespaces),
                    lastName: lastName.trimmingCharacters(in: .whitespaces)
                )
                // Name auch in Firebase Auth, wie in der Android-Version
                try await authRepository.updateDisplayName(newUser.fullName)
                try userRepository.saveUser(newUser, id: newUserId)
                user = newUser
                self.email = authRepository.currentEmail
                userId = newUserId
            } catch {
                errorMessage = error.localizedDescription
                print(error.localizedDescription)
            }
            isLoading = false
        }
    }

    func logout() {
        errorMessage = nil
        do {
            try authRepository.logout()
            // PIN gehört zum Konto, der nächste Nutzer legt sich einen eigenen an
            AppLockSettings.clear()
            clearUser()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func fetchUser() {
        guard let userId else { return }
        Task {
            do {
                // Ohne Profil-Dokument den Namen aus Firebase Auth nehmen
                user = try await userRepository.fetchUser(id: userId) ?? userFromDisplayName()
            } catch {
                user = userFromDisplayName()
                print(error.localizedDescription)
            }
        }
    }

    // Passwort wird nur bei neuer E-Mail gebraucht
    func saveProfile(firstName: String, lastName: String, photoBase64: String?, newEmail: String, currentPassword: String) {
        guard let userId else { return }
        let trimmedEmail = newEmail.trimmingCharacters(in: .whitespaces)
        let emailChanged = !trimmedEmail.isEmpty && trimmedEmail != email

        if emailChanged && currentPassword.isEmpty {
            errorMessage = S.errorPasswordRequired
            return
        }

        let updatedUser = FireUser(
            firstName: firstName.trimmingCharacters(in: .whitespaces),
            lastName: lastName.trimmingCharacters(in: .whitespaces),
            photoBase64: photoBase64
        )

        isLoading = true
        Task {
            do {
                try await authRepository.updateDisplayName(updatedUser.fullName)
                try userRepository.saveUser(updatedUser, id: userId)
                user = updatedUser

                if emailChanged {
                    try await authRepository.reauthenticate(password: currentPassword)
                    try await authRepository.changeEmail(to: trimmedEmail)
                    message = S.profileEmailVerificationSent(trimmedEmail)
                } else {
                    message = S.profileSaved
                }
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    func changePassword(currentPassword: String, newPassword: String, onSuccess: @escaping () -> Void) {
        Task {
            do {
                try await authRepository.reauthenticate(password: currentPassword)
                try await authRepository.changePassword(to: newPassword)
                message = S.profilePasswordChanged
                onSuccess()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    // Erst Passwort prüfen, dann Produkte, Einkaufsliste, Profil und zuletzt das Konto löschen
    func deleteAccount(password: String) {
        guard let userId else { return }
        isLoading = true
        Task {
            do {
                try await authRepository.reauthenticate(password: password)
                try await productRepository.deleteAllProducts(userId: userId)
                try await shoppingRepository.deleteAllItems(userId: userId)
                try await userRepository.deleteUser(id: userId)
                try await authRepository.deleteAccount()
                AppLockSettings.clear()
                clearUser()
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    func clearMessages() {
        message = nil
        errorMessage = nil
    }

    private func clearUser() {
        user = nil
        userId = nil
        email = ""
    }

    private func userFromDisplayName() -> FireUser {
        let parts = authRepository.currentDisplayName.split(separator: " ", maxSplits: 1)
        return FireUser(
            firstName: parts.first.map(String.init) ?? "",
            lastName: parts.count > 1 ? String(parts[1]) : ""
        )
    }
}
