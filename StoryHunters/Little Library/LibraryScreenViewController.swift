//
//  LibraryScreenViewController.swift
//  StoryHunters
//
//  Created by Lia Shechter on 11/5/24.
//

import UIKit
import FirebaseFirestore
import MapKit

class LibraryScreenViewController: UIViewController {
    let mainScreen = LibraryScreen()
    let database = Firestore.firestore()
    var library: Library?
    var books = [Book]()
    
    override func loadView() {
        view = mainScreen
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let library = library {
            title = library.title
        }
        
        mainScreen.tableViewBooks.delegate = self
        mainScreen.tableViewBooks.dataSource = self
        mainScreen.tableViewBooks.separatorStyle = .none
        
        mainScreen.addBookButton.addTarget(self, action: #selector(onButtonAddTapped), for: .touchUpInside)
        if let library {
                mainScreen.mapView.centerToLocation(
                    location: CLLocation(
                        latitude: library.coordinate.latitude,
                        longitude: library.coordinate.longitude
                    )
                )
            
            mainScreen.mapView.delegate = self
            mainScreen.mapView.showsUserLocation = false
            mainScreen.mapView.addAnnotation(library)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mapTapped))
        mainScreen.mapView.addGestureRecognizer(tapGesture)
    }
    
    @objc func mapTapped() {
        // Open Apple Maps with the library's location
        if let library {
            let destination = MKMapItem(placemark: MKPlacemark(coordinate: library.coordinate))
            destination.name = "Library Location"
            
            let launchOptions = [
                MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
            ]
            destination.openInMaps(launchOptions: launchOptions)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.database.collection("Libraries")
                            .document((self.library?.id)!)
                            .collection("books")
                            .addSnapshotListener(includeMetadataChanges: false, listener: {querySnapshot, error in
                                if let documents = querySnapshot?.documents{
                                    self.books.removeAll()
                                    for document in documents{
                                        do{
                                            let book  = try document.data(as: Book.self)
                                            self.books.append(book)
                                        }catch{
                                            print(error)
                                        }
                                    }
                                    self.books.sort(by: {$0.title < $1.title})
                                    self.mainScreen.tableViewBooks.reloadData()
                                }
                            })
    }
    
    @objc func onButtonAddTapped(){
        let addBook = AddBookScreenViewController()
        addBook.library = library
        navigationController?.pushViewController(addBook, animated: true)
    }
    
    func deleteSelectedFor(book: Int) {
        print("made it here 1")
        let selectedBook = books[book]
        
        if let library = library {
            print("made it here 2")
            if let libraryID = library.id {
                print("made it here 3")
                let collectionBooks = database
                    .collection("Libraries")
                    .document(libraryID)
                    .collection("books")
                print("made it here 4")
                if let bookID = selectedBook.id {
                    
                    collectionBooks.document(bookID).delete { error in
                        if let error = error {
                            print("Error deleting book: \(error)")
                        } else {
                            print("Book deleted successfully")
                            
                            // Update the local data source
                            self.books.remove(at: book)
                            
                            // Reload the table view
                            self.mainScreen.tableViewBooks.reloadData()
                        }
                    }
                } else {
                    print("No book found to delete")
                }
            }
        }
    }
}
extension LibraryScreenViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "books", for: indexPath) as! BooksTableViewCell
        cell.labelTitle.text = books[indexPath.row].title
        cell.labelAuthor.text = books[indexPath.row].author
        
        //MARK: crating an accessory button...
        let buttonOptions = UIButton(type: .system)
        buttonOptions.sizeToFit()
        buttonOptions.showsMenuAsPrimaryAction = true
        //MARK: setting an icon from sf symbols...
        buttonOptions.setImage(UIImage(systemName: "trash"), for: .normal)
        
        //MARK: setting up menu for button options click...
        buttonOptions.menu = UIMenu(title: "Delete book?",
                                    children: [
                                        UIAction(title: "Delete",handler: {(_) in
                                            self.deleteSelectedFor(book: indexPath.row)
                                        })
                                    ])
        //MARK: setting the button as an accessory of the cell...
        cell.accessoryView = buttonOptions
        return cell
    }
}
