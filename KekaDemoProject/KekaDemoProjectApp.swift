//
//  KekaDemoProjectApp.swift
//  KekaDemoProject
//
//  Created by Aryan Sharma on 08/10/24.
//

import SwiftUI

@main
struct KekaDemoProjectApp: App {
    let coreDataStack = CoreDataStack.shared

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
                    .environment(\.managedObjectContext, coreDataStack.container.viewContext)
            }
        }
    }
}
