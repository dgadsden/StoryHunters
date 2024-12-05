//
//  Recommendation.swift
//  StoryHunters
//
//  Created by Dejah Gadsden on 12/3/24.
//

import Foundation
import FirebaseFirestore


struct Recommendation: Codable {
    @DocumentID var id: String?
    var title: String
    var description: String
    var recommendedBy: String?
    var recommendedTo: String?
    var date: Date?
    var likedByUser: Bool?
    var dislikedByUser: Bool?

    // Custom initializer to handle Timestamp conversion
    init(title: String, description: String, recommendedBy: String, recommendedTo: String, date: Timestamp?, likedByUser: Bool? = nil, dislikedByUser: Bool? = nil) {
        self.title = title
        self.description = description
        self.recommendedBy = recommendedBy
        self.recommendedTo = recommendedTo
        self.date = date?.dateValue()  // Convert Timestamp to Date
        self.likedByUser = likedByUser
        self.dislikedByUser = dislikedByUser
    }
}

