//
//  ScoreCalculator.swift
//  
//
//  Created by Rohan Sampath on 6/28/25.
//

import Foundation

enum ScoreCalculator {
    static func score(for shade: Double) -> Double {
        guard shade > 0 else { return 0 }
        let raw = log10(shade) / log10(100)
        return max(0, min(2, raw * 2))
    }
}
