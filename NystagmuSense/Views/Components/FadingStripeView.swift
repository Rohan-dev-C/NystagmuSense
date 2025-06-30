//
//  FadingStripeView.swift
//  NystagmuSense
//
//  Created by Rohan Sampath on 6/30/25.
//

import SwiftUI

struct FadingStripeView: View {

    // MARK: - Public binding
    @Binding var shade: Double               // 0 (white) … 100 (black)

    // MARK: - Tunables
    private let stripeWidthRatio: CGFloat = 0.01   // 1 % of screen width ≈ 3-4 px
    private let speedPixelsPerSec   : CGFloat = 60 // how fast stripes travel
    private let fadeHalfCycle       : Double  = 30 // seconds (white↔︎black)

    // MARK: - Animation state
    @State private var startDate = Date()

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 120.0)) { timeline in
            Canvas { ctx, size in
                // 1. Background luminance
                let lum = currentLuminance(date: timeline.date)
                ctx.fill(Path(CGRect(origin: .zero, size: size)),
                         with: .color(Color(white: lum)))

                // 2. Draw ultra-thin stripes that scroll endlessly
                drawStripes(in: &ctx, size: size, at: timeline.date)
            }
        }
        .ignoresSafeArea()
        .onAppear { startDate = .now }      // reset phase each test run
    }

    // MARK: - Drawing helpers
    private func stripeWidth(size: CGSize) -> CGFloat {
        max(1, size.width * stripeWidthRatio)        // at least 1 px
    }
    private func pitch(size: CGSize) -> CGFloat { stripeWidth(size: size) * 2 }

    private func drawStripes(in ctx: inout GraphicsContext,
                             size: CGSize,
                             at date: Date) {
        let w      = stripeWidth(size: size)
        let p      = pitch(size: size)
        let elapsed = CGFloat(date.timeIntervalSince(startDate))
        // Continuous offset: distance = speed * time  mod  pitch
        let offset = (elapsed * speedPixelsPerSec).truncatingRemainder(dividingBy: p)

        // Start a few pitches off-screen so the wrap is invisible
        var x = -3 * p + offset
        while x < size.width + p {
            ctx.fill(Path(CGRect(x: x, y: 0, width: w, height: size.height)),
                     with: .color(.black))
            x += p
        }
    }

    // MARK: - Luminance & shade
    private func currentLuminance(date: Date) -> CGFloat {
        let phase = (date.timeIntervalSince(startDate) / fadeHalfCycle)
                    .truncatingRemainder(dividingBy: 2)
        // phase 0…1 → white→black, 1…2 → black→white
        let lum = phase <= 1 ? 1 - phase : phase - 1

        // Update bound shade (0 = white, 100 = black)
        DispatchQueue.main.async { shade = (1 - lum) * 100 }
        return lum
    }
}
