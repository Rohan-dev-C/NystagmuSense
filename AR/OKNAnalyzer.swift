//
//  OKNAnalyzer.swift
//  
//
//  Created by Rohan Sampath on 6/28/25.
//

import Foundation

struct OKNAnalyzer {
    private let window         = 60          // samples
    private let flipThreshold  = 2
    private let speedThreshold: Float = 5    // °/s

    func isOptokineticLost(in samples: [EyeMovementSample]) -> Bool {
        guard samples.count >= window else { return false }

        let slice      = samples.suffix(window)
        let velocities = slice.map(\.velocity)

        let meanAbs = velocities.reduce(0, +) / Float(velocities.count)
            |> abs

        let flips = zip(velocities, velocities.dropFirst())
            .filter { $0.0.sign != $0.1.sign }
            .count

        return flips < flipThreshold || meanAbs < speedThreshold
    }
}

