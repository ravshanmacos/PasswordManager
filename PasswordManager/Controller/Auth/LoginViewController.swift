//
//  LoginViewController.swift
//  PasswordManager
//
//  Created by Ravshanbek Tursunbaev on 2022/12/29.
//

import UIKit
import SwiftKeychainWrapper

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        username.delegate = self
        password.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        if let username = username.text, let password = password.text{
            let retrievedUsername: String? = KeychainWrapper.standard.string(forKey: "username")
            let retrievedPassword: String? = KeychainWrapper.standard.string(forKey: "password")
            if username == retrievedUsername && password == retrievedPassword{
                performSegue(withIdentifier: Constants.SeguesDirection.loginToMenu, sender: self)
            }
        }
    }
    
}
