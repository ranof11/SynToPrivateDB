//
//  Entity+Ext.swift
//  SynToPrivateDB
//
//  Created by Rajesh Triadi Noftarizal on 02/11/24.
//

import Foundation

extension Book {
    var viewTitle: String {
        title ?? "No Title"
    }
    
    var viewAuthor: String {
        author ?? "No Author"
    }
}
