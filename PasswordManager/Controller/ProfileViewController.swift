//
//  ProfileViewController.swift
//  PasswordManager
//
//  Created by Ravshanbek Tursunbaev on 2022/12/25.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var userImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tabBarController?.navigationItem.title = "Profile"
        
        userImage.layer.cornerRadius = 20
    }
    
   
    @IBAction func logoutTapped(_ sender: Any) {
    }
    
}
