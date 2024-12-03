//
//  AddCurrentBookCustomController.swift
//  StoryHunters
//
//  Created by Lia Shechter on 12/2/24.
//

import UIKit

class AddCurrentBookCustomViewController: CurrentBooksViewController {
    var addBookScreenViewController:AddBookScreenViewController?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBook = booksList[indexPath.row]
        if let addBookScreenViewController = addBookScreenViewController {
            addBookScreenViewController.saveBookToFirestore(book: selectedBook)
            self.navigationController?.popViewController(animated: true)
        }
    }
}
