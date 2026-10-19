//
//  AuthTextField.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct AuthTextField: View {
    @Binding var text: String
    let label: String
    let icon: String
    var isPassword: Bool = false
    var keyboard: UIKeyboardType = .default
    var contentType: UITextContentType? = nil

    @State private var visible = false

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(AppColor.onSurfaceVariant)
                .frame(width: 22)

            Group {
                if isPassword && !visible {
                    SecureField(label, text: $text)
                } else {
                    TextField(label, text: $text)
                        .keyboardType(keyboard)
                }
            }
            .textContentType(contentType)
            .textInputAutocapitalization(isPassword || keyboard == .emailAddress ? .never : .words)
            .autocorrectionDisabled(isPassword || keyboard == .emailAddress)

            if isPassword {
                Button {
                    visible.toggle()
                } label: {
                    Image(systemName: visible ? "eye.slash" : "eye")
                        .foregroundStyle(AppColor.onSurfaceVariant)
                }
                .accessibilityLabel(visible ? S.passwordHide : S.passwordShow)
            }
        }
        .padding(.horizontal, 14)
        .frame(height: 54)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(AppColor.outline, lineWidth: 1)
        )
    }
}

#Preview {
    AuthTextField(text: .constant("ali@example.com"), label: "E-Mail", icon: "envelope.fill")
        .padding()
}
