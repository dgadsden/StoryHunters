//
//  Library.swift
//  StoryHunters
//
//  Created by Lia Shechter on 11/20/24.
//

import MapKit

struct Library{
    var locatation: CLLocationCoordinate2D
    let name: String
    
    init(name: String, location: CLLocationCoordinate2D){
        self.name = name
        self.locatation = location
    }
}
