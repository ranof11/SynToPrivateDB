//
//  CoreDataManager.swift
//  SynToPrivateDB
//
//  Created by Rajesh Triadi Noftarizal on 28/10/24.
//

import Foundation
import CoreData

class CoreDataManager: NSObject, NSFetchedResultsControllerDelegate, DataManager {
    static let shared = CoreDataManager()
    
    // MARK: - Core Data Stack
    private let persistentContainer: NSPersistentCloudKitContainer
    // monitors changes in the data and notifies its delegate
    private var fetchedResultsControllers: [String: NSFetchedResultsController<NSFetchRequestResult>] = [:]
    
    weak var delegate: CoreDataManagerDelegate?
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func setDelegate(_ delegate: any CoreDataManagerDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Initialization
    private override init() {
        persistentContainer = NSPersistentCloudKitContainer(name: "SynToPrivateDB")
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        super.init()
        
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        // Setup fetched results controllers
        setupFetchedResultsController(for: Item.self, sortDescriptor: NSSortDescriptor(keyPath: \Item.timestamp, ascending: true))
        setupFetchedResultsController(for: Book.self, sortDescriptor: NSSortDescriptor(keyPath: \Book.title, ascending: true))
    }
    
    // MARK: - Fetched Results Controller Setup
    private func setupFetchedResultsController<T: NSManagedObject>(for entity: T.Type, sortDescriptor: NSSortDescriptor) {
        let request = T.fetchRequest()
        request.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        fetchedResultsController.delegate = self     // Set the CoreDataManager as the delegate
        fetchedResultsControllers[String(describing: entity)] = fetchedResultsController  // Store the controller in the dictionary
        
        do {
            try fetchedResultsController.performFetch() // Perform initial fetch to populate results
        } catch {
            print("Failed to fetch \(entity): \(error.localizedDescription)")
        }
    }
    
    // MARK: - CRUD Operations
    func addEntity<T>(_ entity: T.Type, configure: (T) -> Void) where T : NSManagedObject {
        guard let newEntity = NSEntityDescription.insertNewObject(forEntityName: String(describing: entity), into: context) as? T else { return }
        configure(newEntity)
        saveContext()
    }
    
    func deleteEntity<T>(_ entity: T.Type, at offsets: IndexSet) where T : NSManagedObject {
        guard let fetchedResultsController = fetchedResultsControllers[String(describing: entity)],
              let itemsToDelete = fetchedResultsController.fetchedObjects as? [T] else {
            print("No fetched results controller found for entity: \(entity)")
            return
        }
        
        offsets.map { itemsToDelete[$0] }.forEach(context.delete)
        saveContext()
    }
    
    func updateEntity<T>(_ entity: T.Type, withIdentifier identifier: NSManagedObjectID, configure: (T) -> Void) where T : NSManagedObject {
        do {
            if let object = try context.existingObject(with: identifier) as? T {
                configure(object)
                saveContext()
            }
        } catch {
            print("Failed to fetch or update entity: \(error.localizedDescription)")
        }
    }
    
    func fetchEntity<T>(_ entity: T.Type) -> [T] where T : NSManagedObject {
        let request = T.fetchRequest()
        do {
            return try context.fetch(request) as? [T] ?? []
        } catch {
            print("Failed to fetch \(entity): \(error.localizedDescription)")
            return []
        }
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
    
    // MARK: - NSFetchedResultsControllerDelegate
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let entityName = controller.fetchRequest.entityName,
              let objects = controller.fetchedObjects else { return }
        
        // Notify the delegate of data changes based on entity type
        if let entityClass = NSClassFromString(entityName) as? NSManagedObject.Type {
            delegate?.didUpdateEntity(entityClass, updatedObjects: objects as? [NSManagedObject] ?? [])
        }
    }
}
