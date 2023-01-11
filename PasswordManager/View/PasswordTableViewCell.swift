//
//  PasswordTableViewCell.swift
//  PasswordManager
//
//  Created by Ravshanbek Tursunbaev on 2022/12/26.
//

import UIKit

class PasswordTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    
    let brandName = FormUI.createLabel(title: "Apple", fontSize: 20)
    let userID = FormUI.createLabel(title: "ravshan@mail.ru", fontSize: 14)
    let vStack = FormUI.createVStack(spacing: 5)
    var ImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "adobe"))
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
   
    var password:String = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        userID.textColor = UIColor.lightGray
        
        // Initialization code
        mainView.layer.cornerRadius = 10
       let blurEffectView = createBlurBackground()
        vStack.addArrangedSubview(brandName)
        vStack.addArrangedSubview(userID)
        blurEffectView.contentView.addSubview(ImageView)
        blurEffectView.contentView.addSubview(vStack)
        mainView.addSubview(blurEffectView)
         //Position ImageView
        FormUI.changeSize(view: ImageView, sizeType: .width, size: 30)
        FormUI.changeSize(view: ImageView, sizeType: .height, size: 30)
        FormUI.locateInCenter(view: ImageView, relative: mainView, direction: .vertical)
        FormUI.location(view: ImageView, relative: mainView, side: .right, margin: -20, isInside: true)
        //Positioning Stack viw
        FormUI.locateInCenter(view: vStack, relative: blurEffectView, direction: .vertical)
        FormUI.location(view: vStack, relative: blurEffectView, side: .left, margin: 20, isInside: true)
        
    }
    
    func createBlurBackground()->UIVisualEffectView{
        //creating blur effect
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = mainView.bounds
        blurEffectView.layer.cornerRadius = 10
        blurEffectView.clipsToBounds = true
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data:Password){
        self.brandName.text = data.name
        self.userID.text = data.userID
       // self.password = data.password
    }
    
  
//    func copyTapped(_ sender: Any) {
//        UIPasteboard.general.string = password
//        animateBtnWhileCopying()
//    }
    /*
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
     */
    
    
    
}


