//
//  TextFrame.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct TextFrame: View {
    let found: Bool
    @State private var pulse = false

    var body: some View {
        ScanCorners(corner: 28)
            .stroke(
                found ? Color(hex: 0x7BC67B) : Color.white.opacity(pulse ? 1 : 0.55),
                style: StrokeStyle(lineWidth: 5, lineCap: .round)
            )
            .frame(width: 300, height: 110)
            .animation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true), value: pulse)
            .onAppear { pulse = true }
    }
}
