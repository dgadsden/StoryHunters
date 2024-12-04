//
//  NotificationsController.swift
//  StoryHunters
//
//  Created by Dimiar Ilev on 03.12.24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class NotificationsController: UIViewController {
    let mainScreen = NotificationsView() // A custom UIView subclass
    let database = Firestore.firestore()
    var notifications = [Notification]() // A model to hold notification data
    
    override func loadView() {
        view = mainScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notifications"
        
        mainScreen.tableViewNotifications.delegate = self
        mainScreen.tableViewNotifications.dataSource = self
        mainScreen.tableViewNotifications.separatorStyle = .none
        
        // Enable automatic row height adjustment
        mainScreen.tableViewNotifications.estimatedRowHeight = 100
        mainScreen.tableViewNotifications.rowHeight = UITableView.automaticDimension
        
        fetchNotifications()
    }
    
    private func fetchNotifications() {
        if let user = Auth.auth().currentUser, let userEmail = user.email {
            database.collection("users")
                .document(userEmail)
                .collection("notifications")
                .order(by: "timestamp", descending: true) // Fetch notifications in descending order
                .addSnapshotListener { querySnapshot, error in
                    if let error = error {
                        print("Error fetching notifications: \(error.localizedDescription)")
                        return
                    }
                    
                    if let documents = querySnapshot?.documents {
                        self.notifications = documents.compactMap { doc in
                            try? doc.data(as: Notification.self) // Decode into NotificationModel
                        }
                        self.mainScreen.tableViewNotifications.reloadData()
                    } else {
                        print("No notifications found.")
                    }
                }
        } else {
            print("User not logged in or missing email.")
        }
    }
}

// Table view init
extension NotificationsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as? NotificationCell {
            let notification = notifications[indexPath.row]
            cell.messageLabel.text = notification.message
            
            // Format the timestamp to a user-friendly format
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            cell.timeLabel.text = dateFormatter.string(from: notification.timestamp)
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
