//
//  CheckCircle.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct CheckCircle: View {
    let checked: Bool

    var body: some View {
        ZStack {
            Circle()
                .fill(checked ? AppColor.primary : Color.clear)
            Circle()
                .stroke(checked ? AppColor.primary : AppColor.outline, lineWidth: 2)
            if checked {
                Image(systemName: "checkmark")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(AppColor.onPrimary)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .frame(width: 28, height: 28)
        .animation(.spring(duration: 0.25), value: checked)
        .accessibilityLabel(S.shoppingCheck)
    }
}
