//
//  PinPad.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct PinPad<ExtraKey: View>: View {
    let title: String
    let subtitle: String?
    let entered: String
    let onDigit: (Character) -> Void
    let onDelete: () -> Void
    var errorText: String? = nil
    var shakeTrigger: Int = 0
    var enabled: Bool = true
    @ViewBuilder var extraKey: () -> ExtraKey

    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .font(.title2.bold())
                .foregroundStyle(AppColor.cream)
                .multilineTextAlignment(.center)
            if let subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(AppColor.cream.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.top, 6)
                    .padding(.horizontal, 24)
            }

            PinDots(filled: entered.count, isError: errorText != nil, shakeTrigger: shakeTrigger)
                .padding(.top, 28)

            Text(errorText ?? " ")
                .font(.subheadline)
                .foregroundStyle(AppColor.pinError)
                .multilineTextAlignment(.center)
                .frame(height: 40)

            NumberPad(onDigit: onDigit, onDelete: onDelete, enabled: enabled, extraKey: extraKey)
        }
    }
}

extension PinPad where ExtraKey == EmptyView {
    init(
        title: String,
        subtitle: String?,
        entered: String,
        onDigit: @escaping (Character) -> Void,
        onDelete: @escaping () -> Void,
        errorText: String? = nil,
        shakeTrigger: Int = 0,
        enabled: Bool = true
    ) {
        self.init(
            title: title,
            subtitle: subtitle,
            entered: entered,
            onDigit: onDigit,
            onDelete: onDelete,
            errorText: errorText,
            shakeTrigger: shakeTrigger,
            enabled: enabled,
            extraKey: { EmptyView() }
        )
    }
}

#Preview {
    PinPad(title: "Vorratsheld ist gesperrt", subtitle: "Gib deinen PIN ein", entered: "12", onDigit: { _ in }, onDelete: {})
        .padding()
        .background(AppColor.headerGradient)
}
