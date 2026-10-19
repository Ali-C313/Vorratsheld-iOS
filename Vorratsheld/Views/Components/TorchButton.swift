//
//  TorchButton.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct TorchButton: View {
    let enabled: Bool
    let onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            Image(systemName: enabled ? "flashlight.on.fill" : "flashlight.off.fill")
                .font(.title3)
                .foregroundStyle(enabled ? Color(hex: 0x3A2A00) : .white)
                .frame(width: 44, height: 44)
                .background(enabled ? Color(hex: 0xFFC94A) : Color.black.opacity(0.45), in: Circle())
        }
        .accessibilityLabel(enabled ? S.torchOff : S.torchOn)
        .animation(.easeInOut(duration: 0.2), value: enabled)
    }
}

#Preview {
    TorchButton(enabled: true) {}
}
