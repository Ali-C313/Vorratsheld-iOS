//
//  PrimaryButton.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct PrimaryButton: View {
    let text: String
    var isLoading: Bool = false
    var color: Color = AppColor.primary
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                if isLoading {
                    ProgressView()
                        .tint(AppColor.onPrimary)
                } else {
                    Text(text)
                        .font(.headline)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .foregroundStyle(AppColor.onPrimary)
            .background(color, in: RoundedRectangle(cornerRadius: 16))
        }
        .disabled(isLoading)
    }
}

#Preview {
    PrimaryButton(text: "Anmelden") {}
        .padding()
}
