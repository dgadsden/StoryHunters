//
//  TabController.swift
//  StoryHunters
//
//  Created by Dejah Gadsden on 12/3/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class TabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabs()
        self.selectedIndex = 1
        listenForNotifications()
    }
    
    func setupTabs() {
        let map = self.createNav(with: "Map", and: UIImage(systemName: "mappin.and.ellipse"), vc: ViewController())
        let profile = self.createNav(with: "Profile", and: UIImage(systemName: "person.circle"), vc: ProfileViewController())
        let notifications = self.createNav(with: "Notifications", and: UIImage(systemName: "bell.fill"), vc: NotificationsController())
        
        self.setViewControllers([profile, map, notifications], animated: true)
    }
    
    func createNav(with title: String, and image: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        nav.viewControllers.first?.navigationItem.title = title
        return nav
    }
    
    // Listen for new notifications
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
                
                let count = querySnapshot?.documents.count ?? 0
                
                // Update the badge on the Notifications tab
                DispatchQueue.main.async {
                    let notificationsTab = self.tabBar.items?[2] // Assuming Notifications is the 3rd tab
                    notificationsTab?.badgeValue = count > 0 ? "\(count)" : nil
                }
            }
    }
}
