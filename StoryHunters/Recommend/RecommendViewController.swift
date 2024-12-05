//
//  RecommendViewController.swift
//  StoryHunters
//
//  Created by Dejah Gadsden on 12/3/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class RecommendViewController: UIViewController {
    
    
    var recommendView = RecommendView()
    
    var outgoingRecommendations: [Recommendation] = [] // Outgoing recommendations
    var incomingRecommendations: [Recommendation] = [] // Incoming recommendations
    var currentRecommendations: [Recommendation] = []  // This will be shown in the table view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.app"), style: .done, target: self, action: #selector(didTapRecommendButton))
        
        view = recommendView
        
        // Set up delegate and data source for the table view
        recommendView.tableView.dataSource = self
        recommendView.tableView.delegate = self
        
        
        // Set up action for segmented control
        recommendView.segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
        
        // Load initial data
        loadRecommendationsData() // Load initial data for both outgoing and incoming
    }
    
    // Action when segmented control is changed
    @objc func segmentedControlChanged() {
        print("Segment changed to index: \(recommendView.segmentedControl.selectedSegmentIndex)")
        
        if recommendView.segmentedControl.selectedSegmentIndex == 0 {
            // Show outgoing recommendations
            currentRecommendations = outgoingRecommendations
        } else {
            // Show incoming recommendations
            currentRecommendations = incomingRecommendations
        }
        
        // Reload table view after segment change
        recommendView.tableView.reloadData()
    }
    
    
    func loadRecommendationsData() {
        let db = Firestore.firestore()
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            print("User is not logged in.")
            return
        }
        
        let userRecommendationsCollection = db.collection("users").document(currentUserEmail).collection("recommendations").order(by: "date", descending: true)
        
        // Observe changes in the recommendations collection
        userRecommendationsCollection.addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error observing recommendations: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No recommendations found for user \(currentUserEmail).")
                DispatchQueue.main.async {
                    self.recommendView.tableView.reloadData()
                }
                return
            }
            
            // Log raw document data for debugging
            print("Fetched documents: \(documents.map { $0.data() })")
            
            var recommendations: [Recommendation] = []
            
            // Decode documents into Recommendation objects
            recommendations = documents.compactMap { doc -> Recommendation? in
                do {
                    if let recommendation = try? doc.data(as: Recommendation.self) {
                        return recommendation
                    } else {
                        print("Failed to decode document \(doc.documentID)")
                        return nil
                    }
                }
            }
            
            // Log decoded recommendations for debugging
            print("Decoded recommendations: \(recommendations)")
            
            // Filter recommendations based on whether the current user recommended them
            self.outgoingRecommendations = recommendations.filter { $0.recommendedBy == currentUserEmail }
            self.incomingRecommendations = recommendations.filter { $0.recommendedBy != currentUserEmail }
            
            // Debug filtered recommendations
            print("Outgoing recommendations: \(self.outgoingRecommendations)")
            print("Incoming recommendations: \(self.incomingRecommendations)")
            
            // Set current recommendations based on selected segment
            self.updateCurrentRecommendations()
            
            // Reload table view on the main thread
            DispatchQueue.main.async {
                print("Reloading table view with current recommendations: \(self.currentRecommendations)")
                self.recommendView.tableView.reloadData()
            }
        }
    }
    
    // Helper method to update current recommendations based on selected segment
    func updateCurrentRecommendations() {
        if recommendView.segmentedControl.selectedSegmentIndex == 0 {
            currentRecommendations = outgoingRecommendations
        } else {
            currentRecommendations = incomingRecommendations
        }
    }
    
    @objc func didTapRecommendButton() {
        let createRecommendationVC = CreateRecommendationViewController()
        navigationController?.pushViewController(createRecommendationVC, animated: true)
    }
}

extension RecommendViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of rows: \(currentRecommendations.count)")
        return currentRecommendations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Configs.tableViewRecsID, for: indexPath) as! RecommendationsTableViewCell
        var recommendation = currentRecommendations[indexPath.row]
        
        if recommendation.recommendedBy == Auth.auth().currentUser?.email {
            // Configure the cell for sent recommendations (outgoing)
            cell.configure(with: recommendation)
            cell.recommendation = recommendation // Set the recommendation
            cell.delegate = self
        } else {
            // Configure the cell for incoming recommendations
            cell.configureIncoming(with: recommendation)
            cell.recommendation = recommendation // Set the recommendation
            cell.delegate = self
        }
        
        return cell
    }
}

