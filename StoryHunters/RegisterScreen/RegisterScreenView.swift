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
    
    func setupRegisterLabel() {
        registerLabel = UILabel()
        registerLabel.text = "Create Account"
        registerLabel.font = .systemFont(ofSize: 24, weight: .bold)
        registerLabel.textAlignment = .center
        registerLabel.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(registerLabel)
    }
    
    func setupTextField(_ textField: UITextField, placeholder: String) {
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 16)
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(textField)
    }
    
    func setupNameTextField() {
        nameTextField = UITextField()
        setupTextField(nameTextField, placeholder: "Name")
    }
    
    func setupEmailTextField() {
        emailTextField = UITextField()
        setupTextField(emailTextField, placeholder: "Email")
    }
    
    func setupPasswordTextField() {
        passwordTextField = UITextField()
        setupTextField(passwordTextField, placeholder: "Password")
        passwordTextField.isSecureTextEntry = true
    }
    
    func setupCreateAccountButton() {
        createButton = UIButton(type: .system)
        createButton.setTitle("Create Account", for: .normal)
        createButton.backgroundColor = .systemBlue
        createButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        createButton.setTitleColor(.white, for: .normal)
        createButton.layer.cornerRadius = 8
        createButton.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(createButton)
    }
    
    func setupBackButton() {
        backButton = UIButton(type: .system)
        backButton.setTitle("Back to Login", for: .normal)
        backButton.titleLabel?.font = .systemFont(ofSize: 14)
        backButton.setTitleColor(.gray, for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(backButton)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            contentWrapper.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            contentWrapper.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentWrapper.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentWrapper.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            registerLabel.topAnchor.constraint(equalTo: contentWrapper.topAnchor, constant: 40),
            registerLabel.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            registerLabel.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 20),
            registerLabel.trailingAnchor.constraint(equalTo: contentWrapper.trailingAnchor, constant: -20),
            
            nameTextField.topAnchor.constraint(equalTo: registerLabel.bottomAnchor, constant: 24),
            nameTextField.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: contentWrapper.trailingAnchor, constant: -20),
            
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            emailTextField.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: contentWrapper.trailingAnchor, constant: -20),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: contentWrapper.trailingAnchor, constant: -20),
            
            createButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 24),
            createButton.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 20),
            createButton.trailingAnchor.constraint(equalTo: contentWrapper.trailingAnchor, constant: -20),
            createButton.heightAnchor.constraint(equalToConstant: 50),
            
            backButton.topAnchor.constraint(equalTo: createButton.bottomAnchor, constant: 16),
            backButton.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
