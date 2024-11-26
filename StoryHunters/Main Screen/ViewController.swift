//
//  ViewController.swift
//  StoryHunters
//
//  Created by Lia Shechter on 11/5/24.
//

import UIKit
import MapKit
import FirebaseAuth


class ViewController: UIViewController {
    let mapView = MapView()
    
    var handleAuth: AuthStateDidChangeListenerHandle?
    
    let locationManager = CLLocationManager()

    
    override func loadView() {
        view = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.buttonCurrentLocation.addTarget(self, action: #selector(onButtonCurrentLocationTapped), for: .touchUpInside)
        
        setupLocationManager()
        
        //MARK: center the map view to current location when the app loads...
        onButtonCurrentLocationTapped()
        
        
        //MARK: Annotating Northeastern University...
        let northeastern = Place(
            title: "Northeastern Little Library",
            coordinate: CLLocationCoordinate2D(latitude: 42.339918, longitude: -71.089797),
            info: "LVX VERITAS VIRTVS"
        )
        
        mapView.mapView.addAnnotation(northeastern)
        
        mapView.mapView.delegate = self
        
        self.setupRightBarButton()
        
        //auto log out 
//        do {
//            try Auth.auth().signOut()
//        } catch {
//            print("failed to sign out")
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        
         
            
            //MARK: handling if the Authentication state is changed (sign in, sign out, register)...
            handleAuth = Auth.auth().addStateDidChangeListener{ auth, user in
                if user == nil{
                    let loginController = LoginScreenViewController()
                    loginController.modalPresentationStyle = .fullScreen
                    self.present(loginController, animated: true, completion: nil)
                }else{
                    //MARK: the user is signed in...
                }
            }
        

      }
 
    @objc func onButtonCurrentLocationTapped(){
        if let uwLocation = locationManager.location{
            mapView.mapView.centerToLocation(location: locationManager.location!)
        }
    }
    
    @objc func onProfileBarButtonTapped() {
        let profileVC = ProfileViewController()
        navigationController?.pushViewController(profileVC, animated: true)
    }

    
    func setupRightBarButton(){
        //MARK: user is logged in...
        let barIcon = UIBarButtonItem(
            image: UIImage(systemName: "person.crop.circle"),
            style: .plain,
            target: self,
            action: #selector(onProfileBarButtonTapped)
        )
        let barText = UIBarButtonItem(
            title: "Profile",
            style: .plain,
            target: self,
            action: #selector(onProfileBarButtonTapped)
        )
        
        navigationItem.rightBarButtonItems = [barIcon, barText]
        
    }

}


extension MKMapView{
    func centerToLocation(location: CLLocation, radius: CLLocationDistance = 1000){
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: radius,
            longitudinalMeters: radius
        )
        setRegion(coordinateRegion, animated: true)
    }
}
