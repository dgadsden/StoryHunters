


import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import PhotosUI

struct EditProfileFormModel {
    let label: String
    let placeholder: String
    var value: String?
}

class EditProfileViewController: UIViewController, UINavigationControllerDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, PHPickerViewControllerDelegate {
    
    // View
    private var customView: EditProfileView!
    
    // Data
    let childProgressView = ProgressSpinnerViewController()
    private var models = [[EditProfileFormModel]]()
    let storage = Storage.storage()
    let database = Firestore.firestore()
    var pickedImage:UIImage?
    
    
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
        //        customView.profilePhotoButton.addTarget(self, action: #selector(didTapProfilePhotoButton), for: .touchUpInside)
        customView.profilePhotoButton.menu = getMenuImagePicker()
        
    }
    
    private func loadProfilePhoto(for user: FirebaseAuth.User) {
        
        guard let currentUser = Auth.auth().currentUser,
              let photoURL = currentUser.photoURL else {
            // Default image if no photoURL is set
            self.customView.profilePhotoButton.setBackgroundImage(UIImage(systemName: "person.circle"), for: .normal)
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
                self.customView.profilePhotoButton.setBackgroundImage(image, for: .normal)
            }
        }.resume()
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
    
    private func getMenuImagePicker() -> UIMenu{
        let menuItems = [
            UIAction(title: "Camera",handler: {(_) in
                self.pickUsingCamera()
            }),
            UIAction(title: "Gallery",handler: {(_) in
                self.pickPhotoFromGallery()
            })
        ]
        
        return UIMenu(title: "Select source", children: menuItems)
    }
    
    //MARK: take Photo using Camera...
    private func pickUsingCamera(){
        let cameraController = UIImagePickerController()
        cameraController.sourceType = .camera
        cameraController.allowsEditing = true
        cameraController.delegate = self
        present(cameraController, animated: true)
    }
    
    //MARK: pick Photo using Gallery...
    private func pickPhotoFromGallery(){
        //MARK: Photo from Gallery...
        var configuration = PHPickerConfiguration()
        configuration.filter = PHPickerFilter.any(of: [.images])
        configuration.selectionLimit = 1
        
        let photoPicker = PHPickerViewController(configuration: configuration)
        
        photoPicker.delegate = self
        present(photoPicker, animated: true, completion: nil)
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
        
        
        
        if let updatedName = models[0][0].value, !updatedName.isEmpty {
            UserDefaults.standard.set(updatedName, forKey: "name")
            NotificationCenter.default.post(name: .nameDidChange, object: nil, userInfo: ["name": updatedName])
        }
        
        if let updatedBio = models[0][1].value, !updatedBio.isEmpty {
            UserDefaults.standard.set(updatedBio, forKey: "bio")
            NotificationCenter.default.post(name: .bioDidChange, object: nil, userInfo: ["bio": updatedBio])
        }
        
        if let pickedImage = pickedImage {
            uploadProfilePhotoToStorage(image: pickedImage) { [weak self] photoURL in
                self?.updateFirebaseProfilePhoto(photoURL: photoURL)
            }
            NotificationCenter.default.post(name: .profilePhotoDidChange, object: nil, userInfo: ["profilePhoto": pickedImage])

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
    
    func uploadProfilePhotoToStorage(image: UIImage, completion: @escaping (URL?) -> Void) {
        guard let jpegData = image.jpegData(compressionQuality: 0.8) else {
            completion(nil)
            return
        }
        
        let storageRef = Storage.storage().reference().child("profileImages/\(Auth.auth().currentUser?.uid ?? UUID().uuidString).jpg")
        
        storageRef.putData(jpegData, metadata: nil) { metadata, error in
            if let error = error {
                self.showErrorAlert(alert: "Error uploading photo: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            storageRef.downloadURL { url, error in
                if let url = url {
                    completion(url)
                } else {
                    self.showErrorAlert(alert: "Error getting download URL")
                    completion(nil)
                }
            }
        }
    }
    
    func updateFirebaseProfilePhoto(photoURL: URL?) {
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        // Update the Firebase Authentication profile photo
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.photoURL = photoURL
        changeRequest.commitChanges { [weak self] error in
            if let error = error {
                self?.showErrorAlert(alert: "Error updating profile: \(error.localizedDescription)")
            } else {
                // Success in updating the authentication profile
                print("Profile photo updated successfully in Firebase Authentication.")
            }
        }

        // Safely unwrap the userEmail
        guard let userEmail = user.email else {
            self.showErrorAlert(alert: "User email not found.")
            return
        }
        
        // Reference to the Firestore user's document
        let userRef = database.collection("users").document(userEmail)
        
        // Update the profilePhoto field in Firestore with the photo URL string
        userRef.updateData([
            "profilePhoto": photoURL?.absoluteString ?? ""
        ]) { error in
            if let error = error {
                self.showErrorAlert(alert: "Error updating Firestore: \(error.localizedDescription)")
            } else {
                print("Firestore profile photo updated successfully!")
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
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        print(results)
        
        let itemprovider = results.map(\.itemProvider)
        
        for item in itemprovider{
            if item.canLoadObject(ofClass: UIImage.self){
                item.loadObject(
                    ofClass: UIImage.self,
                    completionHandler: { (image, error) in
                        DispatchQueue.main.async{
                            if let uwImage = image as? UIImage{
                                self.customView.profilePhotoButton.setBackgroundImage(
                                    uwImage.withRenderingMode(.alwaysOriginal),
                                    for: .normal
                                )
                                self.pickedImage = uwImage
                            }
                        }
                    }
                )
            }
        }
    }
    
    func showErrorAlert(alert: String){
        let alert = UIAlertController(title: "Error!", message: alert, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true)
    }
    
}



extension Foundation.Notification.Name {
    static let bioDidChange = Foundation.Notification.Name("bioDidChange")
    static let nameDidChange = Foundation.Notification.Name("nameDidChange")
    static let userDidSwitch = Foundation.Notification.Name("userDidSwitch")
    static let profilePhotoDidChange = Foundation.Notification.Name("profilePhotoDidChange")
}
