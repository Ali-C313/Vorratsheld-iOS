//
//  ReminderIllustration.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

// Seite 3: Glocke, die bimmelt
struct ReminderIllustration: View {
    @State private var start = Date()

    var body: some View {
        TimelineView(.animation) { timeline in
            let t = timeline.date.timeIntervalSince(start).truncatingRemainder(dividingBy: 1.6) * 1000
            BigIcon(icon: "bell.badge.fill", tint: AppColor.logoLid, rotation: ringAngle(at: t))
        }
    }

    // Glocke schwingt kurz und ist dann ruhig
    private func ringAngle(at ms: Double) -> Double {
        let frames: [(Double, Double)] = [(0, 0), (100, -18), (200, 16), (300, -12), (400, 8), (520, 0), (1600, 0)]
        for i in 1..<frames.count where ms <= frames[i].0 {
            let (t0, a0) = frames[i - 1]
            let (t1, a1) = frames[i]
            return a0 + (a1 - a0) * (ms - t0) / (t1 - t0)
        }
        return 0
    }
}
