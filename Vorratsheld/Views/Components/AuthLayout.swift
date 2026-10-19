//
//  AuthLayout.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct AuthLayout<Content: View>: View {
    let title: String
    let subtitle: String
    @ViewBuilder var content: () -> Content

    @State private var start = Date()

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                TimelineView(.animation) { timeline in
                    let t = timeline.date.timeIntervalSince(start)
                    VStack(spacing: 8) {
                        VorratsheldLogo(capeAngle: 4 * sin(t * .pi / 0.9))
                            .frame(width: 110, height: 110)
                        Text(S.appName)
                            .font(.system(size: 28, weight: .heavy))
                            .foregroundStyle(AppColor.cream)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 24)
                .padding(.bottom, 56)
                .background(AppColor.headerGradient.ignoresSafeArea(edges: .top))

                VStack(alignment: .leading, spacing: 0) {
                    Text(title)
                        .font(.title2.bold())
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(AppColor.onSurfaceVariant)
                        .padding(.top, 4)
                    content()
                        .padding(.top, 24)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 28)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    UnevenRoundedRectangle(topLeadingRadius: 32, topTrailingRadius: 32)
                        .fill(AppColor.background)
                )
                .offset(y: -32)
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .background(AppColor.background)
    }
}

#Preview {
    AuthLayout(title: "Login", subtitle: "Willkommen zurück!") {
        PrimaryButton(text: "Einloggen") {}
    }
}
