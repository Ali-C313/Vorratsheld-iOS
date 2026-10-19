//
//  Snackbar.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct SnackbarMessage: Equatable {
    let id = UUID()
    let text: String
    var actionLabel: String? = nil
    var action: (() -> Void)? = nil

    static func == (lhs: SnackbarMessage, rhs: SnackbarMessage) -> Bool {
        lhs.id == rhs.id
    }
}

private struct SnackbarModifier: ViewModifier {
    @Binding var message: SnackbarMessage?
    var bottomPadding: CGFloat

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                if let current = message {
                    HStack(spacing: 12) {
                        Text(current.text)
                            .font(.subheadline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        if let label = current.actionLabel {
                            Button(label) {
                                current.action?()
                                message = nil
                            }
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(AppColor.primaryContainer)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(Color(hex: 0x2F312C), in: RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, 16)
                    .padding(.bottom, bottomPadding)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .task(id: current.id) {
                        try? await Task.sleep(for: .seconds(4))
                        if message?.id == current.id {
                            message = nil
                        }
                    }
                }
            }
            .animation(.spring(duration: 0.3), value: message)
    }
}

extension View {
    func snackbar(_ message: Binding<SnackbarMessage?>, bottomPadding: CGFloat = 16) -> some View {
        modifier(SnackbarModifier(message: message, bottomPadding: bottomPadding))
    }
}
