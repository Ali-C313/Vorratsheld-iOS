//
//  ScanFrame.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct ScanFrame: View {
    @State private var down = false

    var body: some View {
        ZStack(alignment: .top) {
            ScanCorners()
                .stroke(.white, style: StrokeStyle(lineWidth: 5, lineCap: .round))
            Rectangle()
                .fill(AppColor.gold)
                .frame(height: 3)
                .padding(.horizontal, 16)
                .offset(y: down ? 180 * 0.85 : 180 * 0.15)
        }
        .frame(width: 280, height: 180)
        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: down)
        .onAppear { down = true }
    }
}
