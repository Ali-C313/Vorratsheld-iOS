//
//  ShoppingHeader.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct ShoppingHeader: View {
    let doneCount: Int
    let totalCount: Int
    let onBackClick: () -> Void
    let onClearDone: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 8) {
                CircleIconButton(icon: "chevron.backward", description: S.actionBack, background: .clear, foreground: AppColor.cream, action: onBackClick)
                Text(S.shoppingTitle)
                    .font(.title3.bold())
                    .foregroundStyle(AppColor.cream)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if doneCount > 0 {
                    CircleIconButton(icon: "trash.slash", description: S.shoppingClearDone, background: .white.opacity(0.18), foreground: AppColor.cream, action: onClearDone)
                        .transition(.scale.combined(with: .opacity))
                }
            }

            if totalCount > 0 {
                Text(S.shoppingProgress(doneCount, totalCount))
                    .font(.subheadline)
                    .foregroundStyle(AppColor.cream.opacity(0.85))
                    .padding(.top, 8)
                    .padding(.bottom, 8)
                ProgressView(value: Double(doneCount), total: Double(max(totalCount, 1)))
                    .tint(AppColor.gold)
                    .scaleEffect(x: 1, y: 2.5, anchor: .center)
                    .clipShape(Capsule())
            }
        }
        .animation(.default, value: doneCount)
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 20)
        .background(
            UnevenRoundedRectangle(bottomLeadingRadius: 32, bottomTrailingRadius: 32)
                .fill(AppColor.headerGradient)
                .ignoresSafeArea(edges: .top)
        )
    }
}
