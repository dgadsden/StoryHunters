//
//  ViewController.swift
//  StoryHunters
//
//  Created by Lia Shechter on 11/5/24.
//
import UIKit
import MapKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class ViewController: UIViewController {
    let mapView = MapView()
    let database = Firestore.firestore()
    
    var handleAuth: AuthStateDidChangeListenerHandle?
    var currentUser:FirebaseAuth.User?
    
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
        
        mapView.mapView.delegate = self
        mapView.mapView.showsUserLocation = false
        updateMapPins()
        
        self.setupRightBarButton()
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
            mapView.mapView.centerToLocation(location: uwLocation)
        }
    }
    
    @objc func onProfileBarButtonTapped() {
            let profileVC = ProfileViewController()
            navigationController?.pushViewController(profileVC, animated: true)
        }
    
    func updateMapPins() {
        //TODO: Maybe change root doc to "libraries"
        database.collection("Libraries").getDocuments(){ querySnapshot, error in
            if let error{
                print("Error fetching documents: \(error)")
            }else{
                print("Documents fetched successfully.")
                for document in querySnapshot!.documents{
                    guard let title = document.get("title") as? String,
                                          let info = document.get("info") as? String,
                                          let geopoint = document.get("coordinate") as? GeoPoint else {
                                        print("Error parsing document: \(document.data())")
                                        continue
                                    }
                    let id = document.documentID
                    let coordinate = CLLocationCoordinate2D(latitude: geopoint.latitude, longitude: geopoint.longitude)
                    let library = Library(id: id, title: title, coordinate: coordinate, info: info)
                    print("Adding library: \(title) at \(coordinate.latitude), \(coordinate.longitude)")
                    self.mapView.mapView.addAnnotation(library)
                }
            }
        }
    }
    
    func setupRightBarButton() {
        let barIcon = UIBarButtonItem(
            image: UIImage(systemName: "person.crop.circle"),
            style: .plain,
            target: self,
            action: #selector(onProfileBarButtonTapped)
        )
        navigationItem.leftBarButtonItem = barIcon
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

