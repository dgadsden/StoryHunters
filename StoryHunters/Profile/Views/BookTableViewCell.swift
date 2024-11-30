//
//  BookTableViewCell.swift
//  StoryHunters
//
//  Created by Dejah Gadsden on 11/30/24.
//

import UIKit
class BookTableViewCell: UITableViewCell {
    
    var wrapperCellView: UIView!
    var labelName: UILabel!
    var labelAuthor: UILabel!
    var labelRating: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupWrapperCellView()
        setupLabelName()
        setupLabelAuthor()
        setupLabelRating()
        
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWrapperCellView() {
        wrapperCellView = UIView()
        wrapperCellView.backgroundColor = .white
        wrapperCellView.layer.cornerRadius = 6.0
        wrapperCellView.layer.shadowColor = UIColor.gray.cgColor
        wrapperCellView.layer.shadowOffset = .zero
        wrapperCellView.layer.shadowRadius = 4.0
        wrapperCellView.layer.shadowOpacity = 0.4
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapperCellView)
    }
    
    func setupLabelName() {
        labelName = UILabel()
        labelName.font = UIFont.boldSystemFont(ofSize: 20)
        labelName.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelName)
    }
    
    func setupLabelAuthor() {
        labelAuthor = UILabel()
        labelAuthor.font = UIFont.systemFont(ofSize: 14)
        labelAuthor.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelAuthor)
    }
    
    func setupLabelRating() {
        labelRating = UILabel()
        labelRating.font = UIFont.systemFont(ofSize: 12)
        labelRating.textColor = .gray
        labelRating.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelRating)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            // Wrapper view constraints
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            // Name label constraints
            labelName.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 8),
            labelName.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 16),
            labelName.heightAnchor.constraint(equalToConstant: 20),
            
            // Rating label constraints (top right)
            labelRating.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 8),
            labelRating.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -16),
            labelRating.heightAnchor.constraint(equalToConstant: 20),
            
            // Author label constraints
            labelAuthor.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 5),
            labelAuthor.leadingAnchor.constraint(equalTo: labelName.leadingAnchor),
            labelAuthor.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -16),
            labelAuthor.bottomAnchor.constraint(equalTo: wrapperCellView.bottomAnchor, constant: -8),
            
            wrapperCellView.heightAnchor.constraint(equalToConstant: 72)
        ])
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
