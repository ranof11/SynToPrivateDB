//
//  ContentViewModel.swift
//  SynToPrivateDB
//
//  Created by Rajesh Triadi Noftarizal on 28/10/24.
//

import Foundation
import CoreData

class ContentViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    private let viewContext: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<Item>
    
    @Published var items: [Item] = []
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        super.init()
        
        fetchedResultsController.delegate = self
        fetchItems()
    }
    
    func fetchItems() {
        do {
            try fetchedResultsController.performFetch()
            items = fetchedResultsController.fetchedObjects ?? []
        } catch {
            print("Failed to fetch items: \(error.localizedDescription)")
        }
    }
    
    func addItem() {
        let newItem = Item(context: viewContext)
        newItem.timestamp = Date()
        
        saveContext()
    }
    
    func deleteItems(at offsets: IndexSet) {
        offsets.map { items[$0] }.forEach(viewContext.delete)
        
        saveContext()
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        items = fetchedResultsController.fetchedObjects ?? []
    }
}
