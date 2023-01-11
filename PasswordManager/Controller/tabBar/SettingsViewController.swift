//
//  SettingsViewController.swift
//  PasswordManager
//
//  Created by Ravshanbek Tursunbaev on 2022/12/25.
//

import UIKit

class SettingsViewController: UIViewController{
    @IBOutlet weak var tableViewStack: UIStackView!
  
    private let titles = ["Profiles", "Auto fill", "Help", "About"]
    private let reuseIdentifier = "customCell"
    private let tableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 50
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableViewStack.addArrangedSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "Settings"
    }
    

}

extension SettingsViewController:  UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for:indexPath) as! CustomCell
        cell.setTitle(text: titles[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if titles[indexPath.row] == "Profiles"{
            performSegue(withIdentifier: "settingsToProfile", sender: self)
        }
    }
    
}

//        createCell(blurEffectView: blurEffectView)
//
//        FormUI.location(view: vstack, relative: blurEffectView, side: .top, margin: 150, isInside: true)
//        FormUI.location(view: vstack, relative: blurEffectView, side: .left, margin: 0, isInside: true)
//        FormUI.location(view: vstack, relative: blurEffectView, side: .right, margin: 0, isInside: true)
//        locateCell()
//        formatImageView()




//    private func createCell(blurEffectView:UIVisualEffectView){
//
//        //creating components
//        let label = FormUI.createLabel(title: "Profile",fontSize: 18)
//        let hstack = FormUI.createHStack(spacing: 10)
//        let imageViewContainer = UIView()
//        let imageView = UIImageView(image: UIImage.init(systemName: "chevron.right"))
//
//        //adding
//        hstack.backgroundColor = UIColor(named: "blue")
//        imageViewContainer.addSubview(imageView)
//        hstack.addArrangedSubview(label)
//        hstack.addArrangedSubview(imageViewContainer)
//        vstack.addArrangedSubview(hstack)
//        blurEffectView.contentView.addSubview(vstack)
//    }
    
//    func formatImageView(){
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        FormUI.changeSize(view: imageView, sizeType: .width, size: 20)
//        FormUI.changeSize(view: imageView, sizeType: .height, size: 20)
//        FormUI.locateInCenter(view: imageView, relative: imageViewContainer, direction: .vertical)
//        FormUI.location(view: imageView, relative: imageViewContainer, side: .right, margin: 0, isInside: true)
//    }
    
//    func locateCell(){
//        vstack.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
//        vstack.isLayoutMarginsRelativeArrangement = true
//        hstack.layoutMargins = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
//        hstack.isLayoutMarginsRelativeArrangement = true
//        hstack.layer.cornerRadius = 10
//        FormUI.changeSize(view: hstack, sizeType: .height, size: 40)
//    }
