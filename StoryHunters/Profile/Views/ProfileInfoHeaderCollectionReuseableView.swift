//
//  ProfileInfoHeaderCollectionreuseableView.swift
//  StoryHunters
//
//  Created by temp on 11/17/24.
//

import UIKit

class ProfileInfoHeaderCollectionReuseableView: UICollectionReusableView {
    static let identifier = "ProfileInfoHeaderCollectionReuseableView"
    private let profilePhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemBlue
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let libraryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Libraries", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .secondarySystemBackground
        return button
    }()
    /*
    private let followingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Following", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .secondarySystemBackground
        return button
    }()
    
    
    private let followersButton: UIButton = {
        let button = UIButton()
        button.setTitle("Followers", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .secondarySystemBackground
        return button
    }()
    */
    
    
    private let editProfileButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit Your Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .secondarySystemBackground
        return button
    }()

    /*
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Joe Smith"
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.text = "This is my biography!"
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        backgroundColor = .systemBackground
        clipsToBounds = true
    }
    
    private func addSubviews() {
        addSubview(profilePhotoImageView)
        //addSubview(followersButton)
        //addSubview(followingButton)
        addSubview(editProfileButton)
        addSubview(libraryButton)
        //addSubview(bioLabel)
        //addSubview(nameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let profilePhotoSize = frame.size.width/4
        profilePhotoImageView.frame = CGRect(x: 5, y: 5, width: profilePhotoSize, height: profilePhotoSize).integral
        
        profilePhotoImageView.layer.cornerRadius = profilePhotoSize/2.0
        
        let buttonHeight = profilePhotoSize/2
        let countButtonWidth = (frame.size.width-10-profilePhotoSize)/3
        libraryButton.frame = CGRect(x: profilePhotoImageView.right, y: 5, width: countButtonWidth, height: buttonHeight).integral
        
        //followersButton.frame = CGRect(x: libraryButton.right, y: 5, width: countButtonWidth, height: buttonHeight).integral
        
        //followingButton.frame = CGRect(x: followersButton.right, y: 5, width: countButtonWidth, height: buttonHeight).integral
        
        editProfileButton.frame = CGRect(x: profilePhotoImageView.right, y: 5 + buttonHeight, width: countButtonWidth*3, height: buttonHeight).integral
        
        //nameLabel.frame = CGRect(x: 5, y: 5 + profilePhotoImageView.bottom, width: frame.size.width-10, height: 50).integral
        
        //let bioLabelSize = bioLabel.sizeThatFits(frame.size)
        
        //bioLabel.frame = CGRect(x: 5, y: 5 + nameLabel.bottom, width: frame.size.width-10, height: bioLabelSize.height).integral
        
    }
}

