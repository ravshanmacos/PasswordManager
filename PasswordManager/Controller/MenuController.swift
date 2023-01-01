//
//  MenuController.swift
//  PasswordManager
//
//  Created by Ravshanbek Tursunbaev on 2022/12/25.
//

import UIKit

class MenuController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func addTapped(_ sender: Any) {
        performSegue(withIdentifier: Constants.SeguesDirection.add, sender: self)
    }
    
}


