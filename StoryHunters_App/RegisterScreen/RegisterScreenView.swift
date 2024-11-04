//
//  RegisterScreenView.swift
//  StoryHunters_App
//
//  Created by Dejah Gadsden on 11/4/24.
//

import UIKit

class RegisterScreenView: UIView {
    
    var contentWrapper: UIScrollView!
    var registerLabel: UILabel!
    var nameTextField: UITextField!
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    var createButton: UIButton!
    var backButton: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupContentWrapper()
        setupRegisterLabel()
        setupNameTextField()
        setupEmailTextField()
        setupPasswordTextField()
        setupCreateAccountButton()
        setupBackButton()
        initConstraints()
        
    }
    
    
    
    func setupContentWrapper() {
        contentWrapper = UIScrollView()
        contentWrapper.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentWrapper)
    }
    
    func setupRegisterLabel(){
        registerLabel = UILabel()
        registerLabel.text = "Register"
        registerLabel.font = .systemFont(ofSize: 24 , weight: .bold)
        registerLabel.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(registerLabel)
    }
    
    func setupNameTextField(){
        nameTextField = UITextField()
        nameTextField.placeholder = "Name"
        nameTextField.keyboardType = .emailAddress
        nameTextField.borderStyle = .roundedRect
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(nameTextField)
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
    
    func setupCreateAccountButton(){
        createButton = UIButton(type: .system)
        createButton.setTitle("Create Account", for: .normal)
        createButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(createButton)
    }
    
    func setupBackButton(){
        backButton = UIButton(type: .system)
        backButton.setTitle("Back to Login", for: .normal)
        backButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        backButton.setTitleColor(.gray, for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(backButton)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            contentWrapper.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            contentWrapper.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            contentWrapper.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            contentWrapper.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            
            
            
            registerLabel.topAnchor.constraint(equalTo: contentWrapper.topAnchor, constant: 32),
            registerLabel.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            registerLabel.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 30),
            registerLabel.trailingAnchor.constraint(equalTo: contentWrapper.trailingAnchor, constant: -30),
            
            nameTextField.topAnchor.constraint(equalTo: registerLabel.bottomAnchor, constant: 16),
            nameTextField.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            nameTextField.leadingAnchor.constraint(equalTo:
                                                        self.safeAreaLayoutGuide.leadingAnchor, constant:
                                                        30),
            nameTextField.trailingAnchor.constraint(equalTo:
                                                        self.safeAreaLayoutGuide.trailingAnchor,
                                                     constant: -30),
            
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
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
            
            createButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            createButton.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            createButton.leadingAnchor.constraint(equalTo:
                                                    self.safeAreaLayoutGuide.leadingAnchor, constant:
                                                    30),
            createButton.trailingAnchor.constraint(equalTo:
                                                    self.safeAreaLayoutGuide.trailingAnchor,
                                                  constant: -30),
            
            backButton.topAnchor.constraint(equalTo: createButton.bottomAnchor, constant: 16),
            backButton.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            backButton.leadingAnchor.constraint(equalTo:
                                                    self.safeAreaLayoutGuide.leadingAnchor, constant:
                                                    30),
            backButton.trailingAnchor.constraint(equalTo:
                                                    self.safeAreaLayoutGuide.trailingAnchor,
                                                  constant: -30),
            
        ])
    }
        
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
