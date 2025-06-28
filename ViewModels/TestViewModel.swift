//
//  TestViewModel.swift
//  
//
//  Created by Rohan Sampath on 6/28/25.
//

import Combine
import SwiftUI

@MainActor
final class TestViewModel: ObservableObject {
    @Published var shadeLevel: Double = 0          
    @Published var score:      Double?             
    @Published var running     = false

    private var samples: [EyeMovementSample] = []
    private let maxBuffer = 120

    private var cancellables = Set<AnyCancellable>()

    private let eyeSession = EyeTrackingSession()
    private let oknAnalyzer = OKNAnalyzer()
    private let scoreCalc   = ScoreCalculator()

    init() {
        eyeSession.$sample
            .compactMap { $0 }
            .sink { [weak self] in self?.ingest($0) }
            .store(in: &cancellables)
    }

    func startTest() {
        running     = true
        score       = nil
        samples.removeAll()
        eyeSession.start()
    }

    func stopTest() {
        running = false
        eyeSession.stop()
    }

    private func ingest(_ sample: EyeMovementSample) {
        samples.append(sample)
        if samples.count > maxBuffer { samples.removeFirst(samples.count - maxBuffer) }

        if oknAnalyzer.isOptokineticLost(in: samples) {
            finalize()
        }
    }

    private func finalize() {
        stopTest()
        score = scoreCalc.score(fromShade: shadeLevel)
        Task { await persist() }
    }

    private func persist() async {
        let ctx = PersistenceController.shared.container.viewContext
        await ctx.perform {
            let r = TestResult(context: ctx)
            r.date       = .now
            r.duration   = 60
            r.shadeLevel = self.shadeLevel
            r.score      = self.score ?? 0
            try? ctx.save()
            Task.detached {
                try? await APIClient.upload(r)     
            }

        }
    }
}
