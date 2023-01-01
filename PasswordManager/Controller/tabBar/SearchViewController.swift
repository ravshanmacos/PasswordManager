//
//  SearchViewController.swift
//  PasswordManager
//
//  Created by Ravshanbek Tursunbaev on 2022/12/25.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchView: UISearchBar!
    @IBOutlet weak var tableview: UITableView!
    private let reuseIdentifier = "searchResultCell"
    private var searchResults: Results<Password>?
    var notificationToken: NotificationToken?
    let realm = try! Realm()
    private var selectedPassword:Password?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableview.delegate = self
        tableview.dataSource = self
        searchView.delegate = self
        tableview.register(UINib(nibName: "PasswordTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.Cells.paswordCustomCell)
        searchView.becomeFirstResponder()
        loadData()
        watchChanges()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "Search"
    }
    
    
    
    private func loadData(){
        searchResults = realm.objects(Password.self)
        tableview.reloadData()
    }
    
    func watchChanges(){
        // Retain notificationToken as long as you want to observe
        notificationToken = searchResults!.observe { [self] (changes) in
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

extension SearchViewController: UISearchBarDelegate{
    
    
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //print(searchBar.text)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      //  print(searchBar.text)
        if searchBar.text == ""{
            searchResults = realm.objects(Password.self)
        }else{
            searchResults = searchResults?.where({ query in
                query.name.contains(searchBar.text!)
            })
        }
        tableview.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SeguesDirection.searchToDetail{
            let vc = segue.destination as! PasswordDetailsViewController
            vc.selectedPassword = self.selectedPassword
        }
    }
    
}


extension SearchViewController: UITableViewDelegate{
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPassword = searchResults![indexPath.row]
        tableview.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: Constants.SeguesDirection.searchToDetail, sender: self)
    }
}

extension SearchViewController: UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResults!.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.paswordCustomCell, for: indexPath) as! PasswordTableViewCell
        
        let password = searchResults![indexPath.row]
        cell.setData(data: password)
        return cell
    }
    
    
}

