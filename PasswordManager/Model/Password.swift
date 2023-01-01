//
//  Data.swift
//  PasswordManager
//
//  Created by Ravshanbek Tursunbaev on 2022/12/26.
//

import Foundation
import RealmSwift

final class Password:Object, ObjectKeyIdentifiable{
    @Persisted(primaryKey: true) var _id:ObjectId
    @Persisted var name:String = ""
    @Persisted var userID:String = ""
    @Persisted var password:String = ""
    @Persisted var validityType:String = "weak"
    @Persisted var validityValue:Bool = true
}
