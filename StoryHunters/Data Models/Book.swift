//
//  Book.swift
//  StoryHunters
//
//  Created by Lia Shechter on 11/20/24.
//

import Foundation
import UIKit
import FirebaseFirestore

struct Book{
    @DocumentID var id: String?
    var title: String
    var author: String
    var rating: Double?
    
    init(id: String, title: String, author: String, rating: Double? = nil){
        self.id = id
        self.title = title
        self.author = author
        self.rating = rating
    }
}
