//
//  SignUpViewController.swift
//  PasswordManager
//
//  Created by Ravshanbek Tursunbaev on 2022/12/29.
//

import UIKit
import RealmSwift
import SwiftKeychainWrapper

class SignUpViewController: UIViewController,UITextFieldDelegate {
    
    private let header = FormUI.createLabel(title: "Create an account")
    private let orLabel = FormUI.createLabel(title: "or", fontSize: 16)
    private let login = FormUI.createButton(title: "Login")
    private let username = FormUI.createTextfield(placeholder: "Username")
    private let password = FormUI.createTextfield(placeholder: "Password", isSecure: true)
    private let verifyPassword = FormUI.createTextfield(placeholder: "Verify Password", isSecure: true)
    private let nextButton = FormUI.createButton(title: "Next")
    private let form = FormUI.createVStack(spacing: 20)
    
    private let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        username.delegate = self
        password.delegate = self
        initializeForm()
        nextButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        login.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        textField.resignFirstResponder()
        return true
    }
    
    @objc func loginTapped(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "LoginViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func doneTapped(_ sender: Any) {
        if let username = username.text, let password = password.text, let verifyPassword = verifyPassword.text{
            if password == verifyPassword{
                let user = User()
                user.username = username
                user.password = password
                save(user: user)
                //save into keychain
                let userData = UserData(username: username, password: password)
                let account = "domain.com"
                let service = "token"
                KeychainHelper.standard.genericSave(userData, service: service, account: account)
                performSegue(withIdentifier: "signUpToMenu", sender: self)
            }
            
        }
    }
    
    func save(user:User){
        //save into database
        do {
            try realm.write{
                realm.add(user)
            }
        } catch {
            print("error saving user \(error)")
        }
    }
    
}

extension SignUpViewController{
    
    private func initializeForm(){
        //create blurEffectView
        let blurEffectView = FormUI.createBlurBackground(with: view)
        
        //add username field and location
        form.addArrangedSubview(username)
        FormUI.changeSize(view: username, sizeType: .height, size: 40)
        
        //add password field and location
        form.addArrangedSubview(password)
        FormUI.changeSize(view: password, sizeType: .height, size: 40)
        
        //add verifyPassword field and location
        form.addArrangedSubview(verifyPassword)
        FormUI.changeSize(view: verifyPassword, sizeType: .height, size: 40)
        
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
        blurEffectView.contentView.addSubview(login)
        FormUI.location(view: login, relative: orLabel, side: .top, margin: 20, isInside: false)
        FormUI.locateInCenter(view: login, relative: blurEffectView, direction: .horizontal)
        FormUI.changeSize(view: login, sizeType: .width, size: 150)
       // FormUI.changeSize(view: createAccountButton, sizeType: .height, size: 40)
    }
    
}

