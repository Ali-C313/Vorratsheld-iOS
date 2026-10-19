//
//  Pill.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct Pill: View {
    let icon: String?
    let text: String
    let background: Color
    let content: Color

    var body: some View {
        HStack(spacing: 6) {
            if let icon {
                Image(systemName: icon).font(.caption)
            }
            Text(text).font(.subheadline.weight(.semibold))
        }
        .foregroundStyle(content)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(background, in: Capsule())
    }
}

struct ExpiryPill: View {
    let expiryDate: Int64

    var body: some View {
        let colors: (Color, Color) = {
            switch DateHelper.expiryUrgency(for: expiryDate) {
            case .abgelaufen, .baldAblaufend: return (AppColor.errorContainer, AppColor.onErrorContainer)
            case .inKuerze: return (AppColor.warningContainer, AppColor.onWarningContainer)
            case .unkritisch: return (AppColor.primaryContainer, AppColor.onPrimaryContainer)
            }
        }()
        Pill(icon: nil, text: expiryLabel(daysLeft: DateHelper.daysUntilExpiry(expiryDate)), background: colors.0, content: colors.1)
    }
}
