//
//  ShoppingRow.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct ShoppingRow: View {
    let item: ShoppingItem
    let onToggle: () -> Void
    let onQuantityChange: (Int) -> Void

    var body: some View {
        HStack(spacing: 12) {
            CheckCircle(checked: item.checked)
            Text(item.name)
                .font(.headline)
                .strikethrough(item.checked)
                .lineLimit(2)
                .opacity(item.checked ? 0.5 : 1)
                .frame(maxWidth: .infinity, alignment: .leading)
            if item.checked {
                Text("\(item.quantity)×")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppColor.onSurfaceVariant)
                    .padding(.trailing, 8)
            } else {
                QuantityStepper(quantity: item.quantity, onQuantityChange: onQuantityChange)
            }
        }
        .padding(.leading, 14)
        .padding(.trailing, 6)
        .padding(.vertical, 10)
        .background(AppColor.surface, in: RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(AppColor.outlineVariant, lineWidth: 0.5))
        .contentShape(Rectangle())
        .onTapGesture(perform: onToggle)
    }
}
