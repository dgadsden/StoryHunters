//
//  Library.swift
//  StoryHunters
//
//  Created by Lia Shechter on 11/20/24.
//

import MapKit
import FirebaseFirestore

class Library:NSObject, MKAnnotation{
    @DocumentID var id: String?
    let title: String?
    let coordinate: CLLocationCoordinate2D
    let info: String
    
    init(id: String? = nil, title: String, coordinate: CLLocationCoordinate2D, info: String){
        self.id = id
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
    
    var mapItem: MKMapItem?{
        guard let location = title else{
            return nil
        }

        let placemark = MKPlacemark(
            coordinate: coordinate,
            addressDictionary:  [:]
        )
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }

    
    
}
