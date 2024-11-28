//
//  BooksTableViewCell.swift
//  StoryHunters
//
//  Created by Lia Shechter on 11/5/24.
//

import UIKit

class BooksTableViewCell: UITableViewCell {
    var wrapperCellView: UIView!
    var labelTitle: UILabel!
    var labelAuthor: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupWrapperCellView()
        setupLabelTitle()
        setupLabelAuthor()

        initConstraints()
    }

    func setupWrapperCellView(){
        wrapperCellView = UITableViewCell()
        
        //working with the shadows and colors...
        wrapperCellView.backgroundColor = .white
        wrapperCellView.layer.cornerRadius = 4.0
        wrapperCellView.layer.shadowColor = UIColor.gray.cgColor
        wrapperCellView.layer.shadowOffset = .zero
        wrapperCellView.layer.shadowRadius = 2.0
        wrapperCellView.layer.shadowOpacity = 0.7
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapperCellView)
    }
    
    func setupLabelTitle(){
        labelTitle = UILabel()
        labelTitle.font = UIFont.boldSystemFont(ofSize: 16)
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelTitle)
    }
    
    func setupLabelAuthor(){
        labelAuthor = UILabel()
        labelAuthor.font = UIFont.boldSystemFont(ofSize: 16)
        labelAuthor.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelAuthor)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor,constant: 4),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            
            labelTitle.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 8),
            labelTitle.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 10),
            labelTitle.heightAnchor.constraint(equalToConstant: 20),
            labelTitle.widthAnchor.constraint(equalTo: wrapperCellView.widthAnchor),
            
            labelAuthor.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 4),
            labelAuthor.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 10),
            labelAuthor.heightAnchor.constraint(equalToConstant: 20),
            labelAuthor.widthAnchor.constraint(equalTo: wrapperCellView.widthAnchor),

            wrapperCellView.heightAnchor.constraint(equalToConstant: 60)
            
        ])
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
