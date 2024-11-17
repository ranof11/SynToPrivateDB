//
//  BookFormViewModel.swift
//  SynToPrivateDB
//
//  Created by Rajesh Triadi Noftarizal on 02/11/24.
//

import Foundation
import UIKit

class BookFormViewModel: ObservableObject {
    @Published var title: String
    @Published var author: String
    @Published var cover: UIImage?
    var isEditMode: Bool
    private var book: Book?
    
    init(book: Book? = nil) {
        self.book = book
        self.title = book?.title ?? ""
        self.author = book?.author ?? ""
        self.cover = book?.viewCover
        self.isEditMode = book != nil
    }
    
    var isSaveEnabled: Bool {
        !title.isEmpty && !author.isEmpty
    }
    
    func save(using contentViewModel: ContentViewModel) {
        contentViewModel.saveBook(
            book: book,
            title: title,
            author: author,
            cover: cover?.jpegData(compressionQuality: 0.8)
        )
    }
}
