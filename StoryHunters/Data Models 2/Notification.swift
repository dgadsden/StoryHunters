//
//  Notification.swift
//  StoryHunters
//
//  Created by Dimiar Ilev on 03.12.24.
//

import Foundation
import UIKit

struct Notification: Codable {
    let message: String
    let timestamp: Date
    var read: Bool?
}
