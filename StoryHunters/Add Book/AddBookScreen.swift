//
//  AddBookScreen.swift
//  StoryHunters
//
//  Created by Lia Shechter on 11/5/24.
//
import UIKit
class AddBookScreen: UIView {
    var contentWrapper:UIScrollView!
    var usersBooksLabel: UILabel!
    var usersBooksButton: UIButton!
    
    var newBookLabel: UILabel!
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
        setupUsersBooksLabel()
        setupUsersBooks()
        setupNewBookLabel()
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
    func setupUsersBooksLabel(){
        usersBooksLabel = UILabel()
        usersBooksLabel.text = "Donate one of your books"
        usersBooksLabel.font = .systemFont(ofSize: 20 , weight: .light)
        usersBooksLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(usersBooksLabel)
    }
    func setupUsersBooks(){
        usersBooksButton = UIButton(type: .system)
        usersBooksButton.setTitle("Your books", for: .normal)
        usersBooksButton.tintColor = .black
        usersBooksButton.backgroundColor = .lightGray.withAlphaComponent(0.2)
        usersBooksButton.layer.cornerRadius = 8
        usersBooksButton.layer.borderWidth = 1.5
        usersBooksButton.layer.borderColor = UIColor.gray.cgColor
        usersBooksButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        usersBooksButton.layer.shadowColor = UIColor.black.cgColor
        usersBooksButton.layer.shadowOpacity = 0.1
        usersBooksButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        usersBooksButton.layer.shadowRadius = 3
        usersBooksButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(usersBooksButton)
    }
    func setupNewBookLabel(){
        newBookLabel = UILabel()
        newBookLabel.text = "Donate a new book"
        newBookLabel.font = .systemFont(ofSize: 20 , weight: .light)
        newBookLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(newBookLabel)
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
            
            usersBooksLabel.topAnchor.constraint(equalTo: contentWrapper.topAnchor, constant: 32),
            usersBooksLabel.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 16),
            
            usersBooksButton.topAnchor.constraint(equalTo: usersBooksLabel.bottomAnchor, constant: 16),
            usersBooksButton.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 16),
            usersBooksButton.widthAnchor.constraint(equalToConstant: 150),
            
            newBookLabel.topAnchor.constraint(equalTo: usersBooksButton.bottomAnchor, constant: 16),
            newBookLabel.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 16),
            
            title.topAnchor.constraint(equalTo: newBookLabel.bottomAnchor, constant: 16),
            title.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 16),
            title.trailingAnchor.constraint(equalTo: contentWrapper.trailingAnchor, constant: -16),

            author.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 16),
            author.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 16),
            author.trailingAnchor.constraint(equalTo: contentWrapper.trailingAnchor, constant: -16),

            ratingLabel.topAnchor.constraint(equalTo: author.bottomAnchor, constant: 16),
            ratingLabel.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 16),

            ratingSlider.centerYAnchor.constraint(equalTo: ratingLabel.centerYAnchor),
            ratingSlider.leadingAnchor.constraint(equalTo: ratingLabel.trailingAnchor, constant: 16),
            ratingSlider.trailingAnchor.constraint(equalTo: ratingNumber.leadingAnchor, constant: -16),
            
            ratingNumber.centerYAnchor.constraint(equalTo: ratingLabel.centerYAnchor),
            ratingNumber.trailingAnchor.constraint(equalTo: contentWrapper.trailingAnchor, constant: -16),
            
            buttonAddBook.bottomAnchor.constraint(equalTo: contentWrapper.bottomAnchor, constant: -32),
            buttonAddBook.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
