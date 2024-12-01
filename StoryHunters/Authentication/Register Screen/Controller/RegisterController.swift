//
//  RegisterController.swift
//  StoryHunters
//
//  Created by Dimiar Ilev on 01.12.24.
//
import UIKit
import FirebaseFirestore
import FirebaseStorage
import UIKit
import PhotosUI

class RegisterController: UIViewController {

    let registerView = RegisterView()
    let childProgressView = ProgressSpinnerViewController()
    let storage = Storage.storage()
    var pickedImage:UIImage?
    
    override func loadView() {
        view = registerView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        registerView.registerButton.addTarget(self, action: #selector(onRegisterTapped), for: .touchUpInside)
        registerView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        title = "Register"
        registerView.buttonTakePhoto.menu = getMenuImagePicker()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }
    
    @objc func onRegisterTapped() {
        let name = registerView.nameTextField.text ?? ""
        let email = registerView.emailTextField.text ?? ""
        let password1 = registerView.passwordTextField1.text ?? ""
        let password2 = registerView.passwordTextField2.text ?? ""

        if name.isEmpty || email.isEmpty || password1.isEmpty || password2.isEmpty {
            showErrorAlert(alert: "Please fill in all fields.")
            return
        }

        if !isValidEmail(email) {
            showErrorAlert(alert: "Please enter a valid email address.")
            return
        }

        if password1 != password2 {
            showErrorAlert(alert: "Passwords do not match.")
            return
        }

        // Check if email already exists in Firestore
        let db = Firestore.firestore()
        db.collection("users").whereField("email", isEqualTo: email).getDocuments { (querySnapshot, err) in
            if let err = err {
                self.showErrorAlert(alert: "Error checking email: \(err.localizedDescription)")
            }
            if querySnapshot!.documents.count > 0 {
                self.showErrorAlert(alert: "Email already exists.")
            } else {
                // Email is unique, proceed with registration
                self.showActivityIndicator()
                self.uploadProfilePhotoToStorage()
                self.navigateToMainScreen()
            }
        }
    }
    
    private func navigateToMainScreen() {
        let mainScreenVC = ViewController()
        let navController = UINavigationController(rootViewController: mainScreenVC)
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first {
            window.rootViewController = navController
            window.makeKeyAndVisible()
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func showActivityIndicator(){
        addChild(childProgressView)
        view.addSubview(childProgressView.view)
        childProgressView.didMove(toParent: self)
    }
    
    private func hideActivityIndicator(){
        childProgressView.willMove(toParent: nil)
        childProgressView.view.removeFromSuperview()
        childProgressView.removeFromParent()
    }
    
    @objc func loginButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func getMenuImagePicker() -> UIMenu{
        let menuItems = [
            UIAction(title: "Camera",handler: {(_) in
                self.pickUsingCamera()
            }),
            UIAction(title: "Gallery",handler: {(_) in
                self.pickPhotoFromGallery()
            })
        ]
        
        return UIMenu(title: "Select source", children: menuItems)
    }
    
    //MARK: take Photo using Camera...
    private func pickUsingCamera(){
        let cameraController = UIImagePickerController()
        cameraController.sourceType = .camera
        cameraController.allowsEditing = true
        cameraController.delegate = self
        present(cameraController, animated: true)
    }
    
    //MARK: pick Photo using Gallery...
    private func pickPhotoFromGallery(){
        //MARK: Photo from Gallery...
        var configuration = PHPickerConfiguration()
        configuration.filter = PHPickerFilter.any(of: [.images])
        configuration.selectionLimit = 1
        
        let photoPicker = PHPickerViewController(configuration: configuration)
        
        photoPicker.delegate = self
        present(photoPicker, animated: true, completion: nil)
    }
    
    private func showErrorAlert(alert: String){
        let alert = UIAlertController(title: "Error!", message: alert, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true)
    }
    
}
