//
//  LibraryScreen.swift
//  StoryHunters
//
//  Created by Lia Shechter on 11/5/24.
//
import UIKit
import MapKit
class LibraryScreen: UIView {
    var mapView:MKMapView!
    var labelBooks: UILabel!
    var tableViewBooks: UITableView!
    var addBookButton: UIButton!
    var bookIcon: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupMapView()
        setupLabelBooks()
        setupTableViewBooks()
        setupAddBookButton()
        setupBookIcon()
        initConstraints()
    }
    
    func setupMapView(){
        mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.layer.cornerRadius = 10
        self.addSubview(mapView)
    }
    func setupLabelBooks(){
        labelBooks = UILabel()
        labelBooks.text = "Books at this location"
        labelBooks.font = .systemFont(ofSize: 20 , weight: .light)
        labelBooks.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelBooks)
    }
    func setupTableViewBooks(){
        tableViewBooks = UITableView()
        tableViewBooks.register(BooksTableViewCell.self, forCellReuseIdentifier: "books")
        tableViewBooks.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewBooks)
    }
    func setupAddBookButton(){
        addBookButton = UIButton(type: .system)
        addBookButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        addBookButton.setTitle("Add Book", for: .normal)
        addBookButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(addBookButton)
    }
    func setupBookIcon(){
        bookIcon = UIImageView(image: UIImage(systemName: "book.pages"))
        bookIcon.tintColor = .gray
        bookIcon.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bookIcon)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            mapView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            mapView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            mapView.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.95),
            mapView.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor, multiplier: 0.25),
            
            bookIcon.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 28),
            bookIcon.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            
            labelBooks.centerYAnchor.constraint(equalTo: bookIcon.centerYAnchor),
            labelBooks.leadingAnchor.constraint(equalTo: bookIcon.trailingAnchor, constant: 8),
            
            addBookButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            addBookButton.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            tableViewBooks.topAnchor.constraint(equalTo: labelBooks.bottomAnchor, constant: 8),
            tableViewBooks.bottomAnchor.constraint(equalTo: addBookButton.topAnchor),
            tableViewBooks.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            tableViewBooks.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
