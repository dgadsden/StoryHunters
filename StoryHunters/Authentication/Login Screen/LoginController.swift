//
//  LoginController.swift
//  StoryHunters
//
//  Created by Dimiar Ilev on 30.11.24.
//

import UIKit
import FirebaseAuth

class LoginController: UIViewController {
    let loginView = LoginView()
    let childProgressView = ProgressSpinnerViewController() // Optional: For showing a loading spinner
    
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Login"
    }
    
    private func setupActions() {
        loginView.loginButton.addTarget(self, action: #selector(onLoginTapped), for: .touchUpInside)
        loginView.registerButton.addTarget(self, action: #selector(onRegisterTapped), for: .touchUpInside)
    }
    
    @objc func onLoginTapped() {
        let email = loginView.emailTextField.text ?? ""
        let password = loginView.passwordTextField.text ?? ""
        
        // Validate input
        guard !email.isEmpty, !password.isEmpty else {
            showErrorAlert(message: "Please fill in all fields.")
            return
        }
        
        if !isValidEmail(email) {
            showErrorAlert(message: "Please enter a valid email address.")
            return
        }
        
        // Show a spinner while authenticating
        showActivityIndicator()
        
        // Firebase Authentication
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            self.hideActivityIndicator()
            
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                // Navigate to the Main Screen on successful login
                self.navigateToMainScreen()
            }
        }
    }
    
    @objc func onRegisterTapped() {
        // Navigate to the Register Screen
        let registerVC = RegisterScreenViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    private func navigateToMainScreen() {
        let mainScreenVC = ViewController() // Replace with your main screen class
        let navController = UINavigationController(rootViewController: mainScreenVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func showActivityIndicator() {
        addChild(childProgressView)
        view.addSubview(childProgressView.view)
        childProgressView.didMove(toParent: self)
    }
    
    private func hideActivityIndicator() {
        childProgressView.willMove(toParent: nil)
        childProgressView.view.removeFromSuperview()
        childProgressView.removeFromParent()
    }
}

