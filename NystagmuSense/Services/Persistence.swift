//
//  Persistence.swift
//  NystagmuSense
//
//  Created by Rohan Sampath on 6/30/25.
//
import CoreData

final class PersistenceController: ObservableObject {
    static let shared = PersistenceController()

    let container: NSPersistentContainer
    private init() {
        container = NSPersistentContainer(name: "NystagmuSense")
        container.loadPersistentStores { _, e in
            if let e { fatalError("CoreData load error: \(e)") }
        }
        container.viewContext.mergePolicy =
            NSMergeByPropertyObjectTrumpMergePolicy
    }
}
