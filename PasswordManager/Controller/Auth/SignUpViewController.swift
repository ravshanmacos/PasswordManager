//
//  SignUpViewController.swift
//  PasswordManager
//
//  Created by Ravshanbek Tursunbaev on 2022/12/29.
//

import UIKit
import SwiftKeychainWrapper

class SignUpViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var verifyPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        username.delegate = self
        password.delegate = self
        verifyPassword.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        textField.resignFirstResponder()
        return true
    }
    

    @IBAction func doneTapped(_ sender: Any) {
       
        if let username = username.text,let password = password.text, let verifyPassword = verifyPassword.text{
            checkUser(user: username)
            if password == verifyPassword{
                let usernameSaved: Bool = KeychainWrapper.standard.set(username, forKey: "username")
                let passwordSaved: Bool = KeychainWrapper.standard.set(password, forKey: "password")
                if usernameSaved && passwordSaved{
                    performSegue(withIdentifier: Constants.SeguesDirection.signUpToMenu, sender: self)
                }
            }
        }
    }
    
    private func checkUser(user:String){
        
    }
    
}
