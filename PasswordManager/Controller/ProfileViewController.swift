//
//  ProfileViewController.swift
//  PasswordManager
//
//  Created by Ravshanbek Tursunbaev on 2022/12/25.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var tableviewStack: UIStackView!
    @IBOutlet weak var userImageContainer: UIImageView!
    
    private let tableview = UITableView()
    private let titles = ["Switch account","Security","Trusted devices", "Backup"]
    private let reuseIdentifier = "customCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        userImageContainer.layer.cornerRadius = 5
        initTableview()
        self.tabBarController?.navigationItem.title = "Profile"
        userImage.layer.cornerRadius = 20
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Profile"
        navigationItem.backButtonTitle = "Back"
    }
    
   
    @IBAction func logoutTapped(_ sender: Any) {
        let account = "domain.com"
        let service = "token"
        KeychainHelper.standard.delete(service: service, account:account)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "LoginViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func initTableview(){
        tableview.delegate = self
        tableview.dataSource = self
        tableview.backgroundColor = .clear
        tableview.separatorStyle = .none
        tableview.rowHeight = 50
        tableview.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableviewStack.addArrangedSubview(tableview)
    }
    
}

extension ProfileViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CustomCell
        cell.title.text = titles[indexPath.row]
        return cell
    }
    
    
}
