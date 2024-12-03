//
//  VisitedLibrariesViewController.swift
//  StoryHunters
//
//  Created by Dejah Gadsden on 12/2/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class VisitedLibrariesViewController: UIViewController {
    
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
        
        userLibrariesCollection.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching libraries: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No libraries found for user \(userEmail).")
                return
            }
            
            // Decode Firestore documents into Library objects
            self.visitedLibrariesList = documents.compactMap { doc -> LibraryVisited? in
                try? doc.data(as: LibraryVisited.self)  // Assuming Library model has a 'libraryName' field
            }
            
            DispatchQueue.main.async {
                print("Libraries loaded: \(self.visitedLibrariesList.count)")
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
}
