//
//  EyeTrackingSession.swift
//  
//
//  Created by Rohan Sampath on 6/28/25.
//

import Foundation
import ARKit
import Combine

final class EyeTrackingSession: NSObject, ARSessionDelegate, ObservableObject {
    @Published var sample: EyeMovementSample?

    private let session  = ARSession()
    private var previous: EyeMovementSample?

    func start() {
        guard ARFaceTrackingConfiguration.isSupported else { return }

        let config = ARFaceTrackingConfiguration()
        config.isWorldTrackingEnabled      = false
        config.isLightEstimationEnabled    = false
        config.maximumNumberOfTrackedFaces = 1

        session.delegate = self
        session.run(config, options: [.resetTracking])
    }

    func stop() {
        session.pause()
        previous = nil
    }

    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        guard let face = frame.anchors.compactMap({ $0 as? ARFaceAnchor }).first else { return }

        let t  = frame.timestamp
        let lT = face.leftEyeTransform.columns.3
        let rT = face.rightEyeTransform.columns.3

        var current = EyeMovementSample(
            timestamp: t,
            leftGaze:  .init(lT.x, lT.y, lT.z),
            rightGaze: .init(rT.x, rT.y, rT.z),
            velocity:  0
        )

        if let prev = previous {
            current.velocity = EyeMovementDetector
                .velocityDegPerSec(from: prev, to: current)
        }

        previous = current
        sample   = current
    }
}
