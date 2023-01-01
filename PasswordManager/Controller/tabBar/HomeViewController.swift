//
//  HomeViewController.swift
//  PasswordManager
//
//  Created by Ravshanbek Tursunbaev on 2022/12/25.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    private let realm = try! Realm()
    private var passwords:Results<Password>?
    private var selectedPassword:Password?
    private var currentIndexPath:IndexPath?
    var notificationToken: NotificationToken?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableview.dataSource = self
        tableview.delegate = self
        
        tableview.register(UINib(nibName: "PasswordTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.Cells.paswordCustomCell)
        
        loadPasswords()
        watchChanges()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "Passwords"
    }
    
    func loadPasswords(){
        passwords = realm.objects(Password.self)
        tableview.reloadData()
    }
    
    func watchChanges(){
        // Retain notificationToken as long as you want to observe
        notificationToken = passwords!.observe { [self] (changes) in
            switch changes {
            case .initial: break
                // Results are now populated and can be accessed without blocking the UI
            case .update(_, _, _, _):
                // Query results have changed.
                tableview.reloadData()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
    }
}



extension HomeViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        passwords?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.paswordCustomCell, for: indexPath) as! PasswordTableViewCell
        let password = passwords![indexPath.row]
        cell.setData(data: password)
        return cell
    }
    
    
}

extension HomeViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPassword = passwords![indexPath.row]
        currentIndexPath = indexPath
        performSegue(withIdentifier: Constants.SeguesDirection.detail, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SeguesDirection.detail{
            let vc = segue.destination as! PasswordDetailsViewController
            vc.selectedPassword = self.selectedPassword
            vc.currentIndexPath = self.currentIndexPath
        }
    }
}
