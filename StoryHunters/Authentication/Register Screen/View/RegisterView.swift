//
//  RegisterView.swift
//  StoryHunters
//
//  Created by Dimiar Ilev on 30.11.24.
//

import UIKit

class RegisterView: UIView {
    var welcomeLabel: UILabel!
    var titleLabel: UILabel!
    
    var imageView: UIImageView!
    
    var nameTextField: UITextField!
    var emailTextField: UITextField!
    var passwordTextField1: UITextField!
    var passwordTextField2: UITextField!
    var registerButton: UIButton!
    var loginButton: UIButton!
    var labelPhoto: UILabel!
    var buttonTakePhoto: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        //setupWelcomeLabel()
        //setupTitleLabel()
        setupImageView()
        setupNameTextField()
        setupEmailTextField()
        setupPasswordTextField1()
        setupPasswordTextField2()
        setupRegisterButton()
        setupLoginButton()
        setupLabelPhoto()
        setupButtonTakePhoto()
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
    
    /*
    func setupWelcomeLabel() {
        welcomeLabel = UILabel()
        welcomeLabel.text = "Welcome to StoryHunters!"
        welcomeLabel.font = UIFont.boldSystemFont(ofSize: 24)
        welcomeLabel.textAlignment = .center
        welcomeLabel.numberOfLines = 0
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(welcomeLabel)
    }
    
    func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text = "Register"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
    }
    */
    
    func setupNameTextField() {
        nameTextField = UITextField()
        nameTextField.placeholder = "Name"
        nameTextField.borderStyle = .roundedRect
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nameTextField)
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
    
    func setupPasswordTextField1() {
        passwordTextField1 = UITextField()
        passwordTextField1.placeholder = "Password"
        passwordTextField1.borderStyle = .roundedRect
        passwordTextField1.isSecureTextEntry = true
        passwordTextField1.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(passwordTextField1)
    }
    
    func setupPasswordTextField2() {
        passwordTextField2 = UITextField()
        passwordTextField2.placeholder = "Password"
        passwordTextField2.borderStyle = .roundedRect
        passwordTextField2.isSecureTextEntry = true
        passwordTextField2.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(passwordTextField2)
    }
    
    func setupRegisterButton() {
        registerButton = UIButton(type: .system)
        registerButton.setTitle("Register", for: .normal)
        registerButton.backgroundColor = .systemBlue
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.layer.cornerRadius = 5
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(registerButton)
    }
    
    func setupLoginButton() {
        loginButton = UIButton(type: .system)
        loginButton.setTitle("Already have an account? Login", for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(loginButton)
    }
    
    func setupLabelPhoto() {
        labelPhoto = UILabel()
        labelPhoto.text = "Pick Profile Picture"
        labelPhoto.font = UIFont.boldSystemFont(ofSize: 14)
        labelPhoto.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelPhoto)
    }
    
    func setupButtonTakePhoto() {
        buttonTakePhoto = UIButton(type: .system)
        buttonTakePhoto.setTitle("", for: .normal)
        buttonTakePhoto.setImage(UIImage(systemName: "person.crop.circle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        buttonTakePhoto.contentHorizontalAlignment = .fill
        buttonTakePhoto.contentVerticalAlignment = .fill
        buttonTakePhoto.imageView?.contentMode = .scaleAspectFit
        buttonTakePhoto.showsMenuAsPrimaryAction = true
        buttonTakePhoto.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonTakePhoto)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            // Background
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            /*
            welcomeLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            welcomeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            titleLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            */
            
            buttonTakePhoto.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            buttonTakePhoto.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            buttonTakePhoto.widthAnchor.constraint(equalToConstant: 100),
            buttonTakePhoto.heightAnchor.constraint(equalToConstant: 100),
            
            labelPhoto.topAnchor.constraint(equalTo: buttonTakePhoto.bottomAnchor, constant: 5),
            labelPhoto.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: labelPhoto.bottomAnchor, constant: 20),
            nameTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            nameTextField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            emailTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            emailTextField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),
            
            passwordTextField1.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField1.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            passwordTextField1.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            passwordTextField1.heightAnchor.constraint(equalToConstant: 44),
            
            passwordTextField2.topAnchor.constraint(equalTo: passwordTextField1.bottomAnchor, constant: 20),
            passwordTextField2.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            passwordTextField2.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            passwordTextField2.heightAnchor.constraint(equalToConstant: 44),
            
            registerButton.topAnchor.constraint(equalTo: passwordTextField2.bottomAnchor, constant: 30),
            registerButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            registerButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            registerButton.heightAnchor.constraint(equalToConstant: 44),
            
            loginButton.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 15),
            loginButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
