//
//  PersistenceController.swift
//  CatApp
//
//  Created by Bruges on 17/10/2025.
//
//
//  CoreDataManager.swift
//  CatBreedsApp
//
//  Created by ChatGPT on 2025-10-17.
//

import Foundation
import CoreData


struct CoreDataManager {

    static let shared = CoreDataManager()

    let container: NSPersistentContainer

 
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "CatApp")

        if inMemory {
            container.persistentStoreDescriptions.first?.url =
                URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("❌ Unresolved Core Data error: \(error)")
            }
        }

        container.viewContext.mergePolicy =
            NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    var context: NSManagedObjectContext {
        container.viewContext
    }

    func save() {
        let ctx = container.viewContext
        if ctx.hasChanges {
            do {
                try ctx.save()
            } catch {
                print("Core Data save error: \(error.localizedDescription)")
            }
        }
    }
}
