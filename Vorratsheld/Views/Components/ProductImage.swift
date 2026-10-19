//
//  ProductImage.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct ProductImage: View {
    let url: String?
    var iconSize: CGFloat = 20

    var body: some View {
        if let url, let imageUrl = URL(string: url) {
            AsyncImage(url: imageUrl) { phase in
                if let image = phase.image {
                    image.resizable().scaledToFill()
                } else {
                    placeholder
                }
            }
        } else {
            placeholder
        }
    }

    private var placeholder: some View {
        Image(systemName: "shippingbox")
            .font(.system(size: iconSize))
            .foregroundStyle(AppColor.onSurfaceVariant)
    }
}
