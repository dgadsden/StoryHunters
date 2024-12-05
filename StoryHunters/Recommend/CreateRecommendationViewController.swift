//
//  CreateRecommendationViewController.swift
//  StoryHunters
//
//  Created by Dejah Gadsden on 12/3/24.
//

import UIKit
import FirebaseFirestore
import Firebase
import FirebaseAuth
import CryptoKit


class CreateRecommendationViewController: UIViewController {
    
    let createRecommendationView = CreateRecommendationView()
    let database = Firestore.firestore()
    var currentUser: FirebaseAuth.User?
    
    var users = [User]()
    var books = [Book]()
    
    var selectedUser: User!
    var selectedBook: Book!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = createRecommendationView
        title = "Create a Recommendation"
        
        currentUser = Auth.auth().currentUser
        
        fetchUsers()
        fetchCurrentUserBooks()
        
        createRecommendationView.sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        
        // Set up pickers
        createRecommendationView.friendsPicker.delegate = self
        createRecommendationView.friendsPicker.dataSource = self
        
        createRecommendationView.booksPicker.delegate = self
        createRecommendationView.booksPicker.dataSource = self
        
    }
    
    @objc func sendButtonTapped() {
        createNewRecommendation()
        navigationController?.popViewController(animated: true)
    }
    
    func fetchUsers() {
        database.collection("users").getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching users: \(error)")
                return
            }
            self.users = querySnapshot?.documents.compactMap { document -> User? in
                let data = document.data()
                guard let name = data["name"] as? String,
                      let email = data["email"] as? String,
                      email != self.currentUser?.email else { return nil }
                return User(name: name, email: email)
            } ?? []
            
            DispatchQueue.main.async {
                self.createRecommendationView.friendsPicker.reloadAllComponents()
            }
        }
    }
    
    func fetchCurrentUserBooks() {
        guard let userEmail = Auth.auth().currentUser?.email else {
            print("Error: No authenticated user email found.")
            return
        }
        
        let userBooksCollection = database.collection("users").document(userEmail).collection("booksTaken")
        userBooksCollection.getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching user's books: \(error.localizedDescription)")
                return
            }
            guard let documents = querySnapshot?.documents else {
                print("No documents found in booksTaken collection for user: \(userEmail)")
                return
            }
            self.books = documents.compactMap { document -> Book? in
                let data = document.data()
                guard let title = data["title"] as? String,
                      let author = data["author"] as? String,
                      let rating = data["rating"] as? Double else {
                    print("Missing or invalid book data in document: \(document.data())")
                    return nil
                }
                return Book(id: document.documentID, title: title, author: author, rating: rating) // Use documentID
            }
            
            print("Books fetched: \(self.books)") // Debug print
            DispatchQueue.main.async {
                self.createRecommendationView.booksPicker.reloadAllComponents()
            }
        }
    }
    
    func createNewRecommendation() {
        guard let selectedBook = selectedBook,
              let description = createRecommendationView.recommendationDescription?.text,
              let recommendedBy = Auth.auth().currentUser?.email,
              let selectedUser = selectedUser
        else {
            print("Missing required fields to create a recommendation.")
            return
        }
        
        let recommendationID = UUID().uuidString
        
        // Create recommendation data
        let recommendationData: [String: Any] = [
            "title": selectedBook.title,
            "description": description,
            "recommendedBy": recommendedBy,
            "recommendedTo": selectedUser.email,
            "date": Timestamp(date: Date()),
            "likedByUser": false,
            "dislikedByUser": false
        ]
        
        database.collection("users")
            .document(selectedUser.email)
            .collection("recommendations")
            .document(recommendationID) // Use the same ID here
            .setData(recommendationData) { error in
                if let error = error {
                    print("Error adding recommendation to recipient: \(error.localizedDescription)")
                } else {
                    print("Recommendation added to recipient successfully.")
                }
            }
        
        // Save recommendation to the sender's recommendations
        database.collection("users")
            .document(recommendedBy)
            .collection("recommendations")
            .document(recommendationID) // Use the same ID here
            .setData(recommendationData) { error in
                if let error = error {
                    print("Error adding recommendation to sender: \(error.localizedDescription)")
                } else {
                    print("Recommendation added to sender successfully.")
                }
            }
        
        createRecommendationNotification()
    }
    
    func createRecommendationNotification() {
        let notificationsCollection = self.database
            .collection("users")
            .document(selectedUser.email)
            .collection("notifications")

        // Safely unwrap the display name
        let currentUserDisplayName = Auth.auth().currentUser?.displayName ?? "Someone"

        // Create a notification document
        let notificationData: [String: Any] = [
            "message": "New book recommendation from \(currentUserDisplayName) see in Recommend Incomming",
            "timestamp": Timestamp(),
            "read": false
        ]

        // Add the notification document
        notificationsCollection.addDocument(data: notificationData) { error in
            if let error = error {
                print("Error adding notification for user \(self.selectedUser.email): \(error.localizedDescription)")
            } else {
                print("Notification added for user \(self.selectedUser.email).")
            }
        }
    }

}

extension CreateRecommendationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == createRecommendationView.friendsPicker {
            return users.count
        } else if pickerView == createRecommendationView.booksPicker {
            return books.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == createRecommendationView.friendsPicker {
            selectedUser = users[row]
            return users[row].name
        } else if pickerView == createRecommendationView.booksPicker {
            selectedBook = books[row]
            return books[row].title
        }
        return nil
    }
}
