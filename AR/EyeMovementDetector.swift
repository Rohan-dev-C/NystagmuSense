//
//  EyeMovementDetector.swift
//  
//
//  Created by Rohan Sampath on 6/28/25.
//

import simd

struct EyeMovementDetector {
    static func velocityDegPerSec(from previous: EyeMovementSample,
                                  to current: EyeMovementSample) -> Float {
        let dt = Float(current.timestamp - previous.timestamp)
        guard dt > 0 else { return 0 }

        let yawPrev = atan2f(previous.leftGaze.x, previous.leftGaze.z)
        let yawCurr = atan2f(current.leftGaze.x,  current.leftGaze.z)

        let dyaw = remainderf(yawCurr - yawPrev, .pi * 2)

        return dyaw / dt * 180 / .pi
    }
}
