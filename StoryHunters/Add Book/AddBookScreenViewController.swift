//
//  AddBookScreenViewController.swift
//  StoryHunters
//
//  Created by Lia Shechter on 11/5/24.
//

import UIKit

class AddBookScreenViewController: UIViewController {
    
    let mainScreen = AddBookScreen()
    
    override func loadView() {
        view = mainScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add Book"
    }
    


}
