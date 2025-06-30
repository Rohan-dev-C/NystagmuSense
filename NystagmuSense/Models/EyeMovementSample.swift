//
//  EyeMovementSample.swift
//  NystagmuSense
//
//  Created by Rohan Sampath on 6/30/25.
//

import Foundation
import simd

struct EyeMovementSample: Identifiable, Codable {
    var id = UUID()
    let timestamp: TimeInterval
    let leftGaze:  SIMD3<Float>
    let rightGaze: SIMD3<Float>
    var velocity:  Float          // °/s, horizontal component
}
