//
//  UrgencyBadge.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct UrgencyBadge: View {
    let urgency: ExpiryUrgency

    var body: some View {
        Text(label)
            .font(.caption2.weight(.semibold))
            .foregroundStyle(colors.content)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(colors.background, in: RoundedRectangle(cornerRadius: 8))
    }

    private var label: String {
        switch urgency {
        case .abgelaufen: return S.urgencyExpired
        case .baldAblaufend: return S.urgencySoon
        case .inKuerze: return S.urgencyShort
        case .unkritisch: return S.urgencyOk
        }
    }

    private var colors: (background: Color, content: Color) {
        switch urgency {
        case .abgelaufen, .baldAblaufend: return (AppColor.errorContainer, AppColor.onErrorContainer)
        case .inKuerze: return (AppColor.warningContainer, AppColor.onWarningContainer)
        case .unkritisch: return (AppColor.surfaceVariant, AppColor.onSurfaceVariant)
        }
    }
}

#Preview {
    UrgencyBadge(urgency: .baldAblaufend)
}
