//
//  VorratsheldLogo.swift
//  Vorratsheld
//
//  Created by Ali Chehab on 18.10.26.
//

import SwiftUI

// Logo als Canvas, damit sich Umhang, Deckel und Stern animieren lassen
// Gezeichnet im 1024er-Raster
struct VorratsheldLogo: View, Animatable {
    var capeAngle: Double = 0
    var lidOffset: Double = 0
    var starScale: Double = 1
    var starRotation: Double = 0

    var animatableData: AnimatablePair<AnimatablePair<Double, Double>, AnimatablePair<Double, Double>> {
        get { AnimatablePair(AnimatablePair(capeAngle, lidOffset), AnimatablePair(starScale, starRotation)) }
        set {
            capeAngle = newValue.first.first
            lidOffset = newValue.first.second
            starScale = newValue.second.first
            starRotation = newValue.second.second
        }
    }

    var body: some View {
        Canvas { context, size in
            let factor = min(size.width, size.height) / 1024
            var ctx = context
            ctx.scaleBy(x: factor, y: factor)
            // Etwas nach oben, sonst sitzt das Logo zu tief
            ctx.translateBy(x: 0, y: -25)
            drawCape(ctx)
            drawJar(ctx)
            drawStar(ctx)
        }
    }

    private func drawCape(_ context: GraphicsContext) {
        var ctx = context
        ctx.rotate(around: CGPoint(x: 512, y: 360), degrees: capeAngle)

        let cape = Path { p in
            p.move(to: CGPoint(x: 400, y: 360))
            p.addLine(to: CGPoint(x: 624, y: 360))
            p.addCurve(to: CGPoint(x: 820, y: 820), control1: CGPoint(x: 690, y: 470), control2: CGPoint(x: 760, y: 640))
            p.addQuadCurve(to: CGPoint(x: 730, y: 815), control: CGPoint(x: 770, y: 790))
            p.addQuadCurve(to: CGPoint(x: 640, y: 815), control: CGPoint(x: 680, y: 790))
            p.addQuadCurve(to: CGPoint(x: 545, y: 815), control: CGPoint(x: 590, y: 790))
            p.addQuadCurve(to: CGPoint(x: 455, y: 815), control: CGPoint(x: 500, y: 790))
            p.addQuadCurve(to: CGPoint(x: 365, y: 815), control: CGPoint(x: 410, y: 790))
            p.addQuadCurve(to: CGPoint(x: 284, y: 818), control: CGPoint(x: 320, y: 790))
            p.addCurve(to: CGPoint(x: 400, y: 360), control1: CGPoint(x: 300, y: 640), control2: CGPoint(x: 340, y: 470))
            p.closeSubpath()
        }
        ctx.fill(cape, with: .color(AppColor.logoCapeRed))

        let shadow = Path { p in
            p.move(to: CGPoint(x: 400, y: 360))
            p.addCurve(to: CGPoint(x: 284, y: 818), control1: CGPoint(x: 340, y: 470), control2: CGPoint(x: 300, y: 640))
            p.addQuadCurve(to: CGPoint(x: 365, y: 815), control: CGPoint(x: 320, y: 790))
            p.addCurve(to: CGPoint(x: 430, y: 370), control1: CGPoint(x: 370, y: 650), control2: CGPoint(x: 390, y: 500))
            p.closeSubpath()
        }
        ctx.fill(shadow, with: .color(AppColor.logoCapeShadow))
    }

    private func drawJar(_ context: GraphicsContext) {
        // Glas
        context.fill(rounded(337, 353, 350, 410, 78), with: .color(AppColor.logoJar))
        // Glanz
        context.fill(rounded(372, 395, 30, 230, 15), with: .color(.white.opacity(0.75)))
        // Etikett
        context.fill(rounded(412, 463, 200, 190, 26), with: .color(AppColor.logoLabel))
        // Hals
        context.fill(rounded(397, 330, 230, 34, 10), with: .color(AppColor.logoNeck))
        // Deckel (kann von oben "einrasten")
        var lid = context
        lid.translateBy(x: 0, y: -lidOffset)
        lid.fill(rounded(377, 255, 270, 78, 22), with: .color(AppColor.logoLid))
        lid.fill(rounded(377, 303, 270, 30, 12), with: .color(AppColor.logoLidShadow.opacity(0.55)))
    }

    private func drawStar(_ context: GraphicsContext) {
        guard starScale > 0 else { return }
        let center = CGPoint(x: 512, y: 562)
        let star = Path { p in
            for i in 0..<10 {
                let radius: Double = i % 2 == 0 ? 62 : 28
                let angle = -Double.pi / 2 + Double(i) * Double.pi / 5
                let point = CGPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
                if i == 0 { p.move(to: point) } else { p.addLine(to: point) }
            }
            p.closeSubpath()
        }
        var ctx = context
        ctx.translateBy(x: center.x, y: center.y)
        ctx.rotate(by: .degrees(starRotation))
        ctx.scaleBy(x: starScale, y: starScale)
        ctx.translateBy(x: -center.x, y: -center.y)
        ctx.fill(star, with: .color(AppColor.logoStar))
    }

    private func rounded(_ x: Double, _ y: Double, _ w: Double, _ h: Double, _ r: Double) -> Path {
        Path(roundedRect: CGRect(x: x, y: y, width: w, height: h), cornerRadius: r)
    }
}

private extension GraphicsContext {
    mutating func rotate(around pivot: CGPoint, degrees: Double) {
        translateBy(x: pivot.x, y: pivot.y)
        rotate(by: .degrees(degrees))
        translateBy(x: -pivot.x, y: -pivot.y)
    }
}

#Preview {
    VorratsheldLogo()
        .frame(width: 160, height: 160)
}
