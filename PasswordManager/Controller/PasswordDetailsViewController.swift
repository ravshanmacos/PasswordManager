//
//  PasswordDetailsViewController.swift
//  PasswordManager
//
//  Created by Ravshanbek Tursunbaev on 2022/12/25.
//

import UIKit
import RealmSwift

class PasswordDetailsViewController: UIViewController {
    @IBOutlet weak var brandName: UILabel!
    @IBOutlet weak var userID: UILabel!
    @IBOutlet weak var userIDField: UILabel!
    @IBOutlet weak var password: UILabel!
    @IBOutlet weak var autofill: UISwitch!
    @IBOutlet weak var controlStack: UIStackView!
    private let realm = try! Realm()
    private let changePasswordStack = UIStackView()
    private let passwordField = UITextField()
    private let doneButton = UIButton()
    var selectedPassword:Password?
    var currentIndexPath:IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        brandName.text = selectedPassword?.name
        userID.text = selectedPassword?.userID
        userIDField.text = selectedPassword?.userID
        password.text = selectedPassword?.password
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Password Details"
        navigationItem.backButtonTitle = "Back"
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        //let datas = realm.objects(Password.self)
       // let data = datas[currentIndexPath!.row]
        
        
            try! realm.write{
                realm.delete(selectedPassword!)
            }
            navigationController?.popViewController(animated: true)
  
    }
    
    @IBAction func copyPassword(_ sender: Any) {
        UIPasteboard.general.string = selectedPassword?.password
    }
    
    @IBAction func changePassword(_ sender: Any) {
        updatePassword()
    }
    
    private func updatePassword(){
        changePasswordStack.axis = .horizontal
        changePasswordStack.spacing = 20
        passwordField.placeholder = "password"
        passwordField.borderStyle = .roundedRect
        doneButton.setTitle("Done", for: .normal)
        doneButton.configuration = .filled()
        doneButton.addTarget(self, action: #selector(updateTextfield), for: .touchUpInside)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
      
        doneButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        changePasswordStack.addArrangedSubview(passwordField)
        changePasswordStack.addArrangedSubview(doneButton)
        controlStack.addArrangedSubview(changePasswordStack)
        
        changePasswordStack.alpha = 0
        UIStackView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: { [self] in
            changePasswordStack.alpha = 1
        }) { [self] _ in
            self.controlStack.addArrangedSubview(changePasswordStack)
        }
    }
    
    @objc private func updateTextfield(){
        let datas = realm.objects(Password.self)
        let data = datas[currentIndexPath!.row]
        password.text = passwordField.text
        do {
            try realm.write{
                data.password = passwordField.text!
            }
        } catch {
            fatalError("error updating \(error)")
        }
        
        UIStackView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: { [self] in
            changePasswordStack.alpha = 0
        }) { [self] _ in
            changePasswordStack.removeFromSuperview()
        }
    }
    
}
