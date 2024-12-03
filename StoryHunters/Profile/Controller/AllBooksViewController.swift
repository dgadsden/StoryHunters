//
//  AllBooksViewController.swift
//  StoryHunters
//
//  Created by Dejah Gadsden on 12/2/24.
//

import UIKit
import FirebaseFirestore
import Firebase
import FirebaseAuth

class AllBooksViewController: UIViewController {
    
    var tableView: UITableView!
    var booksList: [Book] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "All Book History"
        
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
        loadUserAllTimeBooksData()
    }
    
    func loadUserAllTimeBooksData() {
        let db = Firestore.firestore()
        let userEmail = Auth.auth().currentUser?.email ?? ""
        let userBooksCollection = db.collection("users").document(userEmail).collection("booksTaken")
        userBooksCollection.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching books: \(error.localizedDescription)")
                return
            }
            guard let documents = snapshot?.documents else {
                print("No books found for user \(userEmail).")
                return
            }
            self.booksList = documents.compactMap { doc -> Book? in
                try? doc.data(as: Book.self) // Decodes Firestore data into Book objects
            }
            DispatchQueue.main.async {
                print("Books loaded: \(self.booksList.count)")
                self.tableView.reloadData()
            }
        }
    }
}
extension AllBooksViewController: UITableViewDelegate, UITableViewDataSource {
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