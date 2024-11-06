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
    var tableViewBooks: UITableView!
    var addBookButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupMapView()
        setupTableViewBooks()
        setupAddBookButton()
        initConstraints()
    }
    
    func setupMapView(){
        mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.layer.cornerRadius = 10
        self.addSubview(mapView)
    }
    
    func setupTableViewBooks(){
        tableViewBooks = UITableView()
        tableViewBooks.register(BooksTableViewCell.self, forCellReuseIdentifier: "names")
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
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            mapView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            mapView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            mapView.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.95),
            mapView.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor, multiplier: 0.25),
            
            addBookButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            addBookButton.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            tableViewBooks.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 8),
            tableViewBooks.bottomAnchor.constraint(equalTo: addBookButton.topAnchor),
            tableViewBooks.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            tableViewBooks.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
