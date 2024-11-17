//
//  Entity+Ext.swift
//  SynToPrivateDB
//
//  Created by Rajesh Triadi Noftarizal on 02/11/24.
//

import Foundation
import UIKit

extension Book {
    var viewTitle: String {
        title ?? "No Title"
    }

    var viewAuthor: String {
        author ?? "No Author"
    }

    var viewCover: UIImage {
        if let data = cover, let image = UIImage(data: data) {
            return image
        }
        return UIImage(systemName: "photo")!
    }
}
