//
//  PasswordValidator.swift
//  PasswordManager
//
//  Created by Ravshanbek Tursunbaev on 2022/12/27.
//

import Foundation

class PasswordValidator {
    
    var password:String
    
    init(password: String) {
        self.password = password
    }
    
    private var strong = false
    private var weak = false
    private var risk = false
    
    private let alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    private var isInt = 0
    private var isSpecialChar = 0
    private var isChar = 0
    
    private var tooShort: Bool{
        return password.count < 6
    }
    
    private var mediumLength:Bool{
        return password.count > 6 && password.count < 12
    }
    
    private var longLength:Bool{
        return password.count >= 12
    }
    
    private var noDigit:Bool = true
    private var noSpecialChar:Bool = true
    private var noChar:Bool = true
    
    //checking password
    private func checkPassword(){
        let arrayOfString = password.split(separator: "")
        
        for char in arrayOfString{
            if let _ = Int(char){
                isInt += 1
                noDigit = false
            }
            if let _ =  char.range(of: ".*[^A-Za-z0-9].*", options: .regularExpression){
                isSpecialChar += 1
                noSpecialChar = false
            }
            if alphabet.contains(char){
                isChar += 1
                noChar = false
            }
        }
    }
    
    //getting password type
    func getPasswordCategory()->(type:String, value:Bool){
        checkPassword()
        //contions
        let strongCondition = isInt > 0 && isSpecialChar > 0 && isChar > 0
        let mediumContion1 = (isInt > 0 && isChar > 0 && noSpecialChar) || (isInt > 0 && isSpecialChar > 0 && noChar) || (isSpecialChar > 0 && isChar > 0 && noDigit)
        let mediumContion2 = (isInt > 0 && noChar && noSpecialChar) || (isSpecialChar > 0 && noDigit && noChar) || (isChar > 0 && noSpecialChar && noDigit)
        
        if (longLength || mediumLength) && strongCondition{
                strong = true
                return (type:"strong", value:strong)
        }else if (mediumLength || longLength) && (mediumContion1 || mediumContion2){
                weak = true
                return (type:"weak", value:weak)
        }
        risk = true
        return (type:"risk", value:risk)
    }
    
}
