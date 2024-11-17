//
//  BookService.swift
//  SynToPrivateDB
//
//  Created by Rajesh Triadi Noftarizal on 17/11/24.
//

import Foundation
import CoreData

class BookService {
    private let dataManager: DataManager
    
    init(dataManager: DataManager = CoreDataManager.shared) {
        self.dataManager = dataManager
    }
    
    func fetchBooks() -> [Book] {
        dataManager.fetchEntity(Book.self)
    }
    
    func saveBook(book: Book?, title: String, author: String, cover: Data?) {
        if let bookToUpdate = book {
            dataManager.updateEntity(Book.self, withIdentifier: bookToUpdate.objectID) { updateBook in
                updateBook.title = title
                updateBook.author = author
                updateBook.cover = cover
            }
        } else {
            dataManager.addEntity(Book.self) { newBook in
                newBook.title = title
                newBook.author = author
                newBook.cover = cover
            }
        }
    }
    
    func deleteBook(at offsets: IndexSet, in books: [Book]) {
        offsets.map { books[$0] }.forEach { book in
            dataManager.deleteEntity(Book.self, at: offsets)
        }
    }
}
