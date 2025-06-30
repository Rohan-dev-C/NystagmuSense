//
//  TestViewModel.swift
//  NystagmuSense
//
//  Created by Rohan Sampath on 6/30/25.
//

import Combine
import SwiftUI

@MainActor
final class TestViewModel: ObservableObject {
    @Published var shadeLevel: Double = 0        // 0–100
    @Published var score:      Double?           // 0–2 finished
    @Published var running     = false

    private var samples: [EyeMovementSample] = []
    private let maxBuf = 120                     // last ~2 s
    private let eyeSession = EyeTrackingSession()
    private let okn        = OKNAnalyzer()
    private let scorer     = ScoreCalculator()
    private var bags       = Set<AnyCancellable>()

    init() {
        eyeSession.$sample
            .compactMap { $0 }
            .sink { [weak self] in self?.ingest($0) }
            .store(in: &bags)
    }

    func start() { running = true; eyeSession.start() }
    func stop()  { running = false; eyeSession.stop() }

    private func ingest(_ s: EyeMovementSample) {
        samples.append(s)
        if samples.count > maxBuf { samples.removeFirst() }

        if okn.isOptokineticLost(in: samples) {
            finish()
        }
    }

    private func finish() {
        stop()
        score = scorer.score(fromShade: shadeLevel)
        save()
    }

    private func save() {
        let ctx = PersistenceController.shared.container.viewContext
        let r   = TestResult(context: ctx)
        r.id         = UUID()
        r.date       = .now
        r.score      = score ?? 0
        r.shadeLevel = shadeLevel
        r.duration   = 60
        try? ctx.save()
    }
}
