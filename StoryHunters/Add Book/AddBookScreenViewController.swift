//
//  AddBookScreenViewController.swift
//  StoryHunters
//
//  Created by Lia Shechter on 11/5/24.
//
import UIKit
import CryptoKit
import FirebaseFirestore
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
            let book = Book(id: bookID, title: title, author: author, rating: Double(rating)!)
            self.saveBookToFirestore(book: book)
        }
    }
    
    func saveBookToFirestore(book: Book) {
        if let library = library {
            if let bookID = book.id {
                if let libraryID = library.id {
                    let collectionBooks = database
                        .collection("Libraries")
                        .document(libraryID)
                        .collection("books")
                        .document(bookID)
                    do{
                        try collectionBooks.setData(from: book) { error in
                            if error == nil{
                                self.notifyUsers(book: book)
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
                                    "timestamp": Timestamp()
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
}
