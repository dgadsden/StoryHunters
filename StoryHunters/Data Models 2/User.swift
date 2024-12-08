//
//  User.swift
//  StoryHunters
//
//  Created by Lia Shechter on 11/20/24.
//

import Foundation
import UIKit

struct User: Codable {
    let name: String
    let email: String
    let bio: String?
    let profilePhoto: String?
    let phone: String?
    let gender: String?
    
    init(
        name: String,
        email: String,
        bio: String? = nil,
        profilePhoto: String? = nil,
        phone: String? = nil,
        gender: String? = nil
    ) {
        self.name = name
        self.email = email
        self.bio = bio
        self.profilePhoto = profilePhoto
        self.phone = phone
        self.gender = gender
    }
}
