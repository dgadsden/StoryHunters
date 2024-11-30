//
//  RegisterFirebaseManager.swift
//  StoryHunters
//
//  Created by Dejah Gadsden on 11/6/24.
//

import Foundation
import FirebaseAuth

extension RegisterScreenViewController{
    
    func registerNewAccount(){
        //MARK: create a Firebase user with email and password...
        if let name = registerScreen.nameTextField.text,
           let email = registerScreen.emailTextField.text,
           let password = registerScreen.passwordTextField.text{
            //Validations....
            Auth.auth().createUser(withEmail: email, password: password, completion: {result, error in
                if error == nil{
                    //MARK: the user creation is successful...
                    self.setNameOfTheUserInFirebaseAuth(name: name, email: email)
                }else{
                    //MARK: there is a error creating the user...
                    print(error)
                }
            })
        }
    }
    
    
    //MARK: We set the name of the user after we create the account...
    func setNameOfTheUserInFirebaseAuth(name: String, email: String){
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges(completion: {(error) in
            if error == nil{
                //MARK: the profile update is successful...
                let user = User(name: name, email: email.lowercased())
                self.saveUserToFirestore(user: user)
                self.dismiss(animated: true) {
                    self.dismiss(animated: true, completion: nil) // Dismiss the login screen as well
                }
            }else{
                //MARK: there was an error updating the profile...
                print("Error occured: \(String(describing: error))")
            }
        })
    }
    
    func saveUserToFirestore(user: User) {
        let userRef = database.collection("users").document(user.email.lowercased())
        
        do {
            try userRef.setData(from: user) { error in
                self.hideActivityIndicator()
                if let error = error {
                    print("Error saving user to Firestore: \(error.localizedDescription)")
                    self.showAlert("Error saving user data: \(error.localizedDescription)")
                } else {
                    print("User successfully saved to Firestore")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } catch {
            self.hideActivityIndicator()
            print("Error encoding user: \(error.localizedDescription)")
            self.showAlert("Error encoding user data: \(error.localizedDescription)")
        }
    }
}
