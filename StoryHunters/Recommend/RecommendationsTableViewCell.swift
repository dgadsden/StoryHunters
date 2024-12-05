//
//  RecommendationsTableViewCell.swift
//  StoryHunters
//
//  Created by Dejah Gadsden on 12/4/24.
//

import UIKit
import FirebaseAuth

protocol RecommendationsTableViewCellDelegate: AnyObject {
    func didTapLikeButton(on recommendation: Recommendation)
    func didTapDislikeButton(on recommendation: Recommendation)
    func didUpdateRecommendation(_ recommendation: Recommendation)
}

class RecommendationsTableViewCell: UITableViewCell {
    
    // UI Elements
    var titleLabel: UILabel!
    var descriptionLabel: UILabel!
    var recommendedByLabel: UILabel!
    var dateLabel: UILabel!
    var likeButton: UIButton!
    var dislikeButton: UIButton!
    
    var recommendation: Recommendation!
    
    weak var delegate: RecommendationsTableViewCellDelegate?
    
    var shouldShowRateButtons: Bool = false {
        didSet {
            likeButton.isHidden = !shouldShowRateButtons
            dislikeButton.isHidden = !shouldShowRateButtons
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Initialize the UI elements
        titleLabel = UILabel()
        descriptionLabel = UILabel()
        recommendedByLabel = UILabel()
        dateLabel = UILabel()
        likeButton = UIButton()
        dislikeButton = UIButton()
        
        // Customize the UI elements (e.g., font, size, etc.)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        recommendedByLabel.font = UIFont.italicSystemFont(ofSize: 14)
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = .gray
        likeButton = UIButton(type: .system)
        likeButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        
        dislikeButton = UIButton(type: .system)
        dislikeButton.setImage(UIImage(systemName: "hand.thumbsdown"), for: .normal)
        
        // Set filled images for the buttons (when selected)
        likeButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .selected)
        dislikeButton.setImage(UIImage(systemName: "hand.thumbsdown.fill"), for: .selected)
        
        likeButton.backgroundColor = .clear
        dislikeButton.backgroundColor = .clear
        
        
        // Add the labels to the content view
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(recommendedByLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(likeButton)
        contentView.addSubview(dislikeButton)
        
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        dislikeButton.addTarget(self, action: #selector(dislikeButtonTapped), for: .touchUpInside)
        
        // Set up the constraints or frame for the labels
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    // Function to set up the layout of the labels (using Auto Layout)
    private func setupConstraints() {
        // Enable Auto Layout
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        recommendedByLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        dislikeButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Add constraints for titleLabel, descriptionLabel, recommendedByLabel, and dateLabel
        NSLayoutConstraint.activate([
            // Title label
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Description label
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Recommended by label
            recommendedByLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 4),
            recommendedByLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            recommendedByLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Date label
            dateLabel.topAnchor.constraint(equalTo: recommendedByLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Like and Dislike buttons
            dislikeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            dislikeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            likeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            likeButton.trailingAnchor.constraint(equalTo: dislikeButton.leadingAnchor, constant: -8), // Space between the buttons
        ])
    }
    
    // Function to configure the cell with a Recommendation object
    func configure(with recommendation: Recommendation) {
        titleLabel.text = recommendation.title
        descriptionLabel.text = recommendation.description
        recommendedByLabel.text = "You Recommended to: \(recommendation.recommendedTo ?? "Unknown")"
        
        // Format the date (if it's valid)
        if let date = recommendation.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            dateLabel.text = "Date: \(dateFormatter.string(from: date))"
        } else {
            dateLabel.text = "Date: N/A"
        }
        
        shouldShowRateButtons = recommendation.recommendedBy != Auth.auth().currentUser?.email
        likeButton.isSelected = recommendation.likedByUser ?? false
        dislikeButton.isSelected = recommendation.dislikedByUser ?? false
        
    }
    
    
    func configureIncoming(with recommendation: Recommendation) {
        titleLabel.text = recommendation.title
        descriptionLabel.text = recommendation.description
        recommendedByLabel.text = "Recommended by: \(recommendation.recommendedBy ?? "Unknown")"
        
        // Format the date (if it's valid)
        if let date = recommendation.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            dateLabel.text = "Date: \(dateFormatter.string(from: date))"
        } else {
            dateLabel.text = "Date: N/A"
        }
        
        // Show or hide rate buttons based on whether the recommendation is incoming
        shouldShowRateButtons = recommendation.recommendedBy != Auth.auth().currentUser?.email
        
        // Show or hide the "You Recommended" label (for outgoing recommendations)
        if recommendation.recommendedBy == Auth.auth().currentUser?.email {
            recommendedByLabel.text = "You Recommended to: \(recommendation.recommendedTo ?? "Unknown")"
        } else {
            recommendedByLabel.text = "Recommended by: \(recommendation.recommendedBy ?? "Unknown")"
        }
        likeButton.isSelected = recommendation.likedByUser ?? false
        dislikeButton.isSelected = recommendation.dislikedByUser ?? false
    }
    
    @objc private func likeButtonTapped() {
            guard let recommendation = recommendation else {
                print("Recommendation is nil")
                return
            }
            likeButton.isSelected = true
            dislikeButton.isSelected = false
            delegate?.didTapLikeButton(on: recommendation)
        }

        @objc private func dislikeButtonTapped() {
            guard let recommendation = recommendation else {
                print("Recommendation is nil")
                return
            }
            
            
            dislikeButton.isSelected = true
            likeButton.isSelected = false
            delegate?.didTapDislikeButton(on: recommendation)
        }
    
}

