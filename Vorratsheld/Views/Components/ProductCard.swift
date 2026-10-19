//
//  ProductCard.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct ProductCard: View {
    let product: Product
    let onFavoriteToggle: () -> Void

    var body: some View {
        let urgency = DateHelper.expiryUrgency(for: product.expiryDate)

        HStack(spacing: 12) {
            ProductImage(url: product.imageUrl)
                .frame(width: 48, height: 48)
                .background(AppColor.surfaceVariant)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(product.name)
                        .font(.headline)
                        .lineLimit(1)
                    if product.quantity > 1 {
                        Text("\(product.quantity)×")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(AppColor.primary)
                    }
                }
                Text(expiryLabel(daysLeft: DateHelper.daysUntilExpiry(product.expiryDate)))
                    .font(.caption)
                    .foregroundStyle(AppColor.onSurfaceVariant)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if urgency != .unkritisch {
                UrgencyBadge(urgency: urgency)
            }

            Button(action: onFavoriteToggle) {
                Image(systemName: product.isFavorite ? "star.fill" : "star")
                    .font(.title3)
                    .foregroundStyle(product.isFavorite ? AppColor.favorite : AppColor.onSurfaceVariant)
                    .frame(width: 40, height: 40)
            }
            .buttonStyle(.borderless)
            .accessibilityLabel(S.favorite)
        }
        .padding(14)
        .background(AppColor.surface, in: RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(AppColor.outlineVariant, lineWidth: 0.5))
        .shadow(color: .black.opacity(0.06), radius: 3, y: 1)
    }
}

#Preview {
    ProductCard(
        product: Product(userId: "preview", name: "Vollmilch 1L", expiryDate: LocalDay.today().millis, quantity: 2, isFavorite: true),
        onFavoriteToggle: {}
    )
    .padding()
}
