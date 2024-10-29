//
//  ContentView.swift
//  SynToPrivateDB
//
//  Created by Rajesh Triadi Noftarizal on 27/10/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    @State private var showingAddBook = false
    
    var body: some View {
        // MARK: - To show timestap of Item
//        NavigationView {
//            List {
//                ForEach(viewModel.items) { item in
//                    NavigationLink {
//                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
//                    } label: {
//                        Text(item.timestamp!, formatter: itemFormatter)
//                    }
//                }
//                .onDelete { offsets in
//                    viewModel.deleteEntity(Item.self, at: offsets)
//                }
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem() {
//                    Button {
//                        viewModel.addEntity(Item.self) { item in
//                            item.timestamp = Date()
//                        }
//                    } label: {
//                        Image(systemName: "plus")
//                    }
//                }
//            }
//            Text("Select an item")
//        }
        
        // Mark - To show Book
        NavigationView {
            List {
                ForEach(viewModel.books) { book in
                    VStack(alignment: .leading) {
                        Text(book.title ?? "untitled")
                            .font(.headline)
                        Text(book.author ?? "unknown")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .onDelete { offsets in
                    viewModel.deleteEntity(Book.self, at: offsets)
                }
            }
            .navigationTitle("Books")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddBook.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddBook) {
                AddBookView(viewModel: viewModel)
            }
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
    ContentView()
}
