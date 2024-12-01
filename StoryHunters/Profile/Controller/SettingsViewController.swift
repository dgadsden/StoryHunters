// SettingsViewController.swift

import FirebaseAuth
import UIKit

struct SettingCellModel {
    let title: String
    let handler: (() -> Void)
}

final class SettingsViewController: UIViewController {
    
    private let settingsView = SettingsView()
    private var data = [[SettingCellModel]]()
    
    override func loadView() {
        self.view = settingsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels()
        settingsView.tableView.delegate = self
        settingsView.tableView.dataSource = self
    }
    
    private func configureModels() {
        data.append([
            SettingCellModel(title: "Edit Profile") { [weak self] in self?.didTapEditProfile() }
        ])
        data.append([
            SettingCellModel(title: "Log Out") { [weak self] in self?.didTapLogOut() }
        ])
    }
    
    private func didTapEditProfile() {
        let vc = EditProfileViewController()
        vc.title = "Edit Profile"
        let navVC = UINavigationController(rootViewController: vc)
        
        present(navVC, animated: true)
    }
    
    private func didTapLogOut() {
        let alert = UIAlertController(title: "Confirmation", message: "Are you sure you want to log out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] _ in
            self?.logOutUser()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func logOutUser() {
        do {
            try Auth.auth().signOut()
            if Auth.auth().currentUser == nil {
                print("User is logged out")
            }
            navigateToLoginScreen()
        } catch let error as NSError {
            print("Error signing out: \(error.localizedDescription)")
            let alert = UIAlertController(title: "Logout Failed", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    private func navigateToLoginScreen() {
        let loginVC = LoginController()
        let navVC = UINavigationController(rootViewController: loginVC)
        navVC.modalPresentationStyle = .fullScreen
        self.view.window?.rootViewController = navVC
        self.view.window?.makeKeyAndVisible()
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        data[indexPath.section][indexPath.row].handler()
    }
}
