//
//  AddBookScreenViewController.swift
//  StoryHunters
//
//  Created by Lia Shechter on 11/5/24.
//
import UIKit
import CryptoKit
import FirebaseFirestore
import FirebaseAuth

class AddBookScreenViewController: UIViewController {
    
    let mainScreen = AddBookScreen()
    let database = Firestore.firestore()
    var library: Library?
    
    override func loadView() {
        view = mainScreen
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Book"
        
        mainScreen.ratingSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        mainScreen.buttonAddBook.addTarget(self, action: #selector(onButtonAddBookTapped), for: .touchUpInside)
        mainScreen.usersBooksButton.addTarget(self, action: #selector(onUsersBooksButtonTapped), for: .touchUpInside)
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        mainScreen.ratingNumber.text = "\(Int(sender.value))"
       }
    
    @objc func onButtonAddBookTapped() {
        if let title = mainScreen.title.text,
           let author = mainScreen.author.text,
           let rating = mainScreen.ratingNumber.text {
            let titleAndAuthor = [title, author]
            let titleAuthorString = titleAndAuthor.joined()
            let bookID = titleAuthorString.lowercased()
            let book = Book(id: bookID, title: title, author: author, rating: Double(rating)!, numReaders: 0)
            self.saveBookToFirestore(book: book, newRating: Double(rating)!)
        }
    }
    
    @objc func onUsersBooksButtonTapped() {
        let addCurrentBookCustomViewController = AddCurrentBookCustomViewController()
        addCurrentBookCustomViewController.addBookScreenViewController = self
        navigationController?.pushViewController(addCurrentBookCustomViewController, animated: true)
    }
    
    func saveBookToFirestore(book: Book, newRating: Double) {
        if let library = library {
            if let bookID = book.id {
                if let libraryID = library.id {
                    let collectionBooks = database
                        .collection("Libraries")
                        .document(libraryID)
                        .collection("books")
                        .document(bookID)
                    let newNumReaders = book.numReaders + 1
                    let newRating = ((book.rating * Double(book.numReaders)) + newRating) / Double(newNumReaders)
                    let newBook = Book(id: bookID, title: book.title, author: book.author, rating: newRating, numReaders: newNumReaders)
                    do{
                        try collectionBooks.setData(from: newBook) { error in
                            if error == nil{
                                self.addBookToUser(book: newBook)
                                self.notifyUsers(book: newBook)
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }catch{
                        print("Error adding document!")
                    }
                }
            }
        }
    }
    
    func addBookToUser(book: Book) {
        if let user = Auth.auth().currentUser {
            if let userEmail = user.email {
                let titleAuthor = [book.title, book.author].joined()
                let bookID = titleAuthor.lowercased()
                let addedBook = database
                    .collection("users")
                    .document(userEmail)
                    .collection("booksDonated")
                    .document(bookID)
                let removedBook = database
                    .collection("users")
                    .document(userEmail)
                    .collection("books")
                    .document(bookID)
                do {
                    try addedBook.setData(from: book) { error in
                        if let error {
                            self.showAlert(title: "Error",message: error.localizedDescription)
                        } else {
                            print("Book added to user's library")
                        }
                    }
                    try removedBook.delete()
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
                                    "message": "New book added to \(libraryName): \(book.title)",
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
