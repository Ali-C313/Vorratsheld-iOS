//
//  NumberPad.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct NumberPad<ExtraKey: View>: View {
    let onDigit: (Character) -> Void
    let onDelete: () -> Void
    let enabled: Bool
    @ViewBuilder var extraKey: () -> ExtraKey

    private let rows = ["123", "456", "789"]

    var body: some View {
        VStack(spacing: 14) {
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 22) {
                    ForEach(Array(row), id: \.self) { digit in
                        DigitKey(label: String(digit), enabled: enabled) { tap(digit) }
                    }
                }
            }
            HStack(spacing: 22) {
                extraKey()
                    .frame(width: 76, height: 76)
                DigitKey(label: "0", enabled: enabled) { tap("0") }
                PadIconKey(icon: "delete.left", description: S.actionDelete, enabled: enabled, action: onDelete)
            }
        }
        // Ziffern auch bei Arabisch von links nach rechts
        .environment(\.layoutDirection, .leftToRight)
    }

    private func tap(_ digit: Character) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        onDigit(digit)
    }
}
