import UIKit

class LoginScreenView: UIView {
    
    struct Constants {
        static let cornerRadius: CGFloat = 8.0
    }
    
    var contentWrapper: UIScrollView!
    var headerView: UIView!
    var headerImageView: UIImageView!
    var gradientLayer: CAGradientLayer!
    var titleLabel: UILabel!
    var loginLabel: UILabel!
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    var registerButton: UIButton!
    var loginButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        
        setupHeaderView()
        setupTitleLabel()
        setupContentWrapper()
        setupLoginLabel()
        setupEmailTextField()
        setupPasswordTextField()
        setupRegisterButton()
        setupLoginButton()
        initConstraints()
    }
    
    func setupHeaderView() {
        headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(headerView)
        
        headerImageView = UIImageView()
        headerImageView.image = UIImage(named: "gradient")
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.clipsToBounds = true
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(headerImageView)
        
    }
    
    func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text = "StoryHunters"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)
    }
    
    func setupContentWrapper() {
        contentWrapper = UIScrollView()
        contentWrapper.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentWrapper)
    }
    
    func setupLoginLabel(){
        loginLabel = UILabel()
        loginLabel.text = "Login"
        loginLabel.font = .systemFont(ofSize: 24, weight: .bold)
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(loginLabel)
    }
    
    func setupEmailTextField() {
        emailTextField = UITextField()
        emailTextField.placeholder = "Username or Email..."
        emailTextField.returnKeyType = .next
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        emailTextField.layer.masksToBounds = true
        emailTextField.layer.cornerRadius = Constants.cornerRadius
        emailTextField.backgroundColor = .secondarySystemBackground
        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.borderColor = UIColor.secondaryLabel.cgColor
        emailTextField.leftViewMode = .always
        emailTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(emailTextField)
    }
    
    func setupPasswordTextField() {
        passwordTextField = UITextField()
        passwordTextField.placeholder = "Password..."
        passwordTextField.isSecureTextEntry = true
        passwordTextField.returnKeyType = .continue
        passwordTextField.autocapitalizationType = .none
        passwordTextField.autocorrectionType = .no
        passwordTextField.layer.masksToBounds = true
        passwordTextField.layer.cornerRadius = Constants.cornerRadius
        passwordTextField.backgroundColor = .secondarySystemBackground
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.borderColor = UIColor.secondaryLabel.cgColor
        passwordTextField.leftViewMode = .always
        passwordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(passwordTextField)
    }
    
    func setupLoginButton() {
        loginButton = UIButton(type: .system)
        loginButton.setTitle("Log In", for: .normal)
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = Constants.cornerRadius
        loginButton.backgroundColor = .systemBlue
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(loginButton)
    }
    
    func setupRegisterButton() {
        registerButton = UIButton(type: .system)
        registerButton.setTitle("New User? Create an Account", for: .normal)
        registerButton.setTitleColor(.label, for: .normal)
        registerButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(registerButton)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: self.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            headerView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1/3.0),
            
            headerImageView.topAnchor.constraint(equalTo: headerView.topAnchor),
            headerImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            headerImageView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            contentWrapper.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            contentWrapper.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            contentWrapper.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            contentWrapper.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            
            loginLabel.topAnchor.constraint(equalTo: contentWrapper.topAnchor, constant: 32),
            loginLabel.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            
            emailTextField.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 16),
            emailTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            emailTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            emailTextField.heightAnchor.constraint(equalToConstant: 52),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
            passwordTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            passwordTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            passwordTextField.heightAnchor.constraint(equalToConstant: 52),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
            loginButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loginButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            loginButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            loginButton.heightAnchor.constraint(equalToConstant: 52),
            
            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10),
            registerButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            registerButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            registerButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -30),
        ])
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
