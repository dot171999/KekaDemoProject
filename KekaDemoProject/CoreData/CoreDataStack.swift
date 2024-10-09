//
//  CoreDataStack.swift
//  KekaDemoProject
//
//  Created by Aryan Sharma on 08/10/24.
//

import CoreData

struct CoreDataStack: CoreDataProtocol {
    static let shared = CoreDataStack()
    let container: NSPersistentContainer
    
    var mainContext: NSManagedObjectContext {
        container.viewContext
    }
    
    var backgroundContext: NSManagedObjectContext {
        let context = container.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        return context
    }
    
    private init() {
        container = NSPersistentContainer(name: "KekaDemoProject")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func save(_ context: NSManagedObjectContext) throws {
        guard context.hasChanges else {
            return
        }
        
        try context.save()
    }
}
