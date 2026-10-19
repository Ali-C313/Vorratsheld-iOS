//
//  InfoTile.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct InfoTile: View {
    let icon: String
    let label: String
    let value: String
    var monospace = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(AppColor.onPrimaryContainer)
                .frame(width: 36, height: 36)
                .background(AppColor.primaryContainer, in: Circle())
            Text(label)
                .font(.caption.weight(.medium))
                .foregroundStyle(AppColor.onSurfaceVariant)
                .lineLimit(1)
                .padding(.top, 10)
            Text(value)
                .font(monospace ? .title3.bold().monospaced() : .title3.bold())
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(AppColor.surfaceContainerHigh, in: RoundedRectangle(cornerRadius: 20))
    }
}
