//
//  EyeMovementSample.swift
//  
//
//  Created by Rohan Sampath on 6/28/25.
//

import Foundation
struct EyeMovementSample: Codable, Identifiable {
    let id = UUID()
    let timestamp: TimeInterval
    let leftGaze: SIMD3<Float>
    let rightGaze: SIMD3<Float>
    let velocity: Float
}
