//
//  ViewController.swift
//  PasswordManager
//
//  Created by Ravshanbek Tursunbaev on 2022/12/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let account = "domain.com"
        let service = "token"
        KeychainHelper.standard.delete(service: service, account:account )
    }

    deinit {
        print("deinit")
    }
}

