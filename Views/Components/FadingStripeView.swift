//
//  FadingStripeView.swift
//  
//
//  Created by Rohan Sampath on 6/28/25.
//
import SwiftUI

struct FadingStripeView: View {
    /// Exposed binding so TestViewModel can read current shade 0–100
    @Binding var shade: Double

    @State private var phase: Double = 0

    var body: some View {
        TimelineView(.animation) { _ in
            geometry
        }
        .onAppear { runAnimation() }
    }

    // MARK: - Drawing
    @ViewBuilder
    private var geometry: some View {
        GeometryReader { geo in
            Canvas { ctx, size in
                let stripeH = size.height / 12
                let stripes = Int(ceil(size.height / stripeH))

                for i in 0..<stripes {
                    let y = CGFloat(i) * stripeH
                    let rect = CGRect(x: 0, y: y, width: size.width, height: stripeH)
                    ctx.fill(Path(rect), with: .color(.black))
                }
            }
            // mask controls background shade
            .mask(Rectangle().fill(Color(white: 1.0 - currentLuminance)))
        }
    }

    private var currentLuminance: Double {
        let f = phase <= 0.5 ? 1 - phase * 2 : (phase - 0.5) * 2
        DispatchQueue.main.async { self.shade = (1 - f) * 100 }
        return f
    }

    private func runAnimation() {
        withAnimation(.linear(duration: 60).repeatForever(autoreverses: false)) {
            phase = 1         
        }
    }
}
