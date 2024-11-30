//
//  ProfileView.swift
//  StoryHunters
//
//  Created by temp on 11/14/24.
//

// ProfileView.swift

import UIKit

class ProfileView: UIView {
    
    var collectionView: UICollectionView!
    var tableViewBooks: UITableView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        setupCollectionView()
        setupTableViewBooks()
        initConstraints()
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: self.frame.size.width/3, height: self.frame.size.width/3)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.register(ProfileInfoHeaderCollectionReuseableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileInfoHeaderCollectionReuseableView.identifier)
        guard let collectionView = collectionView else {
            return
        }
        self.addSubview(collectionView)
    }
    
    func setupTableViewBooks() {
        tableViewBooks = UITableView()
        tableViewBooks.register(BookTableViewCell.self, forCellReuseIdentifier: Configs.tableViewBooksID)
        tableViewBooks.separatorStyle = .none
        tableViewBooks.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewBooks)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            //            collectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            //            collectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            //            collectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            //            collectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
            
            tableViewBooks.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            tableViewBooks.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            tableViewBooks.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableViewBooks.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
