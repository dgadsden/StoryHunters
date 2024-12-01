//
//  LoginView.swift
//  StoryHunters
//
//  Created by Dimiar Ilev on 30.11.24.
//

import UIKit

class LoginView: UIView {
    var imageView: UIImageView!
    var titleLabel: UILabel!
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    var loginButton: UIButton!
    var registerButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupImageView()
        setupTitleLabel()
        setupEmailTextField()
        setupPasswordTextField()
        setupLoginButton()
        setupRegisterButton()
        
        initConstraints()
    }
    
    func setupImageView() {
        imageView = UIImageView()
        imageView.image = UIImage(named: "AppLogo")
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0.1 // Adjust transparency (0.0 is fully transparent, 1.0 is opaque)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        self.sendSubviewToBack(imageView) // Ensure it's behind other views
    }

    func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text = "SignUp"
        titleLabel.font = UIFont.systemFont(ofSize: 42, weight: .bold)
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
    }

    func setupEmailTextField() {
        emailTextField = UITextField()
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(emailTextField)
    }
    
    func setupPasswordTextField() {
        passwordTextField = UITextField()
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(passwordTextField)
    }
    
    func setupLoginButton() {
        loginButton = UIButton(type: .system)
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 5
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(loginButton)
    }
    
    func setupRegisterButton() {
        registerButton = UIButton(type: .system)
        registerButton.setTitle("Don't have an account? Register", for: .normal)
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(registerButton)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            // Background
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 50),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            emailTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            emailTextField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            loginButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loginButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            loginButton.heightAnchor.constraint(equalToConstant: 44),
            
            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 15),
            registerButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
