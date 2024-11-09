//
//  CoreDataManagerDelegate.swift
//  SynToPrivateDB
//
//  Created by Rajesh Triadi Noftarizal on 02/11/24.
//

import CoreData

protocol CoreDataManagerDelegate: AnyObject {
    func didUpdateEntity<T: NSManagedObject>(_ entity: T.Type, updatedObjects: [T])
}
