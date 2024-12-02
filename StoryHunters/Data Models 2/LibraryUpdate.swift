//
//  LibraryUpdate.swift
//  StoryHunters
//
//  Created by Lia Shechter on 11/20/24.
//

struct LibraryUpdate: Codable{
    var dateTime: String
    var message: String
    
    init(dateTime: String, message: String){
        self.dateTime = dateTime
        self.message = message
    }
}
