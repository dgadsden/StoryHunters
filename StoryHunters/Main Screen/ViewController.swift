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
    var currentUser: FirebaseAuth.User?
    
    let locationManager = CLLocationManager()
    
    override func loadView() {
        view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.buttonCurrentLocation.addTarget(self, action: #selector(onButtonCurrentLocationTapped), for: .touchUpInside)
        setupLocationManager()
        onButtonCurrentLocationTapped() // Center the map on load
        mapView.mapView.delegate = self
        mapView.mapView.showsUserLocation = false
        updateMapPins()
        setupRightBarButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Handle authentication state changes
        handleAuth = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            guard let self = self else { return }
            
            if user == nil {
                self.navigateToLoginScreen()
            } else {
                self.currentUser = user
                self.loadUserData()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Remove the authentication listener to avoid memory leaks
        if let handleAuth = handleAuth {
            Auth.auth().removeStateDidChangeListener(handleAuth)
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
        database.collection("Libraries").getDocuments { querySnapshot, error in
            if let error = error {
                print("Error fetching documents: \(error)")
            } else {
                print("Documents fetched successfully.")
                for document in querySnapshot!.documents {
                    guard let title = document.get("title") as? String,
                          let info = document.get("info") as? String,
                          let geopoint = document.get("coordinate") as? GeoPoint else {
                        print("Error parsing document: \(document.data())")
                        continue
                    }
                    let id = document.documentID
                    let coordinate = CLLocationCoordinate2D(latitude: geopoint.latitude, longitude: geopoint.longitude)
                    let library = Library(id: id, title: title, coordinate: coordinate, info: info)
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
        navigationItem.rightBarButtonItem = barIcon
    }
    
    func navigateToLoginScreen() {
        let loginVC = LoginController() // Use the new LoginController
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true, completion: nil)
    }
    
    func loadUserData() {
        guard let user = currentUser else { return }
        print("User is signed in: \(user.email ?? "Unknown Email")")
        // Fetch user-specific data from Firestore or other backend services
    }
}


extension MKMapView {
    func centerToLocation(location: CLLocation, regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}
