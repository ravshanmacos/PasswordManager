//
//  AnalysisViewController.swift
//  PasswordManager
//
//  Created by Ravshanbek Tursunbaev on 2022/12/25.
//

import UIKit
import RealmSwift

class AnalysisViewController: UIViewController {

  
    @IBOutlet weak var circularViewContainer: UIView!
    @IBOutlet weak var safeSquare: UIView!
    @IBOutlet weak var wreckSquare: UIView!
    @IBOutlet weak var riskSquare: UIView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var filterButton: UIButton!
    private let animatedCountingLabel = FormUI.createLabel(title: "", fontSize: 14)
    private let safeCounterLabel = FormUI.createLabel(title: "", fontSize: 16)
    private let safeTitle = FormUI.createLabel(title: "safe", fontSize: 14)
    private let weakCounterLabel = FormUI.createLabel(title: "", fontSize: 16)
    private let weakTitle = FormUI.createLabel(title: "weak", fontSize: 14)
    private let riskCounterLabel = FormUI.createLabel(title: "", fontSize: 16)
    private let riskTitle = FormUI.createLabel(title: "risk", fontSize: 14)
    
    private let realm = try! Realm()
    private var passwords: [Password] = []
    var notificationToken: NotificationToken?
    private var percentage:Float?
    private var selectedPassword:Password?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.dataSource = self
        tableview.delegate = self
        
