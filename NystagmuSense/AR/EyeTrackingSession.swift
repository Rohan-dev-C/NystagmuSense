//
//  EyeTrackingSession.swift
//  NystagmuSense
//
//  Created by Rohan Sampath on 6/30/25.
//

import ARKit
import Combine

final class EyeTrackingSession: NSObject, ARSessionDelegate, ObservableObject {
    @Published var sample: EyeMovementSample?
    private let session = ARSession()
    private var prev: EyeMovementSample?

    func start() {
        guard ARFaceTrackingConfiguration.isSupported else { return }
        let cfg = ARFaceTrackingConfiguration()
        cfg.isWorldTrackingEnabled = false
        session.delegate = self
        session.run(cfg, options: [.resetTracking])
    }
    func stop() { session.pause(); prev = nil }

    func session(_ s: ARSession, didUpdate f: ARFrame) {
        guard let face = f.anchors.compactMap({ $0 as? ARFaceAnchor }).first else { return }
        let l = face.leftEyeTransform.columns.3, r = face.rightEyeTransform.columns.3
        var cur = EyeMovementSample(
            timestamp: f.timestamp,
            leftGaze:  .init(l.x, l.y, l.z),
            rightGaze: .init(r.x, r.y, r.z),
            velocity:  0
        )
        if let p = prev {
            cur.velocity = EyeMovementDetector.velocityDegPerSec(from: p, to: cur)
        }
        prev = cur
        sample = cur
    }
}
