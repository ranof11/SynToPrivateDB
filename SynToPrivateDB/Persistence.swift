//
//  Persistence.swift
//  SynToPrivateDB
//
//  Created by Rajesh Triadi Noftarizal on 27/10/24.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentCloudKitContainer

    // Initializes PersistenceController, with optional in-memory storage for testing
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "SynToPrivateDB")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                
//        /// MARK: Selective Data Synchronization
//        // Define URLs for cloud-based and local storage locations
//        let cloudURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("cloud.sqlite", conformingTo: .json)
//        let localURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("local.sqlite", conformingTo: .json)
//        
//        // Configure cloud-based storage with CloudKit container options
//        let cloudDesc = NSPersistentStoreDescription(url: cloudURL)
//        cloudDesc.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.com.rajeshtriadi.SynToPrivateDB")
//        cloudDesc.configuration = "cloud"
//        
//        // Configure local storage description
//        let localDesc = NSPersistentStoreDescription(url: localURL)
//        localDesc.configuration = "local"
//        
//        container.persistentStoreDescriptions = [cloudDesc, localDesc]
    }
}
