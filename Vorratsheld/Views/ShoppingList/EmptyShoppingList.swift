//
//  EmptyShoppingList.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct EmptyShoppingList: View {
    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: "cart")
                .font(.system(size: 52))
                .foregroundStyle(AppColor.onPrimaryContainer)
                .frame(width: 120, height: 120)
                .background(AppColor.primaryContainer, in: Circle())
            Text(S.shoppingEmptyTitle)
                .font(.title3.bold())
                .padding(.top, 20)
            Text(S.shoppingEmpty)
                .font(.subheadline)
                .foregroundStyle(AppColor.onSurfaceVariant)
                .multilineTextAlignment(.center)
                .padding(.top, 8)
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
