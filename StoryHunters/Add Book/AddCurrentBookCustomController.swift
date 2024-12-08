//
//  AddCurrentBookCustomController.swift
//  StoryHunters
//
//  Created by Lia Shechter on 12/2/24.
//

import UIKit

class AddCurrentBookCustomViewController: CurrentBooksViewController {
    var addBookScreenViewController:AddBookScreenViewController?
    var ratingLabel = UILabel(frame: CGRect(x: 200, y: 20, width: 40, height: 30))
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBook = booksList[indexPath.row]
        let alert = UIAlertController(title: "Rate Book", message: "Add a new rating for \(selectedBook.title)", preferredStyle: .alert)
        
        let sliderVC = UIViewController()
        sliderVC.preferredContentSize = CGSize(width: 250, height: 100)
        
        let slider = UISlider(frame: CGRect(x: 10, y: 20, width: 180, height: 30))
        slider.minimumValue = 0
        slider.maximumValue = 10
        slider.value = 0
        
        ratingLabel.textAlignment = .center
        ratingLabel.text = String(format: "%.1f", slider.value) // Initial value
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        
        sliderVC.view.addSubview(slider)
        sliderVC.view.addSubview(ratingLabel)
        
        alert.setValue(sliderVC, forKey: "contentViewController")
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { _ in

            let newRating = Double(slider.value)
            print("New rating for \(selectedBook.title): \(newRating)")
            
            // Save the new rating to Firestore
            if let addBookScreenViewController = self.addBookScreenViewController {
                addBookScreenViewController.saveBookToFirestore(book: selectedBook, newRating: newRating)
            }
            
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        ratingLabel.text = "\(Int(sender.value))"
    }
}
