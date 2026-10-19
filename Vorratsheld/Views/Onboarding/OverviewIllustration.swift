//
//  OverviewIllustration.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

// Seite 2: kleine Produktkarten mit Ablauf-Farben, die schweben
struct OverviewIllustration: View {
    @State private var float = false

    var body: some View {
        let items: [(String, Color, CGFloat)] = [
            (S.storageFridge, AppColor.error, 0.45),
            (S.storagePantry, AppColor.gold, 0.7),
            (S.storageFridge, AppColor.primary, 0.9)
        ]
        VStack(spacing: 12) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                HStack(spacing: 10) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AppColor.surfaceVariant)
                        .frame(width: 28, height: 28)
                    VStack(alignment: .leading, spacing: 6) {
                        Text(item.0)
                            .font(.caption.weight(.medium))
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule().fill(item.1.opacity(0.2))
                                Capsule().fill(item.1).frame(width: geo.size.width * item.2)
                            }
                        }
                        .frame(height: 6)
                    }
                    Circle()
                        .fill(item.1)
                        .frame(width: 12, height: 12)
                }
                .padding(12)
                .frame(width: 210)
                .background(AppColor.surface, in: RoundedRectangle(cornerRadius: 14))
                .shadow(color: .black.opacity(0.12), radius: 4, y: 2)
                .offset(y: (index % 2 == 0) == float ? 6 : -6)
            }
        }
        .animation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true), value: float)
        .onAppear { float = true }
    }
}
