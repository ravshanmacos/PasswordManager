//
//  MenuController.swift
//  PasswordManager
//
//  Created by Ravshanbek Tursunbaev on 2022/12/25.
//

import UIKit
import RealmSwift

class MenuController: UITabBarController {
    let realm = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func profileTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "ProfileViewController")
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func addTapped(_ sender: Any) {
        performSegue(withIdentifier: Constants.SeguesDirection.add, sender: self)
    }
    
}
