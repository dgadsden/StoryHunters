//
//  MapView.swift
//  StoryHunters
//
//  Created by Lia Shechter on 11/5/24.
//
import UIKit
import MapKit

class MapView: UIView {
    var mapView:MKMapView!
    var buttonCurrentLocation:UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupMapView()
        setupButtonCurrentLocation()
        initConstraints()
    }
    
    func setupMapView(){
        mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.layer.cornerRadius = 10
        self.addSubview(mapView)
    }
    
    func setupButtonCurrentLocation(){
        buttonCurrentLocation = UIButton(type: .system)
        buttonCurrentLocation.setImage(UIImage(systemName: "location.circle"), for: .normal)
        buttonCurrentLocation.layer.backgroundColor = UIColor.lightGray.cgColor
        buttonCurrentLocation.tintColor = .blue
        buttonCurrentLocation.layer.cornerRadius = 10
        
        buttonCurrentLocation.layer.shadowOffset = .zero
        buttonCurrentLocation.layer.shadowRadius = 4
        buttonCurrentLocation.layer.shadowOpacity = 0.7
        
        buttonCurrentLocation.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(buttonCurrentLocation)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            mapView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            mapView.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
            mapView.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.95),
            mapView.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor, multiplier: 0.95),
            
            buttonCurrentLocation.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -16),
            buttonCurrentLocation.bottomAnchor.constraint(equalTo: self.mapView.bottomAnchor, constant: -8),
            buttonCurrentLocation.heightAnchor.constraint(equalToConstant: 36),
            buttonCurrentLocation.widthAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

