//
//  NystagmuSenseApp.swift
//  
//
//  Created by Rohan Sampath on 6/28/25.
//

import SwiftUI

@main
struct NystagmuSenseApp: App {
    @StateObject private var persistence = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MenuView()
                .environment(\.managedObjectContext, persistence.container.viewContext)
                .environmentObject(MenuViewModel())
        }
    }
}
