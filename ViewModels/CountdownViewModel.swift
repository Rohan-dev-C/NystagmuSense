//
//  CountdownViewModel.swift
//  
//
//  Created by Rohan Sampath on 6/28/25.
//

import Foundation
import Combine

@MainActor
final class CountdownViewModel: ObservableObject {
    @Published var secondsRemaining = 30
    private var timer: AnyCancellable?

    func start() {
        secondsRemaining = 30
        timer = Timer
            .publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                self.secondsRemaining -= 1
                if self.secondsRemaining <= 0 { self.timer?.cancel() }
            }
    }
}
