//
//  BigIcon.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct BigIcon: View {
    let icon: String
    let tint: Color
    var rotation: Double = 0

    var body: some View {
        Circle()
            .fill(AppColor.surface)
            .shadow(color: .black.opacity(0.15), radius: 8, y: 4)
            .frame(width: 150, height: 150)
            .overlay(
                Image(systemName: icon)
                    .font(.system(size: 70))
                    .foregroundStyle(tint)
                    .rotationEffect(.degrees(rotation), anchor: UnitPoint(x: 0.5, y: 0.1))
            )
    }
}
