//
//  CurrentBooksViewController.swift
//  StoryHunters
//
//  Created by Dejah Gadsden on 12/2/24.
//

import UIKit
import FirebaseFirestore
import Firebase
import FirebaseAuth

class CurrentBooksViewController: UIViewController {

    var tableView: UITableView!
    var booksList: [Book] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Currently Borrowed Books"
        
        // Initialize the table view
        tableView = UITableView()
        tableView.frame = self.view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BookTableViewCell.self, forCellReuseIdentifier: Configs.tableViewBooksID)
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        
        // Load the user's books
        loadUserCurrentBooksData()
    }
    
    func loadUserCurrentBooksData() {
        let db = Firestore.firestore()
        let userEmail = Auth.auth().currentUser?.email ?? ""
        let userBooksCollection = db.collection("users").document(userEmail).collection("books")
        userBooksCollection.addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error observing books: \(error.localizedDescription)")
                return
            }
            guard let documents = snapshot?.documents else {
                print("No books found for user \(userEmail).")
                self.booksList = [] // Clear the list if no books
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                return
            }
            self.booksList = documents.compactMap { doc -> Book? in
                try? doc.data(as: Book.self) // Decodes Firestore data into Book objects
            }
            DispatchQueue.main.async {
                print("Books updated: \(self.booksList.count)")
                self.tableView.reloadData()
            }
        }
    }
}
extension CurrentBooksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booksList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Configs.tableViewBooksID, for: indexPath) as! BookTableViewCell
        let book = booksList[indexPath.row]
        print("Configuring cell for book: \(book.title)")  // Debug line
        cell.labelName.text = book.title
        cell.labelAuthor.text = book.author
        cell.labelRating.text = String(format: "%.1f", book.rating ?? 0.0)
        return cell
    }
}
