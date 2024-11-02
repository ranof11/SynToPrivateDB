//
//  DataManager.swift
//  SynToPrivateDB
//
//  Created by Rajesh Triadi Noftarizal on 02/11/24.
//

import CoreData

// MARK: - Dependecy Injection for Singleton Replacement
protocol DataManager {
    func addEntity<T: NSManagedObject>(_ entity: T.Type, configure: (T) -> Void)
    func deleteEntity<T: NSManagedObject>(_ entity: T.Type, at offsets: IndexSet)
    func updateEntity<T: NSManagedObject>(_ entity: T.Type, withIdentifier identifier: NSManagedObjectID, configure: (T) -> Void)
    func fetchEntity<T: NSManagedObject>(_ entity: T.Type) -> [T]
    func setDelegate(_ delegate: CoreDataManagerDelegate)
}
