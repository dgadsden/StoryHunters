// ProfileViewController.swift

import UIKit

final class ProfileViewController: UIViewController {
    
    private var profileView: ProfileView!
    
    override func loadView() {
        profileView = ProfileView()
        self.view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        
        // Collection View Delegate and DataSource setup
        profileView.collectionView.delegate = self
        profileView.collectionView.dataSource = self
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSettingsButton))
    }
    
    @objc private func didTapSettingsButton() {
        let vc = SettingsViewController()
        vc.title = "Settings"
        navigationController?.pushViewController(vc, animated: true)
    }
}

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
}
