//
//  ScoreCard.swift
//  NystagmuSense
//
//  Created by Rohan Sampath on 6/30/25.
//

import SwiftUI
struct ScoreCard: View {
    let score: Double
    var body: some View {
        Text(String(format: "Score %.2f", score))
            .padding(12)
            .background(.ultraThinMaterial,
                        in: RoundedRectangle(cornerRadius: 12))
    }
}
