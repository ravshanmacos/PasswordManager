//
//  FormUI.swift
//  PasswordManager
//
//  Created by Ravshanbek Tursunbaev on 2023/01/08.
//

import UIKit

struct FormUI{

    static func createLabel(title:String, fontSize:CGFloat = 24)-> UILabel{
        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    static func createButton(title:String)->UIButton{
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.backgroundColor = .tintColor
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    static func createTextfield(placeholder:String, isSecure:Bool = false)->UITextField{
        let textfield = UITextField()
        textfield.placeholder = placeholder
        textfield.borderStyle = .roundedRect
        textfield.isSecureTextEntry = isSecure
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }
    
    static func createVStack(spacing:CGFloat)->UIStackView{
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = spacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
    
    static func createHStack(spacing:CGFloat)->UIStackView{
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = spacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
    
    static func location<T:UIView,N:UIView>(view:T, relative: N, side:Side, margin:Int, isInside:Bool){
        if isInside{
            switch side {
            case .top:
                view.topAnchor.constraint(equalTo: relative.topAnchor, constant: CGFloat(margin)).isActive = true
            case .bottom:
                view.bottomAnchor.constraint(equalTo: relative.bottomAnchor, constant: CGFloat(margin)).isActive = true
            case .left:
                view.leadingAnchor.constraint(equalTo: relative.leadingAnchor, constant: CGFloat(margin)).isActive = true
            case .right:
                view.trailingAnchor.constraint(equalTo: relative.trailingAnchor, constant: CGFloat(margin)).isActive = true
            }
        }else{
            switch side {
            case .top:
                view.topAnchor.constraint(equalTo: relative.bottomAnchor, constant: CGFloat(margin)).isActive = true
            case .bottom:
                view.bottomAnchor.constraint(equalTo: relative.topAnchor, constant: CGFloat(margin)).isActive = true
            case .left:
                view.leadingAnchor.constraint(equalTo: relative.trailingAnchor, constant: CGFloat(margin)).isActive = true
            case .right:
                view.trailingAnchor.constraint(equalTo: relative.leadingAnchor, constant: CGFloat(margin)).isActive = true
            }
        }
       
    }
    
    static func locateInCenter<T:UIView,N:UIView>(view:T, relative: N, direction:Direction){
        switch direction {
        case .horizontal:
            view.centerXAnchor.constraint(equalTo: relative.centerXAnchor).isActive = true
        case .vertical:
            view.centerYAnchor.constraint(equalTo: relative.centerYAnchor).isActive = true
        case .both:
            view.centerXAnchor.constraint(equalTo: relative.centerXAnchor).isActive = true
            view.centerYAnchor.constraint(equalTo: relative.centerYAnchor).isActive = true
        }
        
    }
    
    static func changeSize<T:UIView>(view:T, sizeType:Size, size: CGFloat){
        switch sizeType {
        case .width:
            view.widthAnchor.constraint(equalToConstant: size).isActive = true
        case .height:
            view.heightAnchor.constraint(equalToConstant: size).isActive = true
        }
    }
    
    
    //MARK: - Custom Blur Background
    
    static func createBlurBackground(with parentView:UIView, isAdded:Bool = true, blurStyle: UIBlurEffect.Style = .light)->UIVisualEffectView{
        //creating blur effect
        let blurEffect = UIBlurEffect(style: blurStyle)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = parentView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        //animation
        blurEffectView.alpha = 0
        UIVisualEffectView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
            blurEffectView.alpha = 1
        }completion: { _ in
            if isAdded{
                parentView.addSubview(blurEffectView)
            }
           
        }
        
        return blurEffectView
    }
    
    
}

enum Side{
    case top
    case bottom
    case left
    case right
}

enum Direction{
    case horizontal
    case vertical
    case both
}

enum Size{
    case width
    case height
}
