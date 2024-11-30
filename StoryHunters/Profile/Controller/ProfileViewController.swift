// ProfileViewController.swift

import UIKit
import FirebaseFirestore
import Firebase
import FirebaseAuth

final class ProfileViewController: UIViewController {
    
    
    private var profileView: ProfileView!
    let database = Firestore.firestore()
    var booksList: [Book] = []
    var handleAuth: AuthStateDidChangeListenerHandle?
    
    
    
    override func loadView() {
        profileView = ProfileView()
        self.view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        setupDelegates()
        loadUserBooksData()
        
        title = "Profile"
        
    }
    
    private func setupDelegates() {
        //           profileView.collectionView.delegate = self
        //           profileView.collectionView.dataSource = self
        profileView.tableViewBooks.delegate = self
        profileView.tableViewBooks.dataSource = self
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
    
    func loadUserBooksData() {
            let db = Firestore.firestore()
            let userEmail = Auth.auth().currentUser?.email ?? ""
            let userBooksCollection = db.collection("users").document(userEmail).collection("books")
            userBooksCollection.getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching books: \(error.localizedDescription)")
                    return
                }
                guard let documents = snapshot?.documents else {
                    print("No books found for user \(userEmail).")
                    return
                }
                self.booksList = documents.compactMap { doc -> Book? in
                    try? doc.data(as: Book.self) // Decodes Firestore data into Book objects
                }
                DispatchQueue.main.async {
                    print("Books loaded: \(self.booksList.count)")
                    self.profileView.tableViewBooks.reloadData() // Use profileView's tableView
                }
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
