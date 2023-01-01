//
//  CreatePasswordViewController.swift
//  PasswordManager
//
//  Created by Ravshanbek Tursunbaev on 2022/12/25.
//

import UIKit
import RealmSwift

class CreatePasswordViewController: UIViewController {
    
    @IBOutlet weak var formStack: UIStackView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var userIDField: UITextField!
    @IBOutlet weak var generatedPasswordLabel: UIButton!
    @IBOutlet weak var lengthSlider: UISlider!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var numbersIncluded: UISwitch!
    @IBOutlet weak var symbolsIncluded: UISwitch!
    private var passwordManually = UITextField()
    
    private let realm = try! Realm()
    private var numbers:Bool{
        return !numbersIncluded.isOn
    }
    private var symbols:Bool{
        return !symbolsIncluded.isOn
    }
    
    private var isManually = false
    private var sliderValue = "16"
    var delegate:PasswordDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        userIDField.delegate = self
        loadGeneratedApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "New Record"
    }
    
    @IBAction func lengthSliderDidChange(_ sender: UISlider) {
        let value = String(Int(sender.value))
        lengthLabel.text = value
    }
    
    
    @IBAction func regenerateTapped(_ sender: Any) {
        loadGeneratedApi()
    }
    
  
    @IBAction func manuallyTapped(_ sender: Any) {
        isManually = true
        let passwordLabel = UILabel()
        passwordLabel.text = "Password"
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        passwordManually.isSecureTextEntry = true
        passwordManually.placeholder = "password"
        passwordManually.borderStyle = .roundedRect
        
        
        let passwordField = UIStackView()
        passwordField.axis = .horizontal
        passwordField.spacing = 15
        
        passwordField.addArrangedSubview(passwordLabel)
        passwordField.addArrangedSubview(passwordManually)
        passwordField.alpha = 0
        UIStackView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: { [self] in
            passwordField.alpha = 1
            formStack.addArrangedSubview(passwordField)
        }, completion: nil)
        
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        if let brand = nameField.text, let userID = userIDField.text{
            let password = Password()
            if isManually{
                let passwordValidator = PasswordValidator(password: passwordManually.text!).getPasswordCategory()
                password.name = brand
                password.userID = userID
                password.password = passwordManually.text!
                password.validityType = passwordValidator.type
                password.validityValue = passwordValidator.value
            }else{
                let passwordValidator = PasswordValidator(password: (generatedPasswordLabel.titleLabel?.text)!).getPasswordCategory()
                password.name = brand
                password.userID = userID
                password.password = (generatedPasswordLabel.titleLabel?.text)!
                password.validityType = passwordValidator.type
                password.validityValue = passwordValidator.value
                
            }
           save(password: password)
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    private func loadGeneratedApi(){
        let urlString = "https://api.api-ninjas.com/v1/passwordgenerator?"
        sliderValue = String(Int(lengthSlider.value)).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
       
        let length = "length=\(sliderValue)"
        let exclude_numbers = "&exclude_numbers=\(numbers)"
        let exclude_special_chars = "&exclude_special_chars=\(symbols)"
        let url = URL(string: urlString+length+exclude_numbers+exclude_special_chars)!
        var request = URLRequest(url: url)
        request.setValue(API.passwordGenerator, forHTTPHeaderField: "X-Api-Key")
        let task = URLSession.shared.dataTask(with: request) { [self](data, response, error) in
            guard let data = data else { return }
           let result = decodeJSON(data: data)
          // let text = String(data: data, encoding: .utf8)!
            DispatchQueue.main.async {
                self.generatedPasswordLabel.setTitle(result.random_password, for: .normal)
            }
        }
        task.resume()
    }
    
    private func decodeJSON(data:Data)->GeneratedPassword{
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(GeneratedPassword.self, from: data)
            return result
        } catch {
            fatalError("error while decoding\(error)")
        }
    }
    
    private func save(password:Password){
        do {
            try realm.write{
                realm.add(password)
            }
        } catch {
            print("Error saving category \(error)")
        }
    }
    
    
}

extension CreatePasswordViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(true)
        nameField.text = nameField.text?.capitalized
    }
}

