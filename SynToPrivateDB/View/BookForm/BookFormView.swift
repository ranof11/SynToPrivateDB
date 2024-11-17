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
    @ObservedObject private var bookFormViewModel: BookFormViewModel
    private let contentViewModel: ContentViewModel
    @State private var isCameraActive = false
    @State private var isPhotoPickerActive = false
    /// MARK: Book to edit
    private var book: Book?
    
    init(contentViewModel: ContentViewModel, book: Book? = nil) {
        self.contentViewModel = contentViewModel
        self.bookFormViewModel = BookFormViewModel(book: book)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    BookCoverPicker(image: $bookFormViewModel.cover)
                } header: {
                    Text("Book Cover")
                }
                
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
            .fullScreenCover(isPresented: $isCameraActive, content: {
                ImagePicker(sourceType: .camera) { image in
                    bookFormViewModel.cover = image
                }
            })
            .sheet(isPresented: $isPhotoPickerActive, content: {
                ImagePicker(sourceType: .photoLibrary) { image in
                    bookFormViewModel.cover = image
                }
            })
            .navigationTitle(bookFormViewModel.isEditMode ? "Edit Book" : "New Book")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        bookFormViewModel.save(using: contentViewModel)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(!bookFormViewModel.isSaveEnabled)
                }
            }
        }
    }
}

#Preview {
    BookFormView(contentViewModel: ContentViewModel())
}
