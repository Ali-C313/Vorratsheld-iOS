//
//  RegisterView.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct RegisterView: View {

    @Environment(UserViewModel.self) private var userViewModel
    @Environment(AppViewModel.self) private var appViewModel

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var passwordConfirm = ""
    @State private var localError: String?

    var body: some View {
        AuthLayout(title: S.registerTitle, subtitle: S.registerSubtitle) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    AuthTextField(text: $firstName, label: S.profileFirstName, icon: "person.fill", contentType: .givenName)
                    AuthTextField(text: $lastName, label: S.profileLastName, icon: "person.text.rectangle", contentType: .familyName)
                }
                AuthTextField(text: $email, label: S.email, icon: "envelope.fill", keyboard: .emailAddress, contentType: .username)
                AuthTextField(text: $password, label: S.password, icon: "lock.fill", isPassword: true, contentType: .newPassword)
                AuthTextField(text: $passwordConfirm, label: S.registerPasswordConfirm, icon: "lock.fill", isPassword: true, contentType: .newPassword)

                if let errorMessage = localError ?? userViewModel.errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundStyle(AppColor.error)
                }

                PrimaryButton(text: S.registerButton, isLoading: userViewModel.isLoading) {
                    localError = validate()
                    if localError == nil {
                        userViewModel.register(firstName: firstName, lastName: lastName, email: email, password: password)
                    }
                }
                .padding(.top, 12)

                Button(S.registerToLogin) {
                    userViewModel.errorMessage = nil
                    appViewModel.authPath.removeAll()
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 8)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private func validate() -> String? {
        if firstName.trimmingCharacters(in: .whitespaces).isEmpty || lastName.trimmingCharacters(in: .whitespaces).isEmpty {
            return S.errorNameRequired
        }
        if password.count < 6 {
            return S.errorPasswordTooShort
        }
        if password != passwordConfirm {
            return S.errorPasswordsMismatch
        }
        return nil
    }
}

#Preview {
    NavigationStack {
        RegisterView()
    }
    .environment(PreviewData.userViewModel)
    .environment(AppViewModel())
}
