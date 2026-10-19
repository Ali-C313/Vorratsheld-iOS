//
//  EditProfileView.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import PhotosUI
import SwiftUI

struct EditProfileView: View {

    @Environment(UserViewModel.self) private var userViewModel

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var newEmail = ""
    @State private var photoBase64: String?
    @State private var photoItem: PhotosPickerItem?
    @State private var emailPassword = ""
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var passwordError: String?
    @State private var showDeleteAlert = false
    @State private var deletePassword = ""
    @State private var snackbar: SnackbarMessage?

    private var emailChanged: Bool {
        let trimmed = newEmail.trimmingCharacters(in: .whitespaces)
        return !trimmed.isEmpty && trimmed != userViewModel.email
    }

    private var fullName: String {
        "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
    }

    var body: some View {
        Form {
            photoSection

            Section {
                TextField(S.profileFirstName, text: $firstName)
                    .textContentType(.givenName)
                TextField(S.profileLastName, text: $lastName)
                    .textContentType(.familyName)
                TextField(S.email, text: $newEmail)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                // Passwort nur abfragen, wenn die E-Mail wirklich geändert wurde
                if emailChanged {
                    SecureField(S.profileCurrentPassword, text: $emailPassword)
                }
            } footer: {
                Text(emailChanged ? S.profileCurrentPasswordHint : S.profileEmailHint)
            }

            Section {
                Button {
                    userViewModel.saveProfile(
                        firstName: firstName,
                        lastName: lastName,
                        photoBase64: photoBase64,
                        newEmail: newEmail,
                        currentPassword: emailPassword
                    )
                } label: {
                    HStack {
                        Spacer()
                        if userViewModel.isLoading {
                            ProgressView()
                        } else {
                            Text(S.actionSave)
                                .bold()
                        }
                        Spacer()
                    }
                }
                .disabled(userViewModel.isLoading)
            }

            passwordSection

            // Verlangt Apple bei Apps mit Registrierung
            Section {
                Button(S.profileDeleteAccount, role: .destructive) {
                    deletePassword = ""
                    showDeleteAlert = true
                }
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle(S.profileTitle)
        .navigationBarTitleDisplayMode(.inline)
        .snackbar($snackbar)
        .onAppear {
            firstName = userViewModel.user?.firstName ?? ""
            lastName = userViewModel.user?.lastName ?? ""
            photoBase64 = userViewModel.user?.photoBase64
            newEmail = userViewModel.email
        }
        .onChange(of: photoItem) { _, item in
            loadPhoto(item)
        }
        .onChange(of: userViewModel.message) { _, _ in
            showMessage()
        }
        .onChange(of: userViewModel.errorMessage) { _, _ in
            showMessage()
        }
        .alert(S.deleteAccountTitle, isPresented: $showDeleteAlert) {
            SecureField(S.password, text: $deletePassword)
            Button(S.profileDeleteAccount, role: .destructive) {
                userViewModel.deleteAccount(password: deletePassword)
            }
            Button(S.actionCancel, role: .cancel) {}
        } message: {
            Text(S.deleteAccountText)
        }
    }

    private var photoSection: some View {
        Section {
            VStack(spacing: 8) {
                PhotosPicker(selection: $photoItem, matching: .images) {
                    ProfileAvatar(photoBase64: photoBase64, name: fullName, size: 112)
                }
                HStack(spacing: 16) {
                    PhotosPicker(S.profileChangePhoto, selection: $photoItem, matching: .images)
                    if photoBase64 != nil {
                        Button(S.profileRemovePhoto, role: .destructive) {
                            photoBase64 = nil
                        }
                    }
                }
                .buttonStyle(.borderless)
                .font(.subheadline.weight(.semibold))
            }
            .frame(maxWidth: .infinity)
            .listRowBackground(Color.clear)
        }
    }

    private var passwordSection: some View {
        Section(S.profileSectionPassword) {
            SecureField(S.profileCurrentPassword, text: $currentPassword)
                .textContentType(.password)
            SecureField(S.profileNewPassword, text: $newPassword)
                .textContentType(.newPassword)
            SecureField(S.profileNewPasswordConfirm, text: $confirmPassword)
                .textContentType(.newPassword)
            if let passwordError {
                Text(passwordError)
                    .foregroundStyle(AppColor.error)
            }
            Button(S.profileChangePasswordButton) {
                changePassword()
            }
        }
    }

    private func loadPhoto(_ item: PhotosPickerItem?) {
        guard let item else { return }
        Task {
            if let data = try? await item.loadTransferable(type: Data.self),
               let jpeg = ImageHelper.compressedJpeg(from: data) {
                photoBase64 = jpeg.base64EncodedString()
            } else {
                snackbar = SnackbarMessage(text: S.errorPhotoFailed)
            }
            photoItem = nil
        }
    }

    private func changePassword() {
        if newPassword.count < 6 {
            passwordError = S.errorPasswordTooShort
        } else if newPassword != confirmPassword {
            passwordError = S.errorPasswordsMismatch
        } else {
            passwordError = nil
            userViewModel.changePassword(currentPassword: currentPassword, newPassword: newPassword) {
                currentPassword = ""
                newPassword = ""
                confirmPassword = ""
            }
        }
    }

    private func showMessage() {
        guard let text = userViewModel.message ?? userViewModel.errorMessage else { return }
        snackbar = SnackbarMessage(text: text)
        userViewModel.clearMessages()
    }
}

#Preview {
    NavigationStack {
        EditProfileView()
    }
    .environment(PreviewData.userViewModel)
}
