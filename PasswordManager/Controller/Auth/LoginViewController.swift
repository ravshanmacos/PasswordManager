//
//  LoginViewController.swift
//  PasswordManager
//
//  Created by Ravshanbek Tursunbaev on 2022/12/29.
//

import UIKit
import RealmSwift
import SwiftKeychainWrapper

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    private let header = FormUI.createLabel(title: "Authenticate the App")
    private let orLabel = FormUI.createLabel(title: "or", fontSize: 16)
    private let username = FormUI.createTextfield(placeholder: "Username")
    private let password = FormUI.createTextfield(placeholder: "Password", isSecure: true)
    private let createAccountButton = FormUI.createButton(title: "Create an account")
    private let nextButton = FormUI.createButton(title: "Next")
    private let form = FormUI.createVStack(spacing: 20)
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        username.delegate = self
        password.delegate = self
        initializeForm()
        nextButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(createTapped), for: .touchUpInside)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        textField.resignFirstResponder()
        return true
    }
    
    @objc func createTapped(){
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let vc = storyboard.instantiateViewController(identifier: "SignUpViewController")
         self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func doneTapped(_ sender: Any) {
        if let username = username.text, let password = password.text{
            let users = realm.objects(User.self)
            let account = "domain.com"
            let service = "token"
            
            if users.contains(where: { user in
                user.username == username && user.password == password
            }){
                let userData = UserData(username: username, password: password)
                KeychainHelper.standard.genericSave(userData, service: service, account: account)
                performSegue(withIdentifier: "loginToMenu", sender: self)
            }else{
                let alert = UIAlertController(title: "Oops!", message: "Credentials did not match", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default)
                alert.addAction(action)
                present(alert,animated: true)
            }
        }
       
        
    }
    deinit {
        print("deinit")
    }
    
    
}

extension LoginViewController{
    
    private func initializeForm(){
        //create blurEffectView
        let blurEffectView = FormUI.createBlurBackground(with: view)
        
        //add username field and location
        form.addArrangedSubview(username)
        FormUI.changeSize(view: username, sizeType: .height, size: 40)
        
        //add password field and location
        form.addArrangedSubview(password)
        FormUI.changeSize(view: password, sizeType: .height, size: 40)
        
        //add form and location
        blurEffectView.contentView.addSubview(form)
        FormUI.location(view: form, relative: blurEffectView, side: .left, margin: 30, isInside: true)
        FormUI.location(view: form, relative: blurEffectView, side: .right, margin: -30, isInside: true)
        FormUI.locateInCenter(view: form, relative: blurEffectView, direction: .vertical)
        
        //add header and location
        blurEffectView.contentView.addSubview(header)
        FormUI.locateInCenter(view: header, relative: blurEffectView, direction: .horizontal)
        FormUI.location(view: header, relative: form, side: .bottom, margin: -70, isInside: false)
        
        //add button and location
        blurEffectView.contentView.addSubview(nextButton)
        FormUI.locateInCenter(view: nextButton, relative: blurEffectView, direction: .horizontal)
        FormUI.location(view: nextButton, relative: form, side: .top, margin: 40, isInside: false)
        FormUI.changeSize(view: nextButton, sizeType: .width, size: 150)
        
        //add OR label and location
        blurEffectView.contentView.addSubview(orLabel)
        FormUI.location(view: orLabel, relative: nextButton, side: .top, margin: 20, isInside: false)
        FormUI.locateInCenter(view: orLabel, relative: blurEffectView, direction: .horizontal)
        
        //add create button
        blurEffectView.contentView.addSubview(createAccountButton)
        FormUI.location(view: createAccountButton, relative: orLabel, side: .top, margin: 20, isInside: false)
        FormUI.locateInCenter(view: createAccountButton, relative: blurEffectView, direction: .horizontal)
        FormUI.changeSize(view: createAccountButton, sizeType: .width, size: 300)
    }
    
}


