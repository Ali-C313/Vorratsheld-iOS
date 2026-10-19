//
//  PinDots.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct PinDots: View {
    let filled: Int
    let isError: Bool
    let shakeTrigger: Int

    var body: some View {
        HStack(spacing: 18) {
            ForEach(0..<AppLockSettings.pinLength, id: \.self) { index in
                let isFilled = index < filled
                Circle()
                    .fill(isError ? AppColor.pinError : (isFilled ? AppColor.cream : Color.clear))
                    .overlay(Circle().stroke(isError ? AppColor.pinError : AppColor.cream, lineWidth: 2))
                    .frame(width: 16, height: 16)
                    .scaleEffect(isFilled ? 1.15 : 1)
                    .animation(.spring(duration: 0.2), value: isFilled)
            }
        }
        .modifier(ShakeEffect(shakes: CGFloat(shakeTrigger)))
        .animation(.linear(duration: 0.35), value: shakeTrigger)
    }
}
