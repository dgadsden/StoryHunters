//
//  LibraryMapAnnotation.swift
//  StoryHunters
//
//  Created by Lia Shechter on 11/26/24.
//

import Foundation
import MapKit
extension LibraryScreenViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation)
    -> MKAnnotationView? {
        guard let annotation = annotation as? Library else { return nil }
        
        var view:MKMarkerAnnotationView
        
        if let annotationView = mapView.dequeueReusableAnnotationView(
            withIdentifier: Configs.placeIdentifier) as? MKMarkerAnnotationView{
            
            annotationView.annotation = annotation
            view = annotationView
            
        }else{
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: Configs.placeIdentifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            view.glyphText = "📚"
        }
        return view
    }
}
