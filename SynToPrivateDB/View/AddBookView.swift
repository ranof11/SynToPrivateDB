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
    
    @State private var title: String = ""
    @State private var author: String = ""
    
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
                        .frame(height: 200)
                } header: {
                    Text("Author")
                }
            }
            .navigationTitle("New Book")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.addEntity(Book.self) { book in
                            book.title = title
                            book.author = author
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}
