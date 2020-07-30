//
//  LoginViewController.swift
//  LandmarkRemark
//
//  Created by St John Ambulance on 30/7/20.
//  Copyright © 2020 Moin Uddin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var userVM: UserViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.accessibilityIdentifier = "LoginViewController"
        self.userNameField.accessibilityIdentifier = "Username"
        self.passwordField.accessibilityIdentifier = "Password"
        self.loginButton.accessibilityIdentifier = "Login"
        
        self.userNameField.autocorrectionType = .no
        
        userVM = UserViewModel(service: UserService())
    }
    
    @IBAction func onLoginButtonTap(_ sender: UIButton) {
        guard let username = userNameField.text, username > "" else{
            LRAlertController.showAlert(vc: self, title: "Warning", message: "Please type your username", buttons: ["Okay"])
            return
        }
        
        guard let password = passwordField.text, password > "" else{
            LRAlertController.showAlert(vc: self, title: "Warning", message: "Please type your password", buttons: ["Okay"])
            return
        }
        
        userVM.userName = username
        userVM.password = password
        
        userVM.createUser { user, error in
            if let error = error{
                LRAlertController.showAlert(vc: self, title: "Error", message: error.localizedDescription, buttons: ["Okay"])
            }
            
            guard let user = user else{
                LRAlertController.showAlert(vc: self, title: "Error", message: "Login failed. Please try again", buttons: ["Okay"])
                return
            }
            
            guard let mapVC: MapViewController = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController else{
                LRAlertController.showAlert(vc: self, title: "Error", message: "App encountered an unknown error. Please try again", buttons: ["Okay"])
                return
            }
            
            mapVC.user = user
            
            UserDefaults.standard.setValue(username, forKey: "username")
            UserDefaults.standard.setValue(password, forKey: "password")
            UserDefaults.standard.synchronize()
            
            UIView.animate(withDuration: 0.25) {
                UIApplication.shared.keyWindow?.rootViewController = mapVC
            }
        }
    }
}
