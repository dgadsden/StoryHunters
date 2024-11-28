//
//  AddBookScreen.swift
//  StoryHunters
//
//  Created by Lia Shechter on 11/5/24.
//
import UIKit
class AddBookScreen: UIView {
    var contentWrapper:UIScrollView!
    var title: UITextField!
    var author: UITextField!
    var ratingLabel: UILabel!
    var ratingSlider: UISlider!
    var ratingNumber: UILabel!
    var buttonAddBook: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        setupContentWrapper()
        setupTitle()
        setupAuthor()
        setupRatingLabel()
        setupRatingSlider()
        setupRatingNumber()
        setupButtonAddBook()
        
        initConstraints()
    }
    
    func setupContentWrapper(){
        contentWrapper = UIScrollView()
        contentWrapper.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentWrapper)
    }
    func setupTitle(){
        title = UITextField()
        title.placeholder = "title"
        title.borderStyle = .roundedRect
        title.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(title)
    }
    func setupAuthor(){
        author = UITextField()
        author.placeholder = "author"
        author.borderStyle = .roundedRect
        author.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(author)
    }
    func setupRatingLabel(){
        ratingLabel = UILabel()
        ratingLabel.text = "Rating"
        ratingLabel.font = UIFont.systemFont(ofSize: 18)
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(ratingLabel)
    }
    func setupRatingSlider(){
        ratingSlider = UISlider()
        ratingSlider.minimumValue = 1
        ratingSlider.maximumValue = 10
        ratingSlider.value = 0
        ratingSlider.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(ratingSlider)
    }
    func setupRatingNumber(){
        ratingNumber = UILabel()
        ratingNumber.text = "0"
        ratingNumber.font = UIFont.systemFont(ofSize: 18)
        ratingNumber.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(ratingNumber)
    }
    func setupButtonAddBook(){
        buttonAddBook = UIButton(type: .system)
        buttonAddBook.setTitle("Add Book", for: .normal)
        buttonAddBook.tintColor = .systemBlue
        buttonAddBook.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonAddBook)
    }
    func initConstraints(){
        NSLayoutConstraint.activate([
            contentWrapper.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            contentWrapper.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            contentWrapper.widthAnchor.constraint(equalTo:self.safeAreaLayoutGuide.widthAnchor),
            contentWrapper.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor),
            
            title.topAnchor.constraint(equalTo: contentWrapper.topAnchor, constant: 32),
            title.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 16),
            title.trailingAnchor.constraint(equalTo: contentWrapper.trailingAnchor, constant: -16),
            
            author.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 32),
            author.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 16),
            author.trailingAnchor.constraint(equalTo: contentWrapper.trailingAnchor, constant: -16),
            
            ratingLabel.topAnchor.constraint(equalTo: author.bottomAnchor, constant: 32),
            ratingLabel.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 16),
            
            ratingSlider.topAnchor.constraint(equalTo: ratingLabel.topAnchor),
            ratingSlider.leadingAnchor.constraint(equalTo: ratingLabel.trailingAnchor, constant: 16),
            
            ratingNumber.topAnchor.constraint(equalTo: ratingSlider.topAnchor),
            ratingNumber.trailingAnchor.constraint(equalTo: contentWrapper.trailingAnchor, constant: -16),
            ratingNumber.centerYAnchor.constraint(equalTo: ratingSlider.centerYAnchor),
            
            ratingSlider.trailingAnchor.constraint(equalTo: ratingNumber.leadingAnchor, constant: -16),
            
            buttonAddBook.bottomAnchor.constraint(equalTo: contentWrapper.bottomAnchor, constant: -32),
            buttonAddBook.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
