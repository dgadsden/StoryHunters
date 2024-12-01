//
//  AddBookScreenViewController.swift
//  StoryHunters
//
//  Created by Lia Shechter on 11/5/24.
//
import UIKit
import CryptoKit
import FirebaseFirestore
class AddBookScreenViewController: UIViewController {
    
    let mainScreen = AddBookScreen()
    let database = Firestore.firestore()
    var library: Library?
    
    override func loadView() {
        view = mainScreen
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Book"
        
        mainScreen.ratingSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        mainScreen.buttonAddBook.addTarget(self, action: #selector(onButtonAddBookTapped), for: .touchUpInside)
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        mainScreen.ratingNumber.text = "\(Int(sender.value))"
       }
    
    @objc func onButtonAddBookTapped() {
        if let title = mainScreen.title.text,
           let author = mainScreen.author.text,
           let rating = mainScreen.ratingNumber.text {
            let titleAndAuthor = [title, author]
            let titleAuthorString = titleAndAuthor.joined()
            let bookID = titleAuthorString.lowercased()
            let book = Book(id: bookID, title: title, author: author, rating: Double(rating)!)
            self.saveBookToFirestore(book: book)
        }
    }
    
    func saveBookToFirestore(book: Book) {
        if let library = library {
            if let bookID = book.id {
                if let libraryID = library.id {
                    let collectionBooks = database
                        .collection("Libraries")
                        .document(libraryID)
                        .collection("books")
                        .document(bookID)
                    do{
                        try collectionBooks.setData(from: book) { error in
                            if error == nil{
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }catch{
                        print("Error adding document!")
                    }
                }
            }
        }
    }
}
