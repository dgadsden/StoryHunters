


import UIKit
import FirebaseFirestore
import FirebaseAuth

struct EditProfileFormModel {
    let label: String
    let placeholder: String
    var value: String?
}

class EditProfileViewController: UIViewController, UINavigationControllerDelegate, UITableViewDataSource, UIImagePickerControllerDelegate {
    
    // View
    private var customView: EditProfileView!
    
    // Data
    private var models = [[EditProfileFormModel]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        customView = EditProfileView(frame: view.bounds)
        view.addSubview(customView)
        
        configureModels()
        customView.tableView.dataSource = self
        
        // Load profile photo if available
        if let user = Auth.auth().currentUser {
                // Attempt to load the profile photo from Firestore
                loadProfilePhoto(for: user)
            }
         
        // Add Navigation Bar Buttons
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancel))
        
        // Profile photo button action
        customView.profilePhotoButton.addTarget(self, action: #selector(didTapProfilePhotoButton), for: .touchUpInside)
    }

    private func loadProfilePhoto(for user: FirebaseAuth.User) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.email ?? "")
        
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // Check if profile photo is available
                if let profilePhotoBase64 = document.data()?["profilePhoto"] as? String {
                    // Convert Base64 string to image
                    if let photoData = Data(base64Encoded: profilePhotoBase64),
                       let photo = UIImage(data: photoData) {
                        self.customView.profilePhotoButton.setBackgroundImage(photo, for: .normal)
                    }
                } else {
                    // No profile photo, set default image (person.circle)
                    self.customView.profilePhotoButton.setBackgroundImage(UIImage(systemName: "person.circle"), for: .normal)
                }
            } else {
                // No user document found, set default image
                self.customView.profilePhotoButton.setBackgroundImage(UIImage(systemName: "person.circle"), for: .normal)
            }
        }
    }

    
    private func configureModels() {
        let section1Labels = ["Name", "Bio"]
        var section1 = [EditProfileFormModel]()
        for label in section1Labels {
            let model = EditProfileFormModel(label: label, placeholder: "Enter \(label)", value: nil)
            section1.append(model)
        }
        models.append(section1)
        
        let section2Labels = ["Phone", "Gender"]
        var section2 = [EditProfileFormModel]()
        for label in section2Labels {
            let model = EditProfileFormModel(label: label, placeholder: "Enter \(label)", value: nil)
            section2.append(model)
        }
        models.append(section2)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        customView.frame = view.bounds
    }
    
    // UITableViewDataSource methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: FormTableViewCell.identifier, for: indexPath) as! FormTableViewCell
        cell.configure(with: model)
        cell.textLabel?.text = model.label
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section == 1 else {
            return nil
        }
        return "Private Information"
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.editedImage] as? UIImage {
            customView.profilePhotoButton.setBackgroundImage(image, for: .normal)
            NotificationCenter.default.post(name: .profilePhotoDidChange, object: nil, userInfo: ["profilePhoto": image])
        } else if let image = info[.originalImage] as? UIImage {
            customView.profilePhotoButton.setBackgroundImage(image, for: .normal)
            NotificationCenter.default.post(name: .profilePhotoDidChange, object: nil, userInfo: ["profilePhoto": image])
        }
        
        dismiss(animated: true, completion: nil)
    }


    
    // Called when the user cancels the picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapProfilePhotoButton() {
        // Present image picker to allow the user to choose a photo
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true  // Allow editing (cropping)

        // Check if the camera is available and present the photo library if not
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
        } else {
            imagePickerController.sourceType = .photoLibrary
        }
        
        // Present the image picker
        present(imagePickerController, animated: true)
    }
    @objc private func didTapSave() {
        guard let user = Auth.auth().currentUser else {
            showAlert(message: "No logged-in user found!")
            return
        }

        var updatedData: [String: Any] = [:]
        var updatedBio: String?
        var updatedName: String?

        for section in models {
            for model in section {
                if let value = model.value, !value.isEmpty {
                    updatedData[model.label.lowercased()] = value
                    if model.label.lowercased() == "bio" {
                        updatedBio = value
                    } else if model.label.lowercased() == "name" {
                        updatedName = value
                    }
                }
            }
        }

        // Get the profile photo from the button and convert it to Base64 string
        if let profilePhoto = customView.profilePhotoButton.backgroundImage(for: .normal),
           let imageData = profilePhoto.jpegData(compressionQuality: 0.8) {
            let profilePhotoBase64 = imageData.base64EncodedString()
            updatedData["profilePhoto"] = profilePhotoBase64
        }

        if let updatedName = models[0][0].value, !updatedName.isEmpty {
            UserDefaults.standard.set(updatedName, forKey: "name")
            NotificationCenter.default.post(name: .nameDidChange, object: nil, userInfo: ["name": updatedName])
        }

        if let updatedBio = models[0][1].value, !updatedBio.isEmpty {
            UserDefaults.standard.set(updatedBio, forKey: "bio")
            NotificationCenter.default.post(name: .bioDidChange, object: nil, userInfo: ["bio": updatedBio])
        }

        guard let oldEmail = user.email else {
            showAlert(message: "Current email not available.")
            return
        }

        if let bio = updatedBio, let name = updatedName {
            NotificationCenter.default.post(name: .bioDidChange, object: nil, userInfo: ["bio": bio, "name": name])
        }

        // Continue updating Firestore with profile photo included
        updateFirestoreUserData(email: oldEmail, oldEmail: oldEmail, updatedData: updatedData)
        dismiss(animated: true)
    }

    private func updateFirestoreUserData(email: String, oldEmail: String, updatedData: [String: Any]) {
        let db = Firestore.firestore()
        let oldUserRef = db.collection("users").document(oldEmail)
        let newUserRef = db.collection("users").document(email)
        
        if oldEmail != email {
            oldUserRef.getDocument { (document, error) in
            
                if let document = document, document.exists {
                    var existingData = document.data() ?? [:]
                    updatedData.forEach { existingData[$0.key] = $0.value } // Merge updated data
                    
                    newUserRef.setData(existingData) { error in
                        if let error = error {
                            
                            return
                        }
                        
                        oldUserRef.delete { error in
                            if let error = error {
                                
                            } else {
                               
                            }
                        }
                    }
                }
            }
        } else {
            oldUserRef.setData(updatedData, merge: true) { error in
                if let error = error {
                    
                } else {
                    
                }
            }
        }
    }

    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
    @objc private func didTapCancel() {
        // Handle cancel action
        dismiss(animated: true, completion: nil)
    }
}


extension EditProfileViewController: FormTableViewCellDelegate {
    func formTableViewCell(_ cell: FormTableViewCell, didUpdateField updatedModel: EditProfileFormModel) {
        // Update the corresponding model in models
        for (sectionIndex, section) in models.enumerated() {
            if let rowIndex = section.firstIndex(where: { $0.label == updatedModel.label }) {
                models[sectionIndex][rowIndex].value = updatedModel.value
                break
            }
        }
    }
}



extension Foundation.Notification.Name {
    static let bioDidChange = Foundation.Notification.Name("bioDidChange")
    static let nameDidChange = Foundation.Notification.Name("nameDidChange")
    static let userDidSwitch = Foundation.Notification.Name("userDidSwitch")
    static let profilePhotoDidChange = Foundation.Notification.Name("profilePhotoDidChange")
}
