//
//  ProfileView.swift
//  StoryHunters
//
//  Created by temp on 11/14/24.
//

// ProfileView.swift

import UIKit

class ProfileView: UIView {
    
    var profileImage: UIImageView!
    var nameLabel: UILabel!
    var profileOptionsTableView: UITableView!
    var tableViewBooks: UITableView!
    var headerView: ProfileInfoHeaderCollectionReuseableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        setupHeaderView()
        setupProfileImage()
        setupLabelName()
        setupProfileOptionsTableView()  // Setting up the Profile Options Table
        initConstraints()
    }
    
    func setupHeaderView() {
        headerView = ProfileInfoHeaderCollectionReuseableView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(headerView)
    }
    
    func setupProfileImage() {
        profileImage = UIImageView()
        profileImage.image = UIImage(named: "profile")
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(profileImage)
    }
    
    func setupLabelName() {
        nameLabel = UILabel()
        //nameLabel.text = "Name"
        nameLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        nameLabel.textColor = .label
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nameLabel)
    }
    
    func setupProfileOptionsTableView() {
        profileOptionsTableView = UITableView()
        profileOptionsTableView.register(ProfileOptionsTableViewCell.self, forCellReuseIdentifier: "ProfileOptionCell")
        
        // Adjust the separator style and space between cells
        profileOptionsTableView.separatorInset = .zero // Make sure separators span the full width if you decide to show them
        
        // Set light gray background for the cells
        profileOptionsTableView.backgroundColor = .clear
        
        profileOptionsTableView.layer.borderColor = UIColor.gray.cgColor  // Border color
        profileOptionsTableView.layer.borderWidth = 1.0                  // Border width
        profileOptionsTableView.layer.cornerRadius = 8.0
        profileOptionsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set custom cell height
        profileOptionsTableView.rowHeight = 60 // Add more space between the cells
        
        // Add the table view to the main view
        self.addSubview(profileOptionsTableView)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
//            profileImage.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16),
//            profileImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//            profileImage.widthAnchor.constraint(equalToConstant: 100),  // Adjust image size
//            profileImage.heightAnchor.constraint(equalToConstant: 100), // Adjust image size
            
            headerView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 300),
            
            nameLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -120),
            
            // Set constraints for profileOptionsTableView with a max height
            profileOptionsTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 32),
            profileOptionsTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileOptionsTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            profileOptionsTableView.heightAnchor.constraint(lessThanOrEqualToConstant: 240),  // Max height for table view
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
