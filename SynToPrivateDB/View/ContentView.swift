//
//  ContentView.swift
//  SynToPrivateDB
//
//  Created by Rajesh Triadi Noftarizal on 27/10/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject private var viewModel : ContentViewModel

    init(viewContext: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: ContentViewModel(viewContext: viewContext))
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                    } label: {
                        Text(item.timestamp!, formatter: itemFormatter)
                    }
                }
                .onDelete(perform: viewModel.deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem() {
                    Button(action: viewModel.addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    let persistenceController = PersistenceController.shared
    
    ContentView(viewContext: persistenceController.container.viewContext)
}
