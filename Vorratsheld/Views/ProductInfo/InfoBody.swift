//
//  InfoBody.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct InfoBody: View {
    let product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(product.name)
                .font(.title2.bold())

            HStack(spacing: 8) {
                Pill(icon: product.location.icon, text: product.location.label, background: AppColor.secondaryContainer, content: AppColor.onSecondaryContainer)
                ExpiryPill(expiryDate: product.expiryDate)
            }
            .padding(.top, 10)

            Grid(horizontalSpacing: 12, verticalSpacing: 12) {
                GridRow {
                    InfoTile(icon: "number", label: S.productQuantity, value: "\(product.quantity)×")
                    InfoTile(icon: "calendar", label: S.productExpiry, value: DateHelper.formatDate(product.expiryDate))
                }
                GridRow {
                    InfoTile(icon: product.location.icon, label: S.productLocation, value: product.location.label)
                    InfoTile(icon: "calendar.badge.plus", label: S.infoAdded, value: DateHelper.formatLocalDate(product.addedAt))
                }
                if !product.barcode.isEmpty {
                    GridRow {
                        InfoTile(icon: "barcode", label: S.infoBarcode, value: product.barcode, monospace: true)
                            .gridCellColumns(2)
                    }
                }
            }
            .padding(.top, 20)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            UnevenRoundedRectangle(topLeadingRadius: 28, topTrailingRadius: 28)
                .fill(AppColor.surface)
        )
    }
}
