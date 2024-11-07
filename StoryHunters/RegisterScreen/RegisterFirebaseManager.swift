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
                    self.setNameOfTheUserInFirebaseAuth(name: name)
                    
                }else{
                    //MARK: there is a error creating the user...
                    print(error)
                }
            })
        }
    }
    
    //MARK: We set the name of the user after we create the account...
    func setNameOfTheUserInFirebaseAuth(name: String){
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges(completion: {(error) in
            if error == nil{
                //MARK: the profile update is successful...
                self.presentingViewController!.dismiss(animated: true)
            }else{
                //MARK: there was an error updating the profile...
                print("Error occured: \(String(describing: error))")
            }
        })
    }
}
