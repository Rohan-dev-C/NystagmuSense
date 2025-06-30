//
//  OKNAnalyzer.swift
//  NystagmuSense
//
//  Created by Rohan Sampath on 6/30/25.
//

import Foundation
struct OKNAnalyzer {
    private let window = 60, flipLimit = 2, speedLimit: Float = 5
    func isOptokineticLost(in buf: [EyeMovementSample]) -> Bool {
        guard buf.count >= window else { return false }
        let v = buf.suffix(window).map(\.velocity)
        let mean = v.reduce(0, +) / Float(v.count) |> abs
        let flips = zip(v, v.dropFirst()).filter { $0.0.sign != $0.1.sign }.count
        return flips < flipLimit || mean < speedLimit
    }
}
