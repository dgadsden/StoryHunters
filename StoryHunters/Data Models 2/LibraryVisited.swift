//
//  LibraryVisited.swift
//  StoryHunters
//
//  Created by Lia Shechter on 12/1/24.
//

import Foundation
import UIKit

struct LibraryVisited: Codable {
    var libraryName: String
    
    init(libraryName: String) {
        self.libraryName = libraryName
    }
}
