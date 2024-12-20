


import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfileInfoHeaderCollectionReuseableView: UICollectionReusableView {
    static let identifier = "ProfileInfoHeaderCollectionReusableView"
    
    private let profilePhotoImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(systemName: "person.circle") // Set the default image initially
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        return label
    }()
     
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.text = "This is my biography!" // Default bio
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        backgroundColor = .systemBackground
        clipsToBounds = true
        
        // Add observers
        NotificationCenter.default.addObserver(self, selector: #selector(handleNameUpdate(_:)), name: .nameDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleBioUpdate(_:)), name: .bioDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserSwitch), name: .userDidSwitch, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleProfilePhotoDidChange(_:)), name: .profilePhotoDidChange, object: nil)
        
        
        
        // Load current user data
        if let currentUser = Auth.auth().currentUser {
            nameLabel.text = currentUser.displayName
            loadSavedData()
            listenForNameChanges()
            listenForBioChanges()
        }
    }

    private func addSubviews() {
        addSubview(profilePhotoImageView)
        addSubview(nameLabel)
        addSubview(bioLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = height / 2
        profilePhotoImageView.frame = CGRect(x: 20, y: 20, width: size, height: size)
        profilePhotoImageView.layer.cornerRadius = size / 2
        
        nameLabel.frame = CGRect(x: profilePhotoImageView.right + 10, y: 20, width: frame.size.width - profilePhotoImageView.right - 20, height: 30)
        bioLabel.frame = CGRect(x: profilePhotoImageView.right + 10, y: nameLabel.bottom + 10, width: frame.size.width - profilePhotoImageView.right - 20, height: 60)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    @objc private func handleProfilePhotoDidChange(_ notification: Foundation.Notification) {
        if let userInfo = notification.userInfo, let image = userInfo["profilePhoto"] as? UIImage {
            profilePhotoImageView.image = image
        }
    }

    @objc private func handleNameUpdate(_ notification: Foundation.Notification) {
        if let updatedName = notification.userInfo?["name"] as? String {
            nameLabel.text = updatedName
        }
    }

    @objc private func handleBioUpdate(_ notification: Foundation.Notification) {
        if let updatedBio = notification.userInfo?["bio"] as? String {
            bioLabel.text = updatedBio
        }
    }

    @objc private func handleUserSwitch() {
        if let currentUser = Auth.auth().currentUser {
            nameLabel.text = currentUser.displayName
            loadSavedData()
        } else {
            // Clear data on logout
            nameLabel.text = "User not logged in"
            bioLabel.text = ""
            profilePhotoImageView.image = UIImage(systemName: "person.circle") // Reset to default image
            UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
            UserDefaults.standard.synchronize()
        }
    }


    // MARK: - Data Loading and Updates
    private func loadSavedData() {
        guard let currentUser = Auth.auth().currentUser else { return }
        let userEmail = currentUser.email ?? "defaultEmail"
        
        // Load name
        if let savedName = UserDefaults.standard.string(forKey: "\(userEmail)_name") {
            nameLabel.text = savedName
        } else {
            fetchNameFromFirestore()
        }
        
        // Load bio
        if let savedBio = UserDefaults.standard.string(forKey: "\(userEmail)_bio") {
            bioLabel.text = savedBio
        } else {
            fetchBioFromFirestore()
        }
        
        // Load profile photo
        if let imageData = UserDefaults.standard.data(forKey: "\(userEmail)_profilePhoto"), let savedImage = UIImage(data: imageData) {
            profilePhotoImageView.image = savedImage
        } else {
            fetchProfilePhoto()
        }
    }
        
    private func fetchProfilePhoto() {
        guard let currentUser = Auth.auth().currentUser,
              let photoURL = currentUser.photoURL else {
            // Default image if no photoURL is set
            profilePhotoImageView.image = UIImage(systemName: "person.circle")
            return
        }
        
        // Download the image from the URL
        URLSession.shared.dataTask(with: photoURL) { [weak self] data, response, error in
            guard let self = self, error == nil, let data = data, let image = UIImage(data: data) else {
                print("Error fetching profile photo: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // Update UI on the main thread
            DispatchQueue.main.async {
                self.profilePhotoImageView.image = image
            }
        }.resume()
    }



    private func fetchNameFromFirestore() {
        guard let currentUser = Auth.auth().currentUser else { return }
        let userEmail = currentUser.email ?? "defaultEmail"
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userEmail)
        
        userRef.getDocument { [weak self] (document, error) in
            if let error = error {
                print("Error fetching user name: \(error)")
                self?.nameLabel.text = "Unknown User"
            } else if let document = document, document.exists {
                if let name = document.data()?["name"] as? String {
                    self?.nameLabel.text = name
                    UserDefaults.standard.set(name, forKey: "\(userEmail)_name")
                }
            }
        }
    }

    private func fetchBioFromFirestore() {
        guard let currentUser = Auth.auth().currentUser else { return }
        let userEmail = currentUser.email ?? "defaultEmail"

        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userEmail)

        userRef.getDocument { [weak self] (document, error) in
            if let error = error {
                print("Error fetching user bio: \(error)")
                self?.bioLabel.text = "This is my biography!"
            } else if let document = document, document.exists {
                if let bio = document.data()?["bio"] as? String {
                    self?.bioLabel.text = bio
                    UserDefaults.standard.set(bio, forKey: "\(userEmail)_bio")
                } else {
                    self?.bioLabel.text = "This is my biography!"
                }
            }
        }
    }

    private func listenForNameChanges() {
        guard let currentUser = Auth.auth().currentUser else { return }
        let userEmail = currentUser.email ?? "defaultEmail"

        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userEmail)

        userRef.addSnapshotListener { [weak self] (snapshot, error) in
            if let error = error {
                print("Error listening for Firestore name updates: \(error)")
            } else if let snapshot = snapshot, snapshot.exists {
                if let name = snapshot.data()?["name"] as? String {
                    self?.nameLabel.text = name
                    UserDefaults.standard.set(name, forKey: "\(userEmail)_name")
                }
            }
        }
    }

    private func listenForBioChanges() {
        guard let currentUser = Auth.auth().currentUser else { return }
        let userEmail = currentUser.email ?? "defaultEmail"

        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userEmail)

        userRef.addSnapshotListener { [weak self] (snapshot, error) in
            if let error = error {
                print("Error listening for Firestore updates: \(error)")
            } else if let snapshot = snapshot, snapshot.exists {
                if let bio = snapshot.data()?["bio"] as? String {
                    self?.bioLabel.text = bio
                    UserDefaults.standard.set(bio, forKey: "\(userEmail)_bio")
                }
            }
        }
    }

    func updateNameInFirebaseAuth(newName: String) {
        guard let user = Auth.auth().currentUser else { return }
        
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = newName
        changeRequest.commitChanges { error in
            if let error = error {
                print("Error updating display name: \(error)")
            } else {
                NotificationCenter.default.post(name: .nameDidChange, object: nil, userInfo: ["name": newName])
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self, name: .profilePhotoDidChange, object: nil)
    }
}


