//
//  AccentBlob.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct AccentBlob: View {
    let color: Color
    @State private var breathe = false

    var body: some View {
        Circle()
            .fill(RadialGradient(colors: [color.opacity(0.28), color.opacity(0.06)], center: .center, startRadius: 0, endRadius: 130))
            .frame(width: 260, height: 260)
            .scaleEffect(breathe ? 1.05 : 0.92)
            .animation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true), value: breathe)
            .onAppear { breathe = true }
    }
}
