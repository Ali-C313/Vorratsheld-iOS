//
//  QuantityStepper.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct QuantityStepper: View {
    let quantity: Int
    let onQuantityChange: (Int) -> Void

    var body: some View {
        HStack(spacing: 0) {
            Button { onQuantityChange(-1) } label: {
                Image(systemName: "minus").frame(width: 34, height: 34)
            }
            .disabled(quantity <= 1)
            Text("\(quantity)")
                .font(.subheadline.bold())
                .frame(minWidth: 20)
                .contentTransition(.numericText(value: Double(quantity)))
            Button { onQuantityChange(1) } label: {
                Image(systemName: "plus").frame(width: 34, height: 34)
            }
        }
        .font(.footnote.weight(.semibold))
        .buttonStyle(.borderless)
        .background(AppColor.surfaceContainerHigh, in: Capsule())
        .animation(.default, value: quantity)
    }
}
