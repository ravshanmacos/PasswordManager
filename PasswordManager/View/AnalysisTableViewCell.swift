//
//  AnalysisTableViewCell.swift
//  PasswordManager
//
//  Created by Ravshanbek Tursunbaev on 2022/12/27.
//

import UIKit

class AnalysisTableViewCell: UITableViewCell {
   
    @IBOutlet weak var mainView: UIView!
    
    let brandName = FormUI.createLabel(title: "Apple", fontSize: 16)
    let userID = FormUI.createLabel(title: "ravshan@mail.ru", fontSize: 12)
    let validationType = FormUI.createLabel(title: "", fontSize: 14)
    let vStack = FormUI.createVStack(spacing: 2)
    var ImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "adobe"))
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userID.textColor = UIColor.lightGray
        // Initialization code
        mainView.layer.cornerRadius = 10
        let blurEffectView = FormUI.createBlurBackground(with: mainView, isAdded: false, blurStyle: .light)
        blurEffectView.layer.cornerRadius = 10
        blurEffectView.clipsToBounds = true
        vStack.addArrangedSubview(brandName)
        vStack.addArrangedSubview(userID)
        blurEffectView.contentView.addSubview(validationType)
        blurEffectView.contentView.addSubview(ImageView)
        blurEffectView.contentView.addSubview(vStack)
        mainView.addSubview(blurEffectView)
        //position validation type
        FormUI.locateInCenter(view: validationType, relative: blurEffectView, direction: .vertical)
        FormUI.locateInCenter(view: validationType, relative: blurEffectView, direction: .horizontal)
        
         //Position ImageView
        FormUI.changeSize(view: ImageView, sizeType: .width, size: 30)
        FormUI.changeSize(view: ImageView, sizeType: .height, size: 30)
        FormUI.locateInCenter(view: ImageView, relative: mainView, direction: .vertical)
        FormUI.location(view: ImageView, relative: mainView, side: .right, margin: -20, isInside: true)
        //Positioning Stack viw
        FormUI.locateInCenter(view: vStack, relative: blurEffectView, direction: .vertical)
        FormUI.location(view: vStack, relative: blurEffectView, side: .left, margin: 20, isInside: true)
        
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
            validationType.textColor = UIColor(named: "darkGreen")
        }else if password.validityType == "weak"{
            validationType.textColor = UIColor(named: "darkBlue")
        }else{
            validationType.textColor = UIColor(named: "darkRed")
        }
        validationType.text = password.validityType
    }
    
}
