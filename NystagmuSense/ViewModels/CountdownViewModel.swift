//
//  CountdownViewModel.swift
//  NystagmuSense
//
//  Created by Rohan Sampath on 6/30/25.
//

import Foundation
import Combine

@MainActor
final class CountdownViewModel: ObservableObject {
    @Published var seconds = 30
    private var cancellable: AnyCancellable?

    func start() {
        seconds = 30
        cancellable = Timer.publish(
            every: 1, on: .main, in: .common
        )
        .autoconnect()
        .sink { [weak self] _ in
            guard let self else { return }
            self.seconds -= 1
            if self.seconds <= 0 { self.cancellable?.cancel() }
        }
    }
}
