//
//  RegisterFirebaseManager.swift
//  StoryHunters
//
//  Created by Dejah Gadsden on 11/6/24.
//

import Foundation
import FirebaseAuth

extension RegisterController{
    
    func uploadProfilePhotoToStorage() {
        if let image = pickedImage, let jpegData = image.jpegData(compressionQuality: 0.8) {
            let storageRef = storage.reference().child("profileImages/\(Auth.auth().currentUser?.uid ?? UUID().uuidString).jpg")
            storageRef.putData(jpegData, metadata: nil) { metadata, error in
                if let error = error {
                    self.hideActivityIndicator()
                    self.showErrorAlert(alert: "Error uploading photo: \(error.localizedDescription)")
                    return
                }
                
                storageRef.downloadURL { url, error in
                    if let downloadURL = url {
                        self.registerUser(photoURL: downloadURL)
                    } else {
                        self.hideActivityIndicator()
                        self.showErrorAlert(alert: "Error getting download URL")
                    }
                }
            }
        } else {
            registerUser(photoURL: nil)
        }
    }
    
    /*
    func uploadProfilePhotoToStorage(){
        var profilePhotoURL:URL?
        
        //MARK: Upload the profile photo if there is any
        if let image = pickedImage{
            if let jpegData = image.jpegData(compressionQuality: 80){
                let storageRef = storage.reference()
                let imagesRepo = storageRef.child("imagesUsers")
                let imageRef = imagesRepo.child("\(NSUUID().uuidString).jpg")
                let uploadTask = imageRef.putData(jpegData, completion: {(metadata, error) in
                    if error == nil{
                        imageRef.downloadURL(completion: {(url, error) in
                            if error == nil{
                                profilePhotoURL = url
                                print(profilePhotoURL)
                                self.registerUser(photoURL: profilePhotoURL)
                            }
                        })
                    }
                    else {
                        self.showErrorAlert(alert: "Error uploading photo: \(error)")
                    }
                })
            }
        }else{
            registerUser(photoURL: profilePhotoURL)
        }
    }
    */
    
    func registerUser(photoURL: URL?) {
        guard let email = registerView.emailTextField.text,
              let password = registerView.passwordTextField1.text,
              let name = registerView.nameTextField.text else {
            hideActivityIndicator()
            showErrorAlert(alert: "Missing registration information")
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            self.hideActivityIndicator()
            
            if let error = error {
                self.showErrorAlert(alert: "Error creating account: \(error.localizedDescription)")
                return
            }

            guard let firebaseUser = authResult?.user else { return }

            let changeRequest = firebaseUser.createProfileChangeRequest()
            changeRequest.displayName = name
            changeRequest.photoURL = photoURL
            changeRequest.commitChanges { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    self.showErrorAlert(alert: "Error updating profile: \(error.localizedDescription)")
                    return
                }

                // Save user to Firestore
                let user = User(name: name,
                                email: email.lowercased(),
                                profilePhoto: photoURL?.absoluteString)
                self.saveUserToFirestore(user: user)
            }
        }
    }

    // Save User to Firestore
    func saveUserToFirestore(user: User) {
        let userRef = database.collection("users").document(user.email.lowercased())
        
        do {
            try userRef.setData(from: user) { error in
                self.hideActivityIndicator()
                if let error = error {
                    print("Error saving user to Firestore: \(error.localizedDescription)")
                    self.showErrorAlert(alert: "Error saving user data: \(error.localizedDescription)")
                } else {
                    print("User successfully saved to Firestore")
                    self.navigateToMainScreen()
                }
            }
        } catch {
            self.hideActivityIndicator()
            print("Error encoding user: \(error.localizedDescription)")
            self.showErrorAlert(alert: "Error encoding user data: \(error.localizedDescription)")
        }
    }
    
    
    /*
    func registerUser(photoURL: URL?){
        if let name = registerView.nameTextField.text,
           let email = registerView.emailTextField.text,
           let password = registerView.passwordTextField1.text{
            Auth.auth().createUser(withEmail: email, password: password, completion: {result, error in
                if error == nil{
                    self.setNameAndPhotoOfTheUserInFirebaseAuth(name: name, email: email, photoURL: photoURL)
                }
                else {
                    if let errorMessage = error?.localizedDescription{
                        self.showErrorAlert(alert: errorMessage)
                    }
                    print(error?.localizedDescription)
                }
            })
        }
    }
    
    func setNameAndPhotoOfTheUserInFirebaseAuth(name: String, email: String, photoURL: URL?){
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.photoURL = photoURL
        
        print("\(photoURL)")
        changeRequest?.commitChanges(completion: {(error) in
            if error != nil{
                self.showErrorAlert(alert: "Error occured: \(String(describing: error))")
                print("Error occured: \(String(describing: error))")
            }else{
                self.hideActivityIndicator()
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
     */
}