        tableview.register(UINib(nibName: "AnalysisTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.Cells.analysisCustomCell)
        
        initUI()
        loadPasswords()
        watchChanges()
        initCircularProgress()
        setupPopUpButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "Analysis"
    }
    
    private func initUI(){
        safeTitle.textColor = UIColor(named: "darkGreen")
        weakTitle.textColor = UIColor(named:"darkBlue")
        riskTitle.textColor = UIColor(named: "darkRed")
        initSquares(square: safeSquare, counter: safeCounterLabel, title: safeTitle)
        initSquares(square: wreckSquare, counter: weakCounterLabel, title: weakTitle)
        initSquares(square: riskSquare, counter: riskCounterLabel, title: riskTitle)
    }
    
    private func initCircularProgress(){
        let progressView = CircularProgressView(frame: CGRect(x: 0, y: 0, width: 90, height: 90), lineWidth: 5, rounded: false)
        progressView.progressColor = UIColor(named: "darkBlue")!
        progressView.trackColor = .lightGray
        progressView.center = CGPoint(x: circularViewContainer.frame.width/2, y: circularViewContainer.frame.height/2)
        let blurEffectView = FormUI.createBlurBackground(with: circularViewContainer,isAdded: false,blurStyle: .light)
        blurEffectView.layer.cornerRadius = 20
        blurEffectView.clipsToBounds = true
        blurEffectView.contentView.addSubview(progressView)
        blurEffectView.contentView.addSubview(animatedCountingLabel)
        circularViewContainer.addSubview(blurEffectView)
        FormUI.locateInCenter(view: animatedCountingLabel, relative: blurEffectView, direction: .horizontal)
        FormUI.locateInCenter(view: animatedCountingLabel, relative: blurEffectView, direction: .vertical)
        progressView.progress = percentage! / 100
        incrementLabel(to: Int(percentage!))
    }
    
    private func incrementLabel(to endValue: Int) {
        let duration: Double = Double((3.43*(percentage!/100))) //seconds
        DispatchQueue.global().async {
            for i in 0 ..< (endValue + 1) {
                let sleepTime = UInt32(duration/Double(endValue) * 1000000.0)
                usleep(sleepTime)
                DispatchQueue.main.async {
                    self.animatedCountingLabel.text = "\(i) %"
                }
            }
        }
    }
    
    private func initSquares(square:UIView, counter:UILabel, title:UILabel){
        let vstack = FormUI.createVStack(spacing: 5)
        counter.textAlignment = .center
        title.textAlignment = .center
        let blurEffectView = FormUI.createBlurBackground(with: square,isAdded: false)
        square.layer.cornerRadius = 20
        blurEffectView.layer.cornerRadius = 20
        blurEffectView.clipsToBounds = true
        vstack.addArrangedSubview(counter)
        vstack.addArrangedSubview(title)
        blurEffectView.contentView.addSubview(vstack)
        square.addSubview(blurEffectView)
        FormUI.locateInCenter(view: vstack, relative: blurEffectView, direction: .horizontal)
        FormUI.locateInCenter(view: vstack, relative: blurEffectView, direction: .vertical)
    }
    
    func setupPopUpButton() {
        let users = realm.objects(User.self)
        var data:[Password] = []
        let account = "domain.com"
        let service = "token"
        let result = KeychainHelper.standard.genericRead(service: service, account: account, type: UserData.self)
        for user in users{
            if user.username == result?.username{
                data = Array(user.passwords)
            }
        }
        let popUpButtonClosure = { [self] (action: UIAction) in
            if action.title == "Strong"{
                passwords = data.filter({ password in
                    password.validityType == "strong"
                })
            }else if action.title == "Weak"{
           
                passwords = data.filter({ password in
                    password.validityType == "weak"
                })
            } else if action.title == "Risk"{
              
                passwords = data.filter({ password in
                    password.validityType == "risk"
                })
            }else{
               passwords = data
            }
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
        }
                
        filterButton.menu = UIMenu(children: [
            UIAction(title: "All", handler: popUpButtonClosure),
            UIAction(title: "Strong", handler: popUpButtonClosure),
            UIAction(title: "Weak", handler: popUpButtonClosure),
            UIAction(title: "Risk", handler: popUpButtonClosure)
        ])
        filterButton.showsMenuAsPrimaryAction = true
    }
    
   
  //  line.3.horizontal.decrease
    func loadPasswords(){
        let users = realm.objects(User.self)
        let account = "domain.com"
        let service = "token"
        let result = KeychainHelper.standard.genericRead(service: service, account: account, type: UserData.self)
        for user in users{
            if user.username == result?.username{
                passwords = Array(user.passwords)
            }
        }
        tableview.reloadData()
        var strongPasswords:Float = 0
        var weakPasswords:Float = 0
        var riskPasswords:Float = 0
        
        for password in passwords{
            
            if password.validityType == "strong"{
                strongPasswords += 1
            }else if password.validityType == "weak"{
                weakPasswords += 1
            }else{
                riskPasswords += 1
            }
        }
        
        
        
        let strongPasswordsInProcent = Int(strongPasswords / Float(passwords.count) * 100)
        let weakPasswordsInProcent = Int(weakPasswords / Float(passwords.count) * 100)
        let riskPasswordsInProcent = Int(riskPasswords / Float(passwords.count) * 100)
        
        percentage = Float(strongPasswordsInProcent)
        
        safeCounterLabel.text = String(strongPasswordsInProcent)
        weakCounterLabel.text = String(weakPasswordsInProcent)
        riskCounterLabel.text = String(riskPasswordsInProcent)
        
    }
    
    func watchChanges(){
        let users = realm.objects(User.self)
        let account = "domain.com"
        let service = "token"
        let result = KeychainHelper.standard.genericRead(service: service, account: account, type: UserData.self)
       let user = users.where { query in
           query.username == result!.username
        }
        // Retain notificationToken as long as you want to observe
        notificationToken = user.observe { [self] (changes) in
            switch changes {
            case .initial: break
                // Results are now populated and can be accessed without blocking the UI
            case .update(_, _, _, _):
                // Query results have changed.
                loadPasswords()
                tableview.reloadData()
                initCircularProgress()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
    }
    
    
    
}

extension AnalysisViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passwords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.analysisCustomCell, for: indexPath)
        as! AnalysisTableViewCell
        
        let password = passwords[indexPath.row]
        cell.setData(password: password)
        cell.selectionStyle = .none
        
        return cell
    }
    
    
}


extension AnalysisViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPassword = passwords[indexPath.row]
        tableview.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: Constants.SeguesDirection.analysisToDetail, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SeguesDirection.analysisToDetail{
            let vc = segue.destination as! PasswordDetailsViewController
            vc.selectedPassword = self.selectedPassword
        }
    }
}
