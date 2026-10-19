//
//  OverviewHeader.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct OverviewHeader: View {
    let firstName: String
    let fullName: String
    let photoBase64: String?
    let expiredCount: Int
    let soonCount: Int
    let totalCount: Int
    let onShoppingListClick: () -> Void
    let onSettingsClick: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 12) {
                Button(action: onSettingsClick) {
                    ProfileAvatar(photoBase64: photoBase64, name: fullName, size: 48)
                }
                .buttonStyle(.plain)

                VStack(alignment: .leading, spacing: 2) {
                    Text(firstName.isEmpty ? S.overviewGreetingAnonymous : S.overviewGreeting(firstName))
                        .font(.title3.bold())
                        .foregroundStyle(AppColor.cream)
                    Text(S.overviewSubtitle)
                        .font(.subheadline)
                        .foregroundStyle(AppColor.cream.opacity(0.8))
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                CircleIconButton(icon: "cart.fill", description: S.overviewShoppingList, background: .white.opacity(0.18), foreground: AppColor.cream, action: onShoppingListClick)
                CircleIconButton(icon: "gearshape.fill", description: S.overviewSettings, background: .white.opacity(0.18), foreground: AppColor.cream, action: onSettingsClick)
            }

            HStack(spacing: 10) {
                StatTile(label: S.statExpired, count: expiredCount, background: Color(hex: 0xFFDAD6), content: Color(hex: 0x93000A))
                StatTile(label: S.statSoon, count: soonCount, background: AppColor.warningContainer, content: AppColor.onWarningContainer)
                StatTile(label: S.statTotal, count: totalCount, background: AppColor.cream, content: AppColor.greenDark)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 24)
        .background(
            UnevenRoundedRectangle(bottomLeadingRadius: 32, bottomTrailingRadius: 32)
                .fill(AppColor.headerGradient)
                .ignoresSafeArea(edges: .top)
        )
    }
}
