//
//  SplashView.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

// Ladescreen mit Logo-Animation
struct SplashView: View {
    let onFinished: () -> Void

    @State private var logoScale = 0.0
    @State private var lidOffset = 260.0
    @State private var starScale = 0.0
    @State private var starRotation = -180.0
    @State private var titleVisible = false
    @State private var taglineVisible = false
    @State private var exitOpacity = 1.0
    @State private var start = Date()

    var body: some View {
        ZStack {
            RadialGradient(
                colors: [AppColor.splashGreenLight, AppColor.splashGreen, AppColor.splashGreenDark],
                center: .center,
                startRadius: 0,
                endRadius: 600
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                TimelineView(.animation) { timeline in
                    let t = timeline.date.timeIntervalSince(start)
                    ZStack {
                        rings(time: t)
                        VorratsheldLogo(
                            capeAngle: 5 * sin(t * .pi / 0.7),
                            lidOffset: lidOffset,
                            starScale: starScale,
                            starRotation: starRotation
                        )
                        .frame(width: 200, height: 200)
                        .scaleEffect(logoScale)
                    }
                    .frame(width: 260, height: 260)
                }

                Text(S.appName)
                    .font(.system(size: 40, weight: .heavy))
                    .tracking(1)
                    .foregroundStyle(AppColor.cream)
                    .opacity(titleVisible ? 1 : 0)
                    .offset(y: titleVisible ? 0 : 40)
                    .padding(.top, 24)

                Text(S.splashTagline)
                    .font(.headline)
                    .foregroundStyle(AppColor.cream.opacity(0.85))
                    .opacity(taglineVisible ? 1 : 0)
                    .padding(.top, 8)
            }
            .opacity(exitOpacity)
        }
        .task { await runIntro() }
    }

    // Ringe hinter dem Logo, Glitzer erst wenn der Stern da ist
    private func rings(time t: Double) -> some View {
        Canvas { context, size in
            let maxRadius = min(size.width, size.height) / 2
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let ringProgress = t.truncatingRemainder(dividingBy: 2.2) / 2.2

            for i in 0..<3 {
                let p = (ringProgress + Double(i) / 3).truncatingRemainder(dividingBy: 1)
                let radius = maxRadius * (0.45 + 0.55 * p)
                let rect = CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2)
                context.stroke(
                    Path(ellipseIn: rect),
                    with: .color(AppColor.cream.opacity((1 - p) * 0.35 * min(max(logoScale, 0), 1))),
                    lineWidth: 3
                )
            }

            guard starScale > 0.5 else { return }
            let sparkle = t.truncatingRemainder(dividingBy: 1.8) / 1.8 * 2 * .pi
            for i in 0..<6 {
                let angle = sparkle + Double(i) * .pi / 3
                let r = maxRadius * 0.78
                let twinkle = (sin(sparkle * 2 + Double(i)) + 1) / 2
                let dot = 2.5 + 3 * twinkle
                let point = CGPoint(x: center.x + r * cos(angle), y: center.y + r * sin(angle))
                context.fill(
                    Path(ellipseIn: CGRect(x: point.x - dot, y: point.y - dot, width: dot * 2, height: dot * 2)),
                    with: .color(AppColor.gold.opacity(0.3 + 0.7 * twinkle))
                )
            }
        }
    }

    private func runIntro() async {
        // 1. Glas federt rein
        withAnimation(.spring(response: 0.7, dampingFraction: 0.45)) { logoScale = 1 }
        try? await Task.sleep(for: .milliseconds(350))
        // 2. Deckel fällt drauf
        withAnimation(.spring(response: 0.5, dampingFraction: 0.35)) { lidOffset = 0 }
        try? await Task.sleep(for: .milliseconds(450))
        // 3. Stern dreht sich rein
        withAnimation(.spring(response: 0.45, dampingFraction: 0.4)) { starScale = 1 }
        withAnimation(.easeInOut(duration: 0.6)) { starRotation = 0 }
        try? await Task.sleep(for: .milliseconds(150))
        withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) { titleVisible = true }
        try? await Task.sleep(for: .milliseconds(600))
        withAnimation(.easeIn(duration: 0.45)) { taglineVisible = true }
        try? await Task.sleep(for: .milliseconds(1150))
        // 4. Ausblenden
        withAnimation(.easeOut(duration: 0.35)) { exitOpacity = 0 }
        try? await Task.sleep(for: .milliseconds(350))
        onFinished()
    }
}

#Preview {
    SplashView {}
}
