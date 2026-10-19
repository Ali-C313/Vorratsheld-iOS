//
//  LoginView.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct LoginView: View {

    @Environment(UserViewModel.self) private var userViewModel
    @Environment(AppViewModel.self) private var appViewModel

    @State private var email = ""
    @State private var password = ""

    var body: some View {
        AuthLayout(title: S.loginTitle, subtitle: S.loginSubtitle) {
            VStack(alignment: .leading, spacing: 12) {
                AuthTextField(text: $email, label: S.email, icon: "envelope.fill", keyboard: .emailAddress, contentType: .username)
                AuthTextField(text: $password, label: S.password, icon: "lock.fill", isPassword: true, contentType: .password)

                if let errorMessage = userViewModel.errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundStyle(AppColor.error)
                }

                PrimaryButton(text: S.loginButton, isLoading: userViewModel.isLoading) {
                    userViewModel.login(email: email, password: password)
                }
                .padding(.top, 12)

                Button(S.loginToRegister) {
                    userViewModel.errorMessage = nil
                    appViewModel.authPath.append(.register)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 8)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        LoginView()
    }
    .environment(PreviewData.userViewModel)
    .environment(AppViewModel())
}
