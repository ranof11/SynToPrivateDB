//
//  AddBookView.swift
//  SynToPrivateDB
//
//  Created by Rajesh Triadi Noftarizal on 29/10/24.
//

import SwiftUI

// MARK: - BookFormView
struct BookFormView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var contentViewModel: ContentViewModel
    @StateObject private var bookFormViewModel: BookFormViewModel
    
    var bookToEdit: Book? // Optional parameter for editing an existing book

    init(contentViewModel: ContentViewModel, bookToEdit: Book? = nil) {
        self.contentViewModel = contentViewModel
        self.bookToEdit = bookToEdit
        self._bookFormViewModel = StateObject(wrappedValue: BookFormViewModel(book: bookToEdit))
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Enter title", text: $bookFormViewModel.title)
                } header: {
                    Text("Title")
                }
                
                Section {
                    TextField("Enter author", text: $bookFormViewModel.author)
                } header: {
                    Text("Author")
                }
            }
            .navigationTitle(bookFormViewModel.isEditMode ? "Edit Book" : "New Book")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        contentViewModel.saveBook(
                            book: bookToEdit,
                            title: bookFormViewModel.title,
                            author: bookFormViewModel.author)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(!bookFormViewModel.isSaveEnabled)
                }
            }
        }
    }
}
