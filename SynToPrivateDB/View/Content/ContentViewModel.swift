//
//  ContentViewModel.swift
//  SynToPrivateDB
//
//  Created by Rajesh Triadi Noftarizal on 28/10/24.
//

import Foundation
import CoreData

class ContentViewModel: ObservableObject, CoreDataManagerDelegate {
    @Published var books: [Book] = []
    private let bookService: BookService
    
    init(bookService: BookService = BookService()) {
        self.bookService = bookService
        loadBooks()
    }
    
    func loadBooks() {
        books = bookService.fetchBooks()
    }
    
    func saveBook(book: Book?, title: String, author: String, cover: Data?) {
        bookService.saveBook(
            book: book,
            title: title,
            author: author,
            cover: cover
        )
        loadBooks()
    }
    
    func deleteBook(at offsets: IndexSet) {
        bookService.deleteBook(at: offsets, in: books)
        loadBooks()
    }
    
    // MARK: - CoreDataManagerDelegate Implementation
    func didUpdateEntity<T>(_ entity: T.Type, updatedObjects: [T]) where T: NSManagedObject {
        if entity == Book.self {
            DispatchQueue.main.async {
                self.books = updatedObjects as? [Book] ?? []
            }
        }
    }
}
