//
//  ContentView.swift
//  SynToPrivateDB
//
//  Created by Rajesh Triadi Noftarizal on 27/10/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var contentViewModel = ContentViewModel()
    @State private var isBookFormPresented = false
    @State private var selectedBook: Book? = nil
    
    var body: some View {
        NavigationView {
            List {
                ForEach(contentViewModel.books) { book in
                    VStack(alignment: .leading) {
                        Text(book.viewTitle)
                            .font(.headline)
                        Text(book.viewAuthor)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .onTapGesture {
                        selectedBook = book
                        isBookFormPresented.toggle()
                    }
                }
                .onDelete { offsets in
                    contentViewModel.deleteEntity(Book.self, at: offsets)
                }
            }
            .navigationTitle("Books")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        selectedBook = nil
                        isBookFormPresented.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $isBookFormPresented) {
                BookFormView(contentViewModel: contentViewModel, bookToEdit: selectedBook)
            }
            .id(selectedBook?.objectID)
        }
    }
}

#Preview {
    ContentView()
}