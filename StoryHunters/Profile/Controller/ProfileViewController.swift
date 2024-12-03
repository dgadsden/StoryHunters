// ProfileViewController.swift

import UIKit
import FirebaseFirestore
import Firebase
import FirebaseAuth

final class ProfileViewController: UIViewController {
    
    private var profileView: ProfileView!
    let database = Firestore.firestore()
    var handleAuth: AuthStateDidChangeListenerHandle?
    
    
    
    override func loadView() {
        profileView = ProfileView()
        self.view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        setupDelegates()
        loadUserDetails()
        // loadUserBooksData()
        
        title = "Profile"
        
    }
    
    private func setupDelegates() {
        profileView.profileOptionsTableView.dataSource = self
        profileView.profileOptionsTableView.delegate = self
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSettingsButton))
        
        // Left back button
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"), // Icon for back button
            style: .plain,
            target: self,
            action: #selector(didTapBackButton)
        )
        
    }
    
    @objc private func didTapBackButton() {
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapSettingsButton() {
        let vc = SettingsViewController()
        vc.title = "Settings"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadUserDetails() {
        let currentUser = Auth.auth().currentUser
        if currentUser != nil {
            profileView.nameLabel.text = currentUser?.displayName
        }
    }
}
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4 // Libraries, Visited, Books, Books Taken
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileOptionCell", for: indexPath) as! ProfileOptionsTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.labelName.text = "Subscribed Libraries"
        case 1:
            cell.labelName.text = "Visited Libraries"
        case 2:
            cell.labelName.text = "Currently Borrowed Books"
        case 3:
            cell.labelName.text = "All Time Book History"
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle what happens when a user selects an option
        switch indexPath.row {
        case 0:
            let listViewController = ListViewController()
            navigationController?.pushViewController(listViewController, animated: true)
            print("Visited Libraries selected")
        case 1:
            print("Visited selected")
        case 2:
            print("Books selected")
            let currentBookViewController = CurrentBooksViewController()
            navigationController?.pushViewController(currentBookViewController, animated: true)
            print("Books Taken selected")
        case 3:
            let allBookViewController = AllBooksViewController()
            navigationController?.pushViewController(allBookViewController, animated: true)
            print("Books Taken selected")
        default:
            break
        }
    }
}

/*
 extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
 func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
 
 return 10
 }
 
 func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath)
 // Configure the cell (e.g., image, text)
 return cell
 }
 
 func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
 collectionView.deselectItem(at: indexPath, animated: true)
 // Handle item selection (e.g., navigate to a profile detail screen)
 }
 func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
 guard kind == UICollectionView.elementKindSectionHeader else {
 return UICollectionReusableView()
 }
 
 
 let profileHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileInfoHeaderCollectionReuseableView.identifier, for: indexPath) as! ProfileInfoHeaderCollectionReuseableView
 return profileHeader
 }
 
 func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
 if section == 0 {
 return CGSize(width: collectionView.frame.size.width, height: collectionView.height/3)
 }
 return .zero
 }
 
 }
 */
