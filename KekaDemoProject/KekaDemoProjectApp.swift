//
//  KekaDemoProjectApp.swift
//  KekaDemoProject
//
//  Created by Aryan Sharma on 08/10/24.
//

import SwiftUI

@main
struct KekaDemoProjectApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
