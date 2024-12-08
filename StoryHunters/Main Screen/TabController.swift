//
//  TabController.swift
//  StoryHunters
//
//  Created by Dejah Gadsden on 12/3/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class TabController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UITabBarAppearance()
        
        // Customize the background color, shadow, and other properties for all tabs
        appearance.backgroundColor = UIColor.white // Set the background color for all tabs
        
        // Apply the appearance to the tab bar
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
                
        self.setupTabs()
        self.selectedIndex = 1 // Assuming the initial selected tab is Map
        self.delegate = self // Set the delegate to self
        
        listenForRecommendations()
        listenForNotifications()
    }
    
    func setupTabs() {
        let recommend = self.createNav(with: "Recommendations", and: UIImage(systemName: "person.3"), vc: RecommendViewController())
        let map = self.createNav(with: "Map", and: UIImage(systemName: "mappin.and.ellipse"), vc: ViewController())
        let notifications = self.createNav(with: "Notifications", and: UIImage(systemName: "bell"), vc: NotificationsController())
        
        self.setViewControllers([recommend, map, notifications], animated: true)
    }
    
    func createNav(with title: String, and image: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        nav.viewControllers.first?.navigationItem.title = title
        return nav
    }
    
    // show all unrated recommendations
    func listenForRecommendations() {
        guard let user = Auth.auth().currentUser, let userEmail = user.email else {
            print("User not logged in or missing email.")
            return
        }
        
        let database = Firestore.firestore()
        database.collection("users")
            .document(userEmail)
            .collection("recommendations")
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error listening for recommendations: \(error.localizedDescription)")
                    return
                }
                
                // Filter the incoming recommendations where both likedByUser and dislikedByUser are false
                let incomingRecommendations = querySnapshot?.documents.filter { document in
                    let likedByUser = document.data()["likedByUser"] as? Bool ?? false
                    let dislikedByUser = document.data()["dislikedByUser"] as? Bool ?? false
                    return document.data()["recommendedBy"] as? String != userEmail && !likedByUser && !dislikedByUser
                } ?? []
                
                let incomingCount = incomingRecommendations.count
                
                // Update the badge on the Notifications tab
                DispatchQueue.main.async {
                    let notificationsTab = self.tabBar.items?[2] // Notifications is now the 3rd tab
                    notificationsTab?.badgeValue = incomingCount > 0 ? "\(incomingCount)" : nil
                }
            }
    }
    
    // show all unread notfications
    func listenForNotifications() {
        guard let user = Auth.auth().currentUser, let userEmail = user.email else {
            print("User not logged in or missing email.")
            return
        }
        
        let database = Firestore.firestore()
        database.collection("users")
            .document(userEmail)
            .collection("notifications")
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error listening for notifications: \(error.localizedDescription)")
                    return
                }
                
                // Filter out notifications where the 'read' field is either false or nil
                let unreadNotifications = querySnapshot?.documents.filter { document in
                    let read = document.data()["read"] as? Bool
                    return read == false || read == nil
                } ?? []
                
                let count = unreadNotifications.count
                
                // Update the badge on the Notifications tab
                DispatchQueue.main.async {
                    let notificationsTab = self.tabBar.items?[2] // Notifications is now the 3rd tab
                    notificationsTab?.badgeValue = count > 0 ? "\(count)" : nil
                }
            }
    }
    
    
    func markNotificationAsRead(notificationID: String) {
        guard let user = Auth.auth().currentUser, let userEmail = user.email else {
            print("User not logged in or missing email.")
            return
        }
        
        let database = Firestore.firestore()
        let notificationRef = database.collection("users")
            .document(userEmail)
            .collection("notifications")
            .document(notificationID)
        
        // Update the "read" field to true
        notificationRef.updateData([
            "read": true
        ]) { error in
            if let error = error {
                print("Error marking notification as read: \(error.localizedDescription)")
            } else {
                print("Notification marked as read with ID: \(notificationID)")
            }
        }
    }
    
    
    
    // Override the tabBarController delegate method to detect when a tab is selected
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // Print the class of the selected view controller
        print("Tab selected: \(type(of: viewController))")
        
        // Check if the selected view controller is a UINavigationController
        if let navController = viewController as? UINavigationController,
           let rootViewController = navController.viewControllers.first,
           rootViewController is NotificationsController {
            print("Notifications tab selected")
            
            guard let user = Auth.auth().currentUser, let userEmail = user.email else {
                print("User not logged in or missing email.")
                return
            }
            
            let database = Firestore.firestore()
            let notificationRef = database.collection("users")
                .document(userEmail)
                .collection("notifications")
            
            notificationRef.getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching notifications: \(error.localizedDescription)")
                    return
                }
                
                snapshot?.documents.forEach { document in
                    self.markNotificationAsRead(notificationID: document.documentID)
                }
            }
            
            // Reset the badge after marking notifications as read
            DispatchQueue.main.async {
                let notificationsTab = self.tabBar.items?[2] // Notifications is now the 3rd tab
                notificationsTab?.badgeValue = nil
            }
        }
    }
    
    
}
