//
//  LibraryScreenViewController.swift
//  StoryHunters
//
//  Created by Lia Shechter on 11/5/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import MapKit

class LibraryScreenViewController: UIViewController {
    let mainScreen = LibraryScreen()
    let database = Firestore.firestore()
    var library: Library?
    var books = [Book]()
    
    override func loadView() {
        if let userEmail = Auth.auth().currentUser?.email,
           let libraryTitle = library?.title {
            let subscribedLibraries = database
                .collection("users")
                .document(userEmail)
                .collection("librariesSubscribed")
                .document(libraryTitle) // Reference the specific document

            subscribedLibraries.getDocument { (document, error) in
                if let error = error {
                    print("Error checking document existence: \(error.localizedDescription)")
                } else if let document = document, document.exists {
                    print("Document with ID '\(libraryTitle)' exists!")
                    self.mainScreen.isSubscribed = true
                    self.mainScreen.updateSubscribeButtonTitle()
                } else {
                    print("Document with ID '\(libraryTitle)' does not exist.")
                    self.mainScreen.isSubscribed = false
                    self.mainScreen.updateSubscribeButtonTitle()
                }
            }
        }
        view = mainScreen
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let library = library {
            title = library.title
        }
        
        mainScreen.tableViewBooks.delegate = self
        mainScreen.tableViewBooks.dataSource = self
        mainScreen.tableViewBooks.separatorStyle = .none
        
        mainScreen.addBookButton.addTarget(self, action: #selector(onButtonAddTapped), for: .touchUpInside)
        mainScreen.subscribeButton.addTarget(self, action: #selector(onButtonSubscribeTapped), for: .touchUpInside)
        mainScreen.markVisitedButton.addTarget(self, action: #selector(onButtonVisitedTapped), for: .touchUpInside)
        if let library {
                mainScreen.mapView.centerToLocation(
                    location: CLLocation(
                        latitude: library.coordinate.latitude,
                        longitude: library.coordinate.longitude
                    )
                )
            
            mainScreen.mapView.delegate = self
            mainScreen.mapView.showsUserLocation = false
            mainScreen.mapView.addAnnotation(library)
        }

        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mapTapped))
        mainScreen.mapView.addGestureRecognizer(tapGesture)
    }
    
    @objc func mapTapped() {
        // Open Apple Maps with the library's location
        if let library {
            let destination = MKMapItem(placemark: MKPlacemark(coordinate: library.coordinate))
            destination.name = "Library Location"
            
            let launchOptions = [
                MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
            ]
            destination.openInMaps(launchOptions: launchOptions)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.database.collection("Libraries")
                            .document((self.library?.id)!)
                            .collection("books")
                            .addSnapshotListener(includeMetadataChanges: false, listener: {querySnapshot, error in
                                if let documents = querySnapshot?.documents{
                                    self.books.removeAll()
                                    for document in documents{
                                        do{
                                            let book  = try document.data(as: Book.self)
                                            self.books.append(book)
                                        }catch{
                                            print(error)
                                        }
                                    }
                                    self.books.sort(by: {$0.title < $1.title})
                                    self.mainScreen.tableViewBooks.reloadData()
                                }
                            })
    }
    
    @objc func onButtonAddTapped(){
        let addBook = AddBookScreenViewController()
        addBook.library = library
        navigationController?.pushViewController(addBook, animated: true)
    }
    
    @objc func onButtonSubscribeTapped(){
        if let library = library {
                do{
                    if let user = Auth.auth().currentUser {
                        if let userEmail = user.email {
                            if let userName = user.displayName {
                                let userdb = User(name: userName, email:userEmail)
                                if let libraryID = library.id {
                                    if let libraryTitle = library.title {
                                        let subscriber = database
                                            .collection("Libraries")
                                            .document(libraryID)
                                            .collection("subscribers")
                                            .document(userEmail.lowercased())
                                        let subscribedLibrary = database
                                            .collection("users")
                                            .document(userEmail)
                                            .collection("librariesSubscribed")
                                            .document(libraryTitle)
                                        let librarySubscribeData = LibraryVisited(libraryName: libraryTitle)
                                        if(!mainScreen.isSubscribed) {
                                            try subscriber.setData(from: userdb) { error in
                                                if error == nil{
                                                    self.showAlert(title: "Success", message: "Library added")
                                                } else {
                                                    self.showAlert(title: "Error", message: "Failed to add library")
                                                }
                                            }
                                            try subscribedLibrary.setData(from: librarySubscribeData) { error in
                                                if error == nil{
                                                    print("Success, Library added")
                                                } else {
                                                    print("Error, Failed to add library")
                                                }
                                            }
                                        } else {
                                            try subscriber.delete() { error in
                                                if error == nil{
                                                    self.showAlert(title: "Success", message: "Library removed")
                                                } else {
                                                    self.showAlert(title: "Error", message: "Failed to remove library")
                                                }
                                            }
                                            try subscribedLibrary.delete() { error in
                                                if error == nil{
                                                    print("Success, Library removed")
                                                } else {
                                                    print("Error, Failed to remove library")
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }catch{
                    print("Error adding document!")
                }
            }
        mainScreen.isSubscribed = !mainScreen.isSubscribed
        mainScreen.updateSubscribeButtonTitle()
        print(mainScreen.isSubscribed)
        }
    
    @objc func onButtonVisitedTapped(){
        do {
            if let user = Auth.auth().currentUser {
                if let userEmail = user.email {
                    if let library = library {
                        if let libraryTitle = library.title {
                            let libraryVisited = database
                                .collection("users")
                                .document(userEmail)
                                .collection("librariesVisited")
                                .document(libraryTitle)
                            let libraryVisitedData = LibraryVisited(libraryName: libraryTitle)
                            try libraryVisited.setData(from: libraryVisitedData) { error in
                                if error == nil{
                                    self.showAlert(title: "Success", message: "Library added")
                                } else {
                                    self.showAlert(title: "Error", message: "Failed to add library")
                                }
                            }
                        }
                    }
                }
            }
        } catch {
            print("Error adding library: \(error)")
        }
    }
    
    func TakeOutBook(book: Int) {
        let selectedBook = books[book]
        if let library = library {
            if let libraryID = library.id {
                let collectionBooks = database
                    .collection("Libraries")
                    .document(libraryID)
                    .collection("books")
                if let bookID = selectedBook.id {
                    
                    collectionBooks.document(bookID).delete { error in
                        if let error = error {
                            print("Error taking out book: \(error)")
                        } else {
                            // Reload the table view
                            self.mainScreen.tableViewBooks.reloadData()
                            
                            self.addBookToUser(book: selectedBook)
                            
                            self.notifyUsers(book: selectedBook)
                        }
                    }
                } else {
                    print("No book found to delete")
                }
            }
        }
    }
    
    func addBookToUser(book: Book) {
        if let user = Auth.auth().currentUser {
            if let userEmail = user.email {
                let titleAuthor = [book.title, book.author].joined()
                let bookID = titleAuthor.lowercased()
                let addedBookTaken = database
                    .collection("users")
                    .document(userEmail)
                    .collection("booksTaken")
                    .document(bookID)
                let addedBook = database
                    .collection("users")
                    .document(userEmail)
                    .collection("books")
                    .document(bookID)
                do {
                    try addedBookTaken.setData(from: book) { error in
                        if let error {
                            self.showAlert(title: "Error",message: error.localizedDescription)
                        } else {
                            print("Book added to user's library")
                        }
                    }
                    try addedBook.setData(from: book) { error in
                        if let error {
                            self.showAlert(title: "Error",message: error.localizedDescription)
                        } else {
                            print("Book added to user's library")
                        }
                    }
                }
                catch {
                    print("Error encoding book: \(error.localizedDescription)")
                    self.showAlert(title: "Error", message: "Error encoding user data: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func notifyUsers(book: Book) {
            if let library = library {
                if let libraryID = library.id {
                    if let libraryName = library.title {
                        
                        let currentDate = Date()
                        // Create a date formatter to format the dateTime string
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Adjust format as needed
                        let formattedDate = dateFormatter.string(from: currentDate)
                        
                        
                        let collectionUsers = database
                            .collection("Libraries")
                            .document(libraryID)
                            .collection("subscribers")

                        collectionUsers.getDocuments { (snapshot, error) in
                            if let error = error {
                                print("Error fetching subscribers: \(error.localizedDescription)")
                                return
                            }

                            guard let documents = snapshot?.documents else {
                                print("No subscribers found.")
                                return
                            }

                            for document in documents {
                                let userID = document.documentID
                                
                                // Reference to the user's notifications collection
                                let notificationsCollection = self.database
                                    .collection("users")
                                    .document(userID)
                                    .collection("notifications")

                                // Create a notification document
                                let notificationData: [String: Any] = [
                                    "message": "\(book.title) has been taken from \(libraryName)",
                                    "timestamp": Timestamp(),
                                    "read": false
                                ]

                                // Add the notification document
                                notificationsCollection.addDocument(data: notificationData) { error in
                                    if let error = error {
                                        print("Error adding notification for user \(userID): \(error.localizedDescription)")
                                    } else {
                                        print("Notification added for user \(userID).")
                                    }
                                }
                            }
                        }
                    }
                }
            }
    }

    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}
extension LibraryScreenViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "books", for: indexPath) as! BooksTableViewCell
        cell.labelTitle.text = books[indexPath.row].title
        cell.labelAuthor.text = books[indexPath.row].author
        
        //MARK: crating an accessory button...
        let buttonOptions = UIButton(type: .system)
        buttonOptions.sizeToFit()
        buttonOptions.showsMenuAsPrimaryAction = true
        //MARK: setting an icon from sf symbols...
        buttonOptions.setImage(UIImage(systemName: "plus.square.fill"), for: .normal)
        
        //MARK: setting up menu for button options click...
        buttonOptions.menu = UIMenu(title: "Would you like to take this book?",
                                    children: [
                                        UIAction(title: "Borrow",handler: {(_) in
                                            self.TakeOutBook(book: indexPath.row)
                                        })
                                    ])
        //MARK: setting the button as an accessory of the cell...
        cell.accessoryView = buttonOptions
        return cell
    }
}
