//
//  User.swift
//  StoryHunters
//
//  Created by Lia Shechter on 11/20/24.
//

import Foundation
import UIKit

struct User: Codable{
    var name: String
    var email: String
    
    init (name: String, email: String){
        self.name = name
        self.email = email
    }
}
