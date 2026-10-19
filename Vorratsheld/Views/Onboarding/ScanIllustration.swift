//
//  ScanIllustration.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

// Seite 1: Barcode mit wanderndem Scan-Strahl
struct ScanIllustration: View {
    @State private var scanDown = false

    private let widths: [CGFloat] = [3, 1, 2, 1, 3, 2, 1, 1, 3, 1, 2, 3, 1, 2, 1, 3, 1, 2]

    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            let unit = (size.width * 0.7) / (widths.reduce(0, +) * 1.6)
            ZStack(alignment: .topLeading) {
                ScanCorners(corner: 28)
                    .stroke(AppColor.primary, style: StrokeStyle(lineWidth: 5, lineCap: .round))

                HStack(alignment: .top, spacing: 0) {
                    ForEach(Array(widths.enumerated()), id: \.offset) { index, w in
                        Rectangle()
                            .fill(index % 2 == 0 ? AppColor.onSurface : Color.clear)
                            .frame(width: w * unit, height: size.height * 0.6)
                            .padding(.trailing, w * unit * 0.6)
                    }
                }
                .offset(x: size.width * 0.15, y: size.height * 0.2)

                let y = size.height * (scanDown ? 0.9 : 0.1)
                LinearGradient(colors: [.clear, AppColor.logoCapeRed.opacity(0.5), .clear], startPoint: .top, endPoint: .bottom)
                    .frame(height: 36)
                    .offset(y: y - 18)
                Rectangle()
                    .fill(AppColor.logoCapeRed)
                    .frame(width: size.width - 16, height: 3)
                    .offset(x: 8, y: y - 1.5)
            }
        }
        .frame(width: 180, height: 140)
        .animation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true), value: scanDown)
        .onAppear { scanDown = true }
    }
}
