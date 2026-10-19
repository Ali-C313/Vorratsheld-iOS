//
//  ScanCorners.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

struct ScanCorners: Shape {
    var corner: CGFloat = 36

    func path(in rect: CGRect) -> Path {
        Path { p in
            let points: [(CGPoint, CGFloat, CGFloat)] = [
                (CGPoint(x: rect.minX, y: rect.minY), 1, 1),
                (CGPoint(x: rect.maxX, y: rect.minY), -1, 1),
                (CGPoint(x: rect.minX, y: rect.maxY), 1, -1),
                (CGPoint(x: rect.maxX, y: rect.maxY), -1, -1)
            ]
            for (point, dx, dy) in points {
                p.move(to: CGPoint(x: point.x + corner * dx, y: point.y))
                p.addLine(to: point)
                p.addLine(to: CGPoint(x: point.x, y: point.y + corner * dy))
            }
        }
    }
}
