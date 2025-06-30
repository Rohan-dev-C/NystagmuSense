//
//  EyeMovementDetector.swift
//  NystagmuSense
//
//  Created by Rohan Sampath on 6/30/25.
//
import simd
struct EyeMovementDetector {
    static func velocityDegPerSec(from a: EyeMovementSample,
                                  to b: EyeMovementSample) -> Float {
        let dt = Float(b.timestamp - a.timestamp)
        guard dt > 0 else { return 0 }
        let yawA = atan2f(a.leftGaze.x, a.leftGaze.z)
        let yawB = atan2f(b.leftGaze.x, b.leftGaze.z)
        let dYaw = remainderf(yawB - yawA, .pi * 2)
        return dYaw / dt * 180 / .pi
    }
}

