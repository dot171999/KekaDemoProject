//
//  CoreDataProrocol.swift
//  KekaDemoProject
//
//  Created by Aryan Sharma on 09/10/24.
//

import Foundation
import CoreData

protocol CoreDataProtocol {
    var container: NSPersistentContainer { get }
    
    var mainContext: NSManagedObjectContext { get }
    
    var backgroundContext: NSManagedObjectContext { get }
    
    func save(_ context: NSManagedObjectContext) throws

    func context(for type: MOContext) -> NSManagedObjectContext
    
}

extension CoreDataProtocol {
    func context(for type: MOContext) -> NSManagedObjectContext {
        switch type {
        case .main:
            return mainContext
        case .background:
            return backgroundContext
        }
    }
}

enum MOContext {
    case main
    case background
}

