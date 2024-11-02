//
//  BookFormViewModel.swift
//  SynToPrivateDB
//
//  Created by Rajesh Triadi Noftarizal on 02/11/24.
//

import Foundation

class BookFormViewModel: ObservableObject {
    @Published var title: String
    @Published var author: String
    var isEditMode: Bool
    
    init(book: Book? = nil) {
        self.title = book?.title ?? ""
        self.author = book?.author ?? ""
        self.isEditMode = book != nil
    }
    
    var isSaveEnabled: Bool {
        !title.isEmpty && !author.isEmpty
    }
}
