//
//  AddBookView.swift
//  SynToPrivateDB
//
//  Created by Rajesh Triadi Noftarizal on 29/10/24.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ContentViewModel
    
    var existingBook: Book? // Optional parameter for editing an existing book
    
    @State private var title: String = ""
    @State private var author: String = ""

    init(viewModel: ContentViewModel, book: Book? = nil) {
        self.viewModel = viewModel
        self.existingBook = book
        _title = State(initialValue: book?.title ?? "")
        _author = State(initialValue: book?.author ?? "")
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Enter title", text: $title)
                } header: {
                    Text("Title")
                }
                
                Section {
                    TextField("Enter author", text: $author)
                } header: {
                    Text("Author")
                }
            }
            .navigationTitle(existingBook == nil ? "New Book" : "Edit Book")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let bookToUpdate = existingBook {
                            // Update existing book
                            viewModel.updateEntity(Book.self, withIdentifier: bookToUpdate.objectID) { book in
                                book.title = title
                                book.author = author
                            }
                        } else {
                            // Add new book
                            viewModel.addEntity(Book.self) { book in
                                book.title = title
                                book.author = author
                            }
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
            .onAppear {
                // Refresh the text fields with the latest data
                if let book = existingBook {
                    title = book.title ?? ""
                    author = book.author ?? ""
                }
            }
        }
    }
}
