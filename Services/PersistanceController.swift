//
//  PersistanceController.swift
//  
//
//  Created by Rohan Sampath on 6/28/25.
//

import CoreData

final class PersistenceController: ObservableObject {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "NystagmuSense")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = .init(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error { fatalError("CoreData failed – \(error)") }
        }
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    static var preview: PersistenceController = {
        let pc = PersistenceController(inMemory: true)
        let ctx = pc.container.viewContext
        (0..<4).forEach { i in
            let r = TestResult(context: ctx)
            r.date = .now - .init(days: i)
            r.score = Double.random(in: 0...2)
            r.shadeLevel = Double.random(in: 1...100)
        }
        try? ctx.save()
        return pc
    }()
}
