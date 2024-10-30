//
//  ContentViewModel.swift
//  SynToPrivateDB
//
//  Created by Rajesh Triadi Noftarizal on 28/10/24.
//

import Foundation
import CoreData

class ContentViewModel: NSObject, ObservableObject, CoreDataManagerDelegate {
    @Published var items: [Item] = []
    @Published var books: [Book] = []
    
    override init() {
        super.init()
        CoreDataManager.shared.delegate = self
        loadInitialData()
    }
    
    private func loadInitialData() {
        items = CoreDataManager.shared.fetchEntity(Item.self)
        books = CoreDataManager.shared.fetchEntity(Book.self)
    }
    
    // CoreDataManagerDelegate methods
    func didUpdateItems(_ items: [Item]) {
        DispatchQueue.main.async {
            self.items = items
        }
    }
    
    func didUpdateBooks(_ books: [Book]) {
        DispatchQueue.main.async {
            self.books = books
        }
    }
    
    func addEntity<T: NSManagedObject>(_ entity: T.Type, configure: (T) -> Void) {
        CoreDataManager.shared.addEntity(entity, configure: configure)
    }
    
    func deleteEntity<T: NSManagedObject>(_ entity: T.Type, at offsets: IndexSet) {
        CoreDataManager.shared.deleteEntity(entity, at: offsets)
    }
    
    func updateEntity<T: NSManagedObject>(_ entity: T.Type, withIdentifier identifier: NSManagedObjectID, configure: (T) -> Void) {
        CoreDataManager.shared.updateEntity(entity, withIdentifier: identifier, configure: configure)
    }
}
