//
//  OverviewEmptyState.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct OverviewEmptyState: View {
    let onScanClick: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: "shippingbox")
                .font(.system(size: 52))
                .foregroundStyle(AppColor.onPrimaryContainer)
                .frame(width: 120, height: 120)
                .background(AppColor.primaryContainer, in: Circle())

            Text(S.overviewEmptyTitle)
                .font(.title3.bold())
                .multilineTextAlignment(.center)
                .padding(.top, 20)
            Text(S.overviewEmpty)
                .font(.subheadline)
                .foregroundStyle(AppColor.onSurfaceVariant)
                .multilineTextAlignment(.center)
                .padding(.top, 8)

            Button(action: onScanClick) {
                Label(S.overviewEmptyButton, systemImage: "barcode.viewfinder")
                    .font(.headline)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 14))
            .padding(.top, 20)
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 40)
        .frame(maxWidth: .infinity)
        .transition(.opacity.combined(with: .move(edge: .bottom)))
    }
}
