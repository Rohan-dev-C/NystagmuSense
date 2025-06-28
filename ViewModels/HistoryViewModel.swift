//
//  HistoryViewModel.swift
//  
//
//  Creted by Rohan Sampath on 6/28/25.
//

import Foundation
import CoreData

@MainActor
final class HistoryViewModel: ObservableObject {
    @Published var results: [TestResult] = []

    func fetch() {
        let request = TestResult.fetchRequest()
        request.sortDescriptors = [.init(keyPath: \TestResult.date, ascending: false)]
        let ctx = PersistenceController.shared.container.viewContext
        results = (try? ctx.fetch(request)) ?? []
    }
}
