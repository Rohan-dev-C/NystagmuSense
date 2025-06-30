//
//  HistoryViewModel.swift
//  NystagmuSense
//
//  Created by Rohan Sampath on 6/30/25.
//

import CoreData
@MainActor
final class HistoryViewModel: ObservableObject {
    @Published var results: [TestResult] = []

    func refresh() {
        let ctx = PersistenceController.shared.container.viewContext
        let req = TestResult.fetchRequest()
        req.sortDescriptors = [.init(keyPath: \TestResult.date, ascending: false)]

        // Cast result to [TestResult]
        results = (try? ctx.fetch(req) as? [TestResult]) ?? []
    }

}
