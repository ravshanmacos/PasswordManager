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
    @IBOutlet weak var animatedCountingLabel: UILabel!
    @IBOutlet weak var safeSquare: UIView!
    @IBOutlet weak var wreckSquare: UIView!
    @IBOutlet weak var riskSquare: UIView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var safeSquareLabel: UILabel!
    @IBOutlet weak var wreckSquareLabel: UILabel!
    @IBOutlet weak var riskSquareLabel: UILabel!
    @IBOutlet weak var filterButton: UIButton!
    
    
    private let realm = try! Realm()
    private var passwords: Results<Password>?
    var notificationToken: NotificationToken?
    private var percentage:Float?
    private var selectedPassword:Password?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableview.dataSource = self
        tableview.delegate = self
        
        tableview.register(UINib(nibName: "AnalysisTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.Cells.analysisCustomCell)
        
        initSquares(square: safeSquare, borderColor: UIColor.systemBlue.cgColor)
        initSquares(square: wreckSquare, borderColor: UIColor.systemYellow.cgColor)
        initSquares(square: riskSquare, borderColor: UIColor.systemRed.cgColor)
        loadPasswords()
        watchChanges()
        initCircularProgress()
        setupPopUpButton()
    }
    
    private func initCircularProgress(){
        let progressView = CircularProgressView(frame: CGRect(x: 0, y: 0, width: 90, height: 90), lineWidth: 5, rounded: false)
        progressView.progressColor = .systemBlue
        progressView.trackColor = .lightGray
        progressView.center = CGPoint(x: circularViewContainer.frame.width/2, y: circularViewContainer.frame.height/2)
        circularViewContainer.addSubview(progressView)
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
    
    private func initSquares(square:UIView, borderColor:CGColor){
        square.layer.borderWidth = 2
        square.layer.borderColor = borderColor
        square.layer.cornerRadius = 20
    }
    
    func setupPopUpButton() {
        let data = realm.objects(Password.self)
        let popUpButtonClosure = { [self] (action: UIAction) in
            
            if action.title == "Strong"{
                passwords = data.where({ queryPassword in
                    queryPassword.validityType == "strong"
                })
            }else if action.title == "Weak"{
                passwords = data.where({ queryPassword in
                    queryPassword.validityType == "weak"
                })
            } else if action.title == "Risk"{
                passwords = data.where({ queryPassword in
                    queryPassword.validityType == "risk"
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
        passwords = realm.objects(Password.self)
        tableview.reloadData()
        var strongPasswords:Float = 0
        var weakPasswords:Float = 0
        var riskPasswords:Float = 0
        
        for password in passwords!{
            
            if password.validityType == "strong"{
                strongPasswords += 1
            }else if password.validityType == "weak"{
                weakPasswords += 1
            }else{
                riskPasswords += 1
            }
        }
        
        
        
        let strongPasswordsInProcent = Int(strongPasswords / Float(passwords!.count) * 100)
        let weakPasswordsInProcent = Int(weakPasswords / Float(passwords!.count) * 100)
        let riskPasswordsInProcent = Int(riskPasswords / Float(passwords!.count) * 100)
        
        percentage = Float(strongPasswordsInProcent)
        
        safeSquareLabel.text = String(strongPasswordsInProcent)
        wreckSquareLabel.text = String(weakPasswordsInProcent)
        riskSquareLabel.text = String(riskPasswordsInProcent)
        
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

extension AnalysisViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passwords?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.analysisCustomCell, for: indexPath)
        as! AnalysisTableViewCell
        
        let password = passwords![indexPath.row]
        cell.setData(password: password)
        cell.selectionStyle = .none
        
        return cell
    }
    
    
}


extension AnalysisViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPassword = passwords![indexPath.row]
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
