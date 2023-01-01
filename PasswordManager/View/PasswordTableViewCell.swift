//
//  PasswordTableViewCell.swift
//  PasswordManager
//
//  Created by Ravshanbek Tursunbaev on 2022/12/26.
//

import UIKit

class PasswordTableViewCell: UITableViewCell {
    @IBOutlet weak var brandname: UILabel!
    @IBOutlet weak var userID: UILabel!
    @IBOutlet weak var copyButton: UIButton!
   
    var password:String = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data:Password){
        self.brandname.text = data.name
        self.userID.text = data.userID
        self.password = data.password
    }
    
  
    @IBAction func copyTapped(_ sender: Any) {
        UIPasteboard.general.string = password
        animateBtnWhileCopying()
    }
    
    private func animateBtnWhileCopying(){
        UIButton.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) { [self] in
            copyButton.setImage(.checkmark, for: .normal)
            copyButton.tintColor = .tintColor
            copyButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            
        } completion: { _ in
            UIButton.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) { [self] in
                copyButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            }completion: { [self] _ in
                copyButton.setImage(UIImage(systemName: "square.on.square.fill"), for: .normal)
                copyButton.tintColor = UIColor.lightGray
            }
        }
    }
    
    
}


