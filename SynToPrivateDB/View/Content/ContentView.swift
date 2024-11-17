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
        NavigationStack {
            List {
                ForEach(contentViewModel.books) { book in
                    HStack {
                        Image(uiImage: book.viewCover)
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .frame(width: 60, height: 60)
                        
                        VStack(alignment: .leading) {
                            Text(book.viewTitle)
                                .font(.headline)
                            Text(book.viewAuthor)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onTapGesture {
                        selectedBook = book
                        isBookFormPresented.toggle()
                    }
                }
                .onDelete(perform: contentViewModel.deleteBook)
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
                BookFormView(contentViewModel: contentViewModel, book: selectedBook)
            }
            .id(selectedBook?.objectID)
        }
    }
}

#Preview {
    ContentView()
}
