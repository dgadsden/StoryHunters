//
//  LibraryScreenViewController.swift
//  StoryHunters
//
//  Created by Lia Shechter on 11/5/24.
//

import UIKit

class LibraryScreenViewController: UIViewController {
    let mainScreen = LibraryScreen()
    
    override func loadView() {
        view = mainScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Litte Library"

        mainScreen.addBookButton.addTarget(self, action: #selector(onButtonAddTapped), for: .touchUpInside)
    }
    
    @objc func onButtonAddTapped(){
        let addBook = AddBookScreenViewController()
        navigationController?.pushViewController(addBook, animated: true)
    }

}
