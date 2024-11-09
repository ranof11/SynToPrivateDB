//
//  ContentViewModel.swift
//  SynToPrivateDB
//
//  Created by Rajesh Triadi Noftarizal on 28/10/24.
//

import Foundation
import CoreData

class ContentViewModel: ObservableObject, CoreDataManagerDelegate {
    @Published var items: [Item] = []
    @Published var books: [Book] = []
    
    private var dataManager: DataManager
    
    init(dataManager: DataManager = CoreDataManager.shared) {
        self.dataManager = dataManager
    
        dataManager.setDelegate(self)
        loadInitialData()
    }
    
    private func loadInitialData() {
        items = dataManager.fetchEntity(Item.self)
        books = dataManager.fetchEntity(Book.self)
    }
    
    // CoreDataManagerDelegate methods
    func didUpdateEntity<T>(_ entity: T.Type, updatedObjects: [T]) where T : NSManagedObject {
        if entity == Item.self {
            items = updatedObjects as? [Item] ?? []
        } else if entity == Book.self {
            books = updatedObjects as? [Book] ?? []
        }
    }
    
    // CRUD operations through dataManager
    func addEntity<T: NSManagedObject>(_ entity: T.Type, configure: (T) -> Void) {
        dataManager.addEntity(entity, configure: configure)
    }
    
    func deleteEntity<T: NSManagedObject>(_ entity: T.Type, at offsets: IndexSet) {
        dataManager.deleteEntity(entity, at: offsets)
    }
    
    func updateEntity<T: NSManagedObject>(_ entity: T.Type, withIdentifier identifier: NSManagedObjectID, configure: (T) -> Void) {
        dataManager.updateEntity(entity, withIdentifier: identifier, configure: configure)
    }
    
    func saveBook(book: Book?, title: String, author: String) {
        if let bookToUpdate = book {
            updateEntity(Book.self, withIdentifier: bookToUpdate.objectID) { book in
                book.title = title
                book.author = author
            }
        } else {
            addEntity(Book.self) { newBook in
                newBook.title = title
                newBook.author = author
            }
        }
    }
}
