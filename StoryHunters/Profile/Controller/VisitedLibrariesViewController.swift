//
//  VisitedLibrariesViewController.swift
//  StoryHunters
//
//  Created by Dejah Gadsden on 12/2/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import MapKit

class VisitedLibrariesViewController: UIViewController {
    
    let database = Firestore.firestore()
    
    var tableView: UITableView!
    var visitedLibrariesList: [LibraryVisited] = []  // Array to hold Library objects
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Visited Libraries"
        
        // Initialize the table view
        tableView = UITableView()
        tableView.frame = self.view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        
        // Load the visited libraries data
        loadUserVisitedLibrariesData()
    }
    
    func loadUserVisitedLibrariesData() {
        let db = Firestore.firestore()
        let userEmail = Auth.auth().currentUser?.email ?? ""
        let userLibrariesCollection = db.collection("users").document(userEmail).collection("librariesVisited")
        
        // Add snapshot listener to observe real-time updates
        userLibrariesCollection.addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error observing libraries: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No libraries found for user \(userEmail).")
                self.visitedLibrariesList = [] // Clear the list if no libraries
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                return
            }
            
            // Decode Firestore documents into LibraryVisited objects
            self.visitedLibrariesList = documents.compactMap { doc -> LibraryVisited? in
                try? doc.data(as: LibraryVisited.self) // Assuming LibraryVisited is a codable model
            }
            
            DispatchQueue.main.async {
                print("Libraries updated: \(self.visitedLibrariesList.count)")
                self.tableView.reloadData()
            }
        }
    }
}

extension VisitedLibrariesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visitedLibrariesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = visitedLibrariesList[indexPath.row].libraryName
        
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 6.0
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = .zero
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 0.4
        
        
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLibrary = visitedLibrariesList[indexPath.row]
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
                    if(title == selectedLibrary.libraryName) {
                        let id = document.documentID
                        let coordinate = CLLocationCoordinate2D(latitude: geopoint.latitude, longitude: geopoint.longitude)
                        let library = Library(id: id, title: title, coordinate: coordinate, info: info)
                        let libraryScreenViewController = LibraryScreenViewController()
                        libraryScreenViewController.library = library
                        self.navigationController?.pushViewController(libraryScreenViewController, animated: true)
                    }
                }
            }
        }
    }
}
