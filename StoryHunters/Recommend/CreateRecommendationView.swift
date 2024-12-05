//
//  CreateRecommendationView.swift
//  StoryHunters
//
//  Created by Dejah Gadsden on 12/3/24.
//

import UIKit

class CreateRecommendationView: UIView {
    
    var friendsPickerLabel: UILabel!
    var friendsPicker: UIPickerView!
    var booksPickerLabel: UILabel!
    var booksPicker: UIPickerView!
    var recommendationDescription: UITextField!
    var sendButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFriendsPickerLabel()
        setupFriendsPicker()
        setupBooksPickerLabel()
        setupBooksPicker()
        setupRecommendationDescription()
        setupSendButton()
        initConstraints()
    }
    
    func setupFriendsPickerLabel() {
        friendsPickerLabel = UILabel()
        friendsPickerLabel.font = friendsPickerLabel.font.withSize(20)
        friendsPickerLabel.text = "Select a Friend:"
        friendsPickerLabel.textAlignment = .center
        friendsPickerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(friendsPickerLabel)
    }
    
    func setupFriendsPicker() {
        friendsPicker = UIPickerView()
        friendsPicker.isUserInteractionEnabled = true
        friendsPicker.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(friendsPicker)
    }
    
    func setupBooksPickerLabel() {
        booksPickerLabel = UILabel()
        booksPickerLabel.font = booksPickerLabel.font.withSize(20)
        booksPickerLabel.text = "Select a Book You Have Read:"
        booksPickerLabel.textAlignment = .center
        booksPickerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(booksPickerLabel)
    }
    
    func setupBooksPicker() {
        booksPicker = UIPickerView()
        booksPicker.isUserInteractionEnabled = true
        booksPicker.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(booksPicker)
    }
    
    func setupRecommendationDescription() {
        recommendationDescription = UITextField()
        recommendationDescription.placeholder = "Why are you recommending this?"
        recommendationDescription.borderStyle = .roundedRect
        recommendationDescription.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(recommendationDescription)
    }
    
    func setupSendButton() {
        sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        sendButton.backgroundColor = UIColor.systemBlue
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.layer.cornerRadius = 8
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(sendButton)
    }
    
    private func initConstraints() {
        NSLayoutConstraint.activate([
            // Friends label
            friendsPickerLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            friendsPickerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            friendsPickerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            // Friends picker
            friendsPicker.topAnchor.constraint(equalTo: friendsPickerLabel.bottomAnchor, constant: 10),
            friendsPicker.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            friendsPicker.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            friendsPicker.heightAnchor.constraint(equalToConstant: 100),
            
            // Books label
            booksPickerLabel.topAnchor.constraint(equalTo: friendsPicker.bottomAnchor, constant: 20),
            booksPickerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            booksPickerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            // Books picker
            booksPicker.topAnchor.constraint(equalTo: booksPickerLabel.bottomAnchor, constant: 10),
            booksPicker.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            booksPicker.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            booksPicker.heightAnchor.constraint(equalToConstant: 100),
            
            // Recommendation description
            recommendationDescription.topAnchor.constraint(equalTo: booksPicker.bottomAnchor, constant: 20),
            recommendationDescription.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            recommendationDescription.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            recommendationDescription.heightAnchor.constraint(equalToConstant: 44),
            
            // Send button
            sendButton.topAnchor.constraint(equalTo: recommendationDescription.bottomAnchor, constant: 20),
            sendButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            sendButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

