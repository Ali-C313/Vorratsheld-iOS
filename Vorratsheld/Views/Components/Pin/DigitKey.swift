//
//  DigitKey.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct DigitKey: View {
    let label: String
    let enabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 30, weight: .medium))
                .foregroundStyle(AppColor.cream)
                .frame(width: 76, height: 76)
                .background(Color.white.opacity(0.14), in: Circle())
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
        .opacity(enabled ? 1 : 0.5)
    }
}
