//
//  ActionBar.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct ActionBar: View {
    let onDeleteClick: () -> Void
    let onAddToListClick: () -> Void
    let onEditClick: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            CircleIconButton(icon: "trash", description: S.actionDelete, background: AppColor.errorContainer, foreground: AppColor.onErrorContainer, action: onDeleteClick)
            CircleIconButton(icon: "cart.badge.plus", description: S.infoAddToList, background: AppColor.secondaryContainer, foreground: AppColor.onSecondaryContainer, action: onAddToListClick)
            Button(action: onEditClick) {
                Label(S.actionEdit, systemImage: "pencil")
                    .font(.headline)
                    .foregroundStyle(AppColor.onPrimary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(AppColor.primary, in: RoundedRectangle(cornerRadius: 16))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.bar)
    }
}