extension RecommendViewController: RecommendationsTableViewCellDelegate {
    func didTapLikeButton(on recommendation: Recommendation) {
        guard let currentUserEmail = Auth.auth().currentUser?.email else { return }
        guard let senderEmail = recommendation.recommendedBy else { return }
        guard let recommendationID = recommendation.id else { return }
        
        let db = Firestore.firestore()
        
        // References for both sender and current user's documents
        let currentUserRecommendationsRef = db.collection("users")
            .document(currentUserEmail)
            .collection("recommendations")
            .document(recommendationID)
        
        let senderRecommendationsRef = db.collection("users")
            .document(senderEmail)
            .collection("recommendations")
            .document(recommendationID)
        
        // Update for current user
        currentUserRecommendationsRef.updateData([
            "likedByUser": true,
            "dislikedByUser": false
        ]) { [weak self] error in
            if let error = error {
                print("Error updating like status for current user: \(error.localizedDescription)")
                return
            }
            
            print("Like status updated successfully for current user.")
            
            // Update for sender
            senderRecommendationsRef.updateData([
                "likedByUser": true,
                "dislikedByUser": false
            ]) { error in
                if let error = error {
                    print("Error updating like status for sender: \(error.localizedDescription)")
                    return
                }
                
                print("Like status updated successfully for sender.")
                self?.createRecommendationFeebackNotification(on: recommendation)
                self?.loadRecommendationsData()
            }
        }
    }
    
    
    func didTapDislikeButton(on recommendation: Recommendation) {
        guard let currentUserEmail = Auth.auth().currentUser?.email else { return }
        guard let senderEmail = recommendation.recommendedBy else { return }
        guard let recommendationID = recommendation.id else { return }
        
        let db = Firestore.firestore()
        
        // References for both sender and current user's documents
        let currentUserRecommendationsRef = db.collection("users")
            .document(currentUserEmail)
            .collection("recommendations")
            .document(recommendationID)
        
        let senderRecommendationsRef = db.collection("users")
            .document(senderEmail)
            .collection("recommendations")
            .document(recommendationID)
        
        // Update for current user
        currentUserRecommendationsRef.updateData([
            "likedByUser": false,
            "dislikedByUser": true
        ]) { [weak self] error in
            if let error = error {
                print("Error updating dislike status for current user: \(error.localizedDescription)")
                return
            }
            
            print("Dislike status updated successfully for current user.")
            
            // Update for sender
            senderRecommendationsRef.updateData([
                "likedByUser": false,
                "dislikedByUser": true
            ]) { error in
                if let error = error {
                    print("Error updating dislike status for sender: \(error.localizedDescription)")
                    return
                }
                
                print("Dislike status updated successfully for sender.")
                
                self?.createRecommendationFeebackNotification(on: recommendation)
                self?.loadRecommendationsData()
            }
        }
    }
    
    func createRecommendationFeebackNotification(on recommendation: Recommendation) {
        
        guard let currentUserEmail = Auth.auth().currentUser?.email else { return }
        guard let senderEmail = recommendation.recommendedBy else { return }
        
        let db = Firestore.firestore()
        
        
        let notificationsCollection = db
            .collection("users")
            .document(senderEmail)
            .collection("notifications")
        
        
        // Safely unwrap the display name
        let currentUserDisplayName = Auth.auth().currentUser?.displayName ?? "Someone"
        
        var likedByUser = recommendation.likedByUser ?? false
        var dislikedByUser = recommendation.dislikedByUser ?? false
        
        
        var isLike = likedByUser && !dislikedByUser
        
        let message = isLike
        ? "\(currentUserDisplayName) liked your recommendation"
        : "\(currentUserDisplayName) disliked your recommendation"
        
        // Create a notification document
        let notificationData: [String: Any] = [
            "message": message,
            "timestamp": Timestamp()
        ]
        
        // Add the notification document
        notificationsCollection.addDocument(data: notificationData) { error in
            if let error = error {
                print("Error adding notification for user \(senderEmail): \(error.localizedDescription)")
            } else {
                print("Notification added for user \(senderEmail).")
            }
        }
    }
    
    
    func didUpdateRecommendation(_ recommendation: Recommendation) {
        guard let index = currentRecommendations.firstIndex(where: { $0.id == recommendation.id }) else { return }
        currentRecommendations[index] = recommendation
        recommendView.tableView.reloadData()
    }
}



extension RecommendViewController: UITableViewDelegate {
    
}
