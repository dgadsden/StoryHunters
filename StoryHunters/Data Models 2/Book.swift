//
//  Book.swift
//  StoryHunters
//
//  Created by Lia Shechter on 11/20/24.
//

import Foundation
import UIKit
import FirebaseFirestore

struct Book: Codable{
    @DocumentID var id: String?
    var title: String
    var author: String
    var rating: Double
    var numReaders: Int
    
    init(id: String, title: String, author: String, rating: Double, numReaders: Int){
        self.id = id
        self.title = title
        self.author = author
        self.rating = rating
        self.numReaders = numReaders
    }
}
