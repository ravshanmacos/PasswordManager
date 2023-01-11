//
//  User.swift
//  PasswordManager
//
//  Created by Ravshanbek Tursunbaev on 2023/01/08.
//

import Foundation
import RealmSwift

final class User:Object, ObjectKeyIdentifiable{
    @Persisted(primaryKey: true) var _id:ObjectId
    @Persisted var username:String = ""
    @Persisted var password:String = ""
    @Persisted var passwords = RealmSwift.List<Password>()
}
