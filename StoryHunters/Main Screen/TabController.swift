//
//  TabController.swift
//  StoryHunters
//
//  Created by Dejah Gadsden on 12/3/24.
//

import UIKit

class TabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabs()
        self.selectedIndex = 1
    }
    
    
    func setupTabs() {
        let map = self.createNav(with: "Map", and: UIImage(systemName: "mappin.and.ellipse"), vc: ViewController())
        let profile = self.createNav(with: "Profile", and: UIImage(systemName: "person.circle"), vc: ProfileViewController())
        let notifications = self.createNav(with: "Notifications", and: UIImage(systemName: "bell.fill"), vc: EditProfileViewController())
        
        self.setViewControllers([profile, map, notifications], animated: true)
    }
    
    func createNav(with title: String, and image: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        nav.viewControllers.first?.navigationItem.title = title
        nav.viewControllers.first?.navigationItem.rightBarButtonItem =
        UIBarButtonItem(title: "Button", style: .plain, target: nil, action: nil)
        
        
        return nav
    }
}
