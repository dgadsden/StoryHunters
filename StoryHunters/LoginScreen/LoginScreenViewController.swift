//
//  LoginScreenViewController.swift
//  StoryHunters
//
//  Created by Dejah Gadsden on 11/4/24.
//

import UIKit
import FirebaseAuth


class LoginScreenViewController: UIViewController {

    let loginScreen = LoginScreenView()
    var pickedImage: UIImage?
    
    override func loadView() {
        view = loginScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                

        loginScreen.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        loginScreen.registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
    }
    
    @objc func loginButtonTapped() {
        guard let email = loginScreen.emailTextField.text, !email.isEmpty,
              let password = loginScreen.passwordTextField.text, !password.isEmpty else {
            showAlert("Please enter both email and password.")
            return
        }
        
        if !isValidEmail(email) {
            showAlert("Please enter a valid email address.")
            return
        }
        
        // TODO: call function to login user
        self.signInToFirebase(email: email, password: password)
    }
    
    @objc func registerButtonTapped() {
        let registerController = RegisterScreenViewController()
        registerController.modalPresentationStyle = .fullScreen
        present(registerController, animated: true, completion: nil)
    }
    
    @objc func dismissLogin() {
        dismiss(animated: false)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        // Regular expression for validating an Email
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Login Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func signInToFirebase(email: String, password: String){
            //MARK: can you display progress indicator here?
            //MARK: authenticating the user...
            Auth.auth().signIn(withEmail: email, password: password, completion: {(result, error) in
                if error == nil{
                    //MARK: user authenticated...
                    self.dismiss(animated: true)
                }else{
                    //MARK: alert that no user found or password wrong...
                }
            })
        }
}

