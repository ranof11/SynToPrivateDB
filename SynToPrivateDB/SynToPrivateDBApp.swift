//
//  SynToPrivateDBApp.swift
//  SynToPrivateDB
//
//  Created by Rajesh Triadi Noftarizal on 27/10/24.
//

import SwiftUI

@main
struct SynToPrivateDBApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView(viewContext: persistenceController.container.viewContext)
        }
    }
}
