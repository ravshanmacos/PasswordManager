//
//  AnalysisTableViewCell.swift
//  PasswordManager
//
//  Created by Ravshanbek Tursunbaev on 2022/12/27.
//

import UIKit

class AnalysisTableViewCell: UITableViewCell {
   
    @IBOutlet weak var brandName: UILabel!
    @IBOutlet weak var userID: UILabel!
    @IBOutlet weak var validationType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
      //  contentView.backgroundColor = UIColor.systemGray
    }
    
    func setData(password:Password){
        brandName.text = password.name
        userID.text = password.userID
        validationType.text = password.validityType
        if password.validityType == "strong"{
            validationType.textColor = UIColor.systemGreen
        }else if password.validityType == "weak"{
            validationType.textColor = UIColor.systemYellow
        }else{
            validationType.textColor = UIColor.red
        }
        validationType.text = password.validityType
    }
    
}
