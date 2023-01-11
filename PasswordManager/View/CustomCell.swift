//
//  SettingsCell.swift
//  PasswordManager
//
//  Created by Ravshanbek Tursunbaev on 2023/01/10.
//

import UIKit

class CustomCell: UITableViewCell {
    
    let title = FormUI.createLabel(title: "", fontSize: 18)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let blurEffectView = FormUI.createBlurBackground(with: self.contentView, isAdded: false)
        blurEffectView.contentView.addSubview(title)
        contentView.addSubview(blurEffectView)
        FormUI.locateInCenter(view: title, relative: blurEffectView, direction: .vertical)
        FormUI.location(view: title, relative: blurEffectView, side: .left, margin: 20, isInside: true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTitle(text:String){
        title.text = text
    }
    
}
