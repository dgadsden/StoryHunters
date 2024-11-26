//
//  RegisterScreenViewController.swift
//  StoryHunters
//
//  Created by Dejah Gadsden on 11/4/24.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import UIKit
import PhotosUI

class RegisterScreenViewController: UIViewController {
    
    var registerScreen = RegisterScreenView()
    let childProgressView = ProgressSpinnerViewController()
    let storage = Storage.storage()
    let database = Firestore.firestore()

    
    override func loadView() {
        view = registerScreen
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        registerScreen.createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        registerScreen.backButton.addTarget(self, action: #selector(onBackButtonTapped), for: .touchUpInside)
    }
    
    @objc func createButtonTapped() {
        guard let name = registerScreen.nameTextField.text, !name.isEmpty,
              let email = registerScreen.emailTextField.text, !email.isEmpty,
              let password = registerScreen.passwordTextField.text, !password.isEmpty else {
            showAlert("Please fill in all fields.")
            return
        }
        
       // TODO: call function to register user
        registerNewAccount()
    }
    
    @objc func onBackButtonTapped() {
        
        self.dismiss(animated: true)
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func clearInputFields() {
        // Assuming you have IBOutlet properties for your text fields
        registerScreen.nameTextField.text = ""
        registerScreen.emailTextField.text = ""
        registerScreen.passwordTextField.text = ""
    }
    
    func hideActivityIndicator(){
        childProgressView.willMove(toParent: nil)
        childProgressView.view.removeFromSuperview()
        childProgressView.removeFromParent()
    }
    
}

