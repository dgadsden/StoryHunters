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
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 18
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "person.crop.circle")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onProfileBarButtonTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        
        let barButton = UIBarButtonItem(customView: imageView)
        navigationItem.rightBarButtonItem = barButton
    }
    /*
    func setupRightBarButton() {
        let barIcon = UIBarButtonItem(
            image: UIImage(systemName: "person.crop.circle"),
            style: .plain,
            target: self,
            action: #selector(onProfileBarButtonTapped)
        )
        navigationItem.rightBarButtonItem = barIcon
    }
    */
    
    func navigateToLoginScreen() {
        let loginVC = LoginController() // Use the new LoginController
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true, completion: nil)
    }
    
    func loadUserData() {
        if let user = currentUser {
            print("User is signed in: \(user.email ?? "Unknown Email")")
            
            if let photoURL = user.photoURL {
                URLSession.shared.dataTask(with: photoURL) { [weak self] data, _, error in
                    if let self = self, let data = data, error == nil {
                        DispatchQueue.main.async {
                            if let image = UIImage(data: data) {
                                let resizedImage = image.resized(to: CGSize(width: 36, height: 36))
                                if let imageView = self.navigationItem.rightBarButtonItem?.customView as? UIImageView {
                                    imageView.image = resizedImage
                                }
                            }
                        }
                    }
                }.resume()
            }
        }
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

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
