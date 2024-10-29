//
//  ContentViewModel.swift
//  SynToPrivateDB
//
//  Created by Rajesh Triadi Noftarizal on 28/10/24.
//

import Foundation
import CoreData

class ContentViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    private var itemFetchedResultsController: NSFetchedResultsController<Item>
    private var bookFetchedResultsController: NSFetchedResultsController<Book>
    
    @Published var items: [Item] = []
    @Published var books: [Book] = []
    
    override init() {
        // Setup for Item
        let itemRequest: NSFetchRequest<Item> = Item.fetchRequest()
        itemRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)]
        
        itemFetchedResultsController = NSFetchedResultsController(
            fetchRequest: itemRequest,
            managedObjectContext: CoreDataManager.shared.context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        // Setup for Book
        let bookRequest: NSFetchRequest<Book> = Book.fetchRequest()
        bookRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Book.title, ascending: true)]
        
        bookFetchedResultsController = NSFetchedResultsController(
            fetchRequest: bookRequest,
            managedObjectContext: CoreDataManager.shared.context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        super.init()
        
        itemFetchedResultsController.delegate = self
        bookFetchedResultsController.delegate = self
        fetchItems()
        fetchBooks()
    }
    
    func fetchItems() {
        do {
            try itemFetchedResultsController.performFetch()
            items = itemFetchedResultsController.fetchedObjects ?? []
        } catch {
            print("Failed to fetch items: \(error.localizedDescription)")
        }
    }
    
    func fetchBooks() {
        do {
            try bookFetchedResultsController.performFetch()
            books = bookFetchedResultsController.fetchedObjects ?? []
        } catch {
            print("Failed to fetch books: \(error.localizedDescription)")
        }
    }

    func addEntity<T: NSManagedObject>(_ entity: T.Type, configure: (T) -> Void) {
        CoreDataManager.shared.addEntity(entity) { entityInstance in
            configure(entityInstance)
        }
    }
    
    func deleteEntity<T: NSManagedObject>(_ entity: T.Type, at offsets: IndexSet) {
        CoreDataManager.shared.deleteEntity(entity, at: offsets)
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller === itemFetchedResultsController {
            fetchItems()
        } else if controller == bookFetchedResultsController {
            fetchBooks()
        }
    }
}
