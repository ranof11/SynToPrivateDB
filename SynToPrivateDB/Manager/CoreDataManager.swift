//
//  CoreDataManager.swift
//  SynToPrivateDB
//
//  Created by Rajesh Triadi Noftarizal on 28/10/24.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentCloudKitContainer
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {
        persistentContainer = NSPersistentCloudKitContainer(name: "SynToPrivateDB")
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    // MARK: - Fetch Method for Any Entity
    func fetchEntity<T: NSManagedObject>(_ entity: T.Type, sortDescriptor: NSSortDescriptor? = nil) -> [T] {
        let request = T.fetchRequest()
        request.sortDescriptors = sortDescriptor != nil ? [sortDescriptor!] : []
        
        do {
            return try context.fetch(request) as? [T] ?? []
        } catch {
            print("Failed to fetch entities: \(error.localizedDescription)")
            return []
        }
    }
    
    // MARK: - Add Method with Configurable Properties
    func addEntity<T: NSManagedObject>(_ entity: T.Type, configure: (T) -> Void) {
        let newEntity = T(context: context)
        configure(newEntity)
        
        saveContext()
    }
    
    // MARK: - Delete Method for Any Entity
    func deleteEntity<T: NSManagedObject>(_ entity: T.Type, at offsets: IndexSet) {
        let itemToDelete = fetchEntity(entity)
        offsets.map { itemToDelete[$0] }.forEach(context.delete)
        
        saveContext()
    }
    
    // MARK: - Save Context
    private func saveContext() {
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
