import UIKit

class EditProfileView: UIView {
    
    // UI Components
    let tableView: UITableView!
    var profilePhotoButton: UIButton!
    
    // Initializer
    override init(frame: CGRect) {
        self.tableView = UITableView()
        self.profilePhotoButton = UIButton()
        
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        configureTableView()
        configureProfilePhotoButton()
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // TableView setup
    private func configureTableView() {
        tableView.register(FormTableViewCell.self, forCellReuseIdentifier: FormTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // Profile Photo button setup
    private func configureProfilePhotoButton() {
        profilePhotoButton = UIButton(type: .system)
        profilePhotoButton.layer.masksToBounds = true
        profilePhotoButton.contentHorizontalAlignment = .fill
        profilePhotoButton.contentVerticalAlignment = .fill
        profilePhotoButton.imageView?.contentMode = .scaleAspectFit
        profilePhotoButton.showsMenuAsPrimaryAction = true
        profilePhotoButton.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        profilePhotoButton.setBackgroundImage(UIImage(systemName: "person.circle"), for: .normal)
        profilePhotoButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // Add subviews and constraints
    private func addSubviews() {
        addSubview(tableView)
        addSubview(profilePhotoButton)
        
        // Profile photo button constraints
        NSLayoutConstraint.activate([
            profilePhotoButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            profilePhotoButton.topAnchor.constraint(equalTo: topAnchor, constant: 70),
            profilePhotoButton.widthAnchor.constraint(equalToConstant: frame.height / 5),
            profilePhotoButton.heightAnchor.constraint(equalToConstant: frame.height / 5)
        ])
        
        // TableView constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: profilePhotoButton.bottomAnchor, constant: 20),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
