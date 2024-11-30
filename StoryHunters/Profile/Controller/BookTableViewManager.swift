//
//  BookTableViewManager.swift
//  StoryHunters
//
//  Created by Dejah Gadsden on 11/30/24.
//

import Foundation
import UIKit
import CryptoKit
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booksList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Configs.tableViewBooksID, for: indexPath) as! BookTableViewCell
        let book = booksList[indexPath.row]
        print("Configuring cell for book: \(book.title)")  // Debug line
        cell.labelName.text = book.title
        cell.labelAuthor.text = book.author
        cell.labelRating.text = String(format: "%.1f", book.rating ?? 0.0)
        return cell
    }
    
}
