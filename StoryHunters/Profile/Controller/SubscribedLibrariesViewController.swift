//
//  SubscribedLibrariesViewController.swift
//  StoryHunters
//
//  Created by Dejah Gadsden on 12/3/24.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class SubscribedLibrariesViewController: UIViewController {

    var tableView: UITableView!
    var subscribedLibrariesList: [LibraryVisited] = []  // Array to hold Library objects
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Subscribed Libraries"
        
        // Initialize the table view
        tableView = UITableView()
        tableView.frame = self.view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        
        // Load the visited libraries data
        loadUserSubscribedLibrariesData()
    }
    
    func loadUserSubscribedLibrariesData() {
        let db = Firestore.firestore()
        let userEmail = Auth.auth().currentUser?.email ?? ""
        let userLibrariesCollection = db.collection("users").document(userEmail).collection("librariesSubscribed")
        
        // Add snapshot listener to observe real-time updates
        userLibrariesCollection.addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error observing libraries: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No libraries found for user \(userEmail).")
                self.subscribedLibrariesList = [] // Clear the list if no libraries
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                return
            }
            
            // Decode Firestore documents into LibraryVisited objects
            self.subscribedLibrariesList = documents.compactMap { doc -> LibraryVisited? in
                try? doc.data(as: LibraryVisited.self) // Assuming LibraryVisited is a codable model
            }
            
            DispatchQueue.main.async {
                print("Libraries updated: \(self.subscribedLibrariesList.count)")
                self.tableView.reloadData()
            }
        }
    }
}

extension SubscribedLibrariesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscribedLibrariesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = subscribedLibrariesList[indexPath.row].libraryName
        
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 6.0
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = .zero
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 0.4
        
        
        
        
        return cell
    }
}
