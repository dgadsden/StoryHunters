//
//  LoginScreenView.swift
//  StoryHunters_App
//
//  Created by Dejah Gadsden on 11/4/24.
//

import UIKit

class LoginScreenView: UIView {
    
    var contentWrapper: UIScrollView!
    var LoginLabel: UILabel!
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    var registerButton: UIButton!
    var loginButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupContentWrapper()
        setupLoginLabel()
        setupEmailTextField()
        setupPasswordTextField()
        setupRegisterButton()
        setupLoginButton()
        initConstraints()
        
    }
    func setupContentWrapper() {
        contentWrapper = UIScrollView()
        contentWrapper.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentWrapper)
    }
    
    func setupLoginLabel(){
        LoginLabel = UILabel()
        LoginLabel.text = "Login"
        LoginLabel.font = .systemFont(ofSize: 24 , weight: .bold)
        LoginLabel.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(LoginLabel)
    }
    
    
    func setupEmailTextField(){
        emailTextField = UITextField()
        emailTextField.placeholder = "Email"
        emailTextField.keyboardType = .emailAddress
        emailTextField.borderStyle = .roundedRect
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(emailTextField)
    }
    
    func setupPasswordTextField(){
        passwordTextField = UITextField()
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(passwordTextField)
    }
    
    func setupLoginButton(){
        loginButton = UIButton(type: .system)
        loginButton.setTitle("Login", for: .normal)
        loginButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(loginButton)
    }
    
    func setupRegisterButton(){
        registerButton = UIButton(type: .system)
        registerButton.setTitle("No account? Register", for: .normal)
        registerButton.setTitleColor(.gray, for: .normal)
        registerButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(registerButton)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            contentWrapper.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            contentWrapper.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            contentWrapper.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            contentWrapper.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            
            
            
            LoginLabel.topAnchor.constraint(equalTo: contentWrapper.topAnchor, constant: 32),
            LoginLabel.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            LoginLabel.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 30),
            LoginLabel.trailingAnchor.constraint(equalTo: contentWrapper.trailingAnchor, constant: -30),
            
            
            emailTextField.topAnchor.constraint(equalTo: LoginLabel.bottomAnchor, constant: 16),
            emailTextField.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            emailTextField.leadingAnchor.constraint(equalTo:
                                                        self.safeAreaLayoutGuide.leadingAnchor, constant:
                                                        30),
            emailTextField.trailingAnchor.constraint(equalTo:
                                                        self.safeAreaLayoutGuide.trailingAnchor,
                                                     constant: -30),
            
            
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo:
                                                        self.safeAreaLayoutGuide.leadingAnchor, constant:
                                                        30),
            passwordTextField.trailingAnchor.constraint(equalTo:
                                                            self.safeAreaLayoutGuide.trailingAnchor,
                                                        constant: -30),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            loginButton.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            loginButton.leadingAnchor.constraint(equalTo:
                                                    self.safeAreaLayoutGuide.leadingAnchor, constant:
                                                    30),
            loginButton.trailingAnchor.constraint(equalTo:
                                                    self.safeAreaLayoutGuide.trailingAnchor,
                                                  constant: -30),
            
            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            registerButton.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            registerButton.leadingAnchor.constraint(equalTo:
                                                        self.safeAreaLayoutGuide.leadingAnchor, constant:
                                                        30),
            registerButton.trailingAnchor.constraint(equalTo:
                                                        self.safeAreaLayoutGuide.trailingAnchor,
                                                     constant: -30),
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
