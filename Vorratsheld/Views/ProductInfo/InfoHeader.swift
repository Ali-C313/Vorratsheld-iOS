//
//  InfoHeader.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct InfoHeader: View {
    let product: Product

    var body: some View {
        ZStack {
            AppColor.headerGradient
            if product.imageUrl != nil {
                ProductImage(url: product.imageUrl, iconSize: 80)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                // Abdunkeln, damit die Buttons auf hellen Bildern sichtbar sind
                LinearGradient(colors: [.black.opacity(0.35), .clear], startPoint: .top, endPoint: .center)
            } else {
                Image(systemName: "shippingbox")
                    .font(.system(size: 80))
                    .foregroundStyle(AppColor.cream.opacity(0.9))
            }
        }
        .frame(height: 280)
        .clipped()
    }
}
