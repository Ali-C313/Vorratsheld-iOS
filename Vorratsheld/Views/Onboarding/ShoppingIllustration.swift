//
//  ShoppingIllustration.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

// Seite 4: Einkaufswagen mit Stern und Haken
struct ShoppingIllustration: View {
    @State private var bounce = false

    var body: some View {
        ZStack {
            BigIcon(icon: "cart.fill", tint: AppColor.logoCapeRed)

            Image(systemName: "star.fill")
                .font(.system(size: 40))
                .foregroundStyle(AppColor.gold)
                .scaleEffect(bounce ? 1.15 : 1)
                .animation(.linear(duration: 0.7).repeatForever(autoreverses: true), value: bounce)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)

            Image(systemName: "checkmark")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 40, height: 40)
                .background(AppColor.splashGreen, in: Circle())
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
        }
        .frame(width: 170, height: 170)
        .onAppear { bounce = true }
    }
}
