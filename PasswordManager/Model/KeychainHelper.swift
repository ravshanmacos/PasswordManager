//
//  KeychainHelper.swift
//  PasswordManager
//
//  Created by Ravshanbek Tursunbaev on 2023/01/08.
//

import Foundation

final class KeychainHelper{
    static let standard = KeychainHelper()
    private init(){}
    
    //MARK: - Save into Keychain
    
    func save(_ data:Data, service:String,account:String){
        
        // Create query
        let query = [
            kSecValueData:data, // A key that represents the data being saved to the keychain.
            kSecClass: kSecClassGenericPassword, // A key that represents the type of data being saved.
            kSecAttrService:service,//required service String
            kSecAttrAccount:account // required account String
           
        ] as CFDictionary
        
        // Add data in query to keychain
        let status = SecItemAdd(query, nil)
        
        if status == errSecSuccess{
            print("Successfully Saved")
        }else if status == errSecDuplicateItem{
            updateData(data, service, account)
        }else{
            // Print out the error
            print("Error: \(status)")
        }
        
    }
    
    //MARK: - Generic Save Method
    
    func genericSave<T>(_ item: T, service:String, account:String ) where T : Codable {
        do {
            // Encode as JSON data and save in keychain
           let data = try JSONEncoder().encode(item)
            save(data, service: service, account: account)
        } catch {
            assertionFailure("Fail to encode item for keychain: \(error)")
        }
    }
    
    
    
    //MARK: - Update data in Keychain
    private func updateData(_ data: Data,_ service:String,_ account:String){
        //item already exist, need to update it
        let query = [
            kSecAttrService:service,
            kSecAttrAccount:account,
            kSecClass:kSecClassGenericPassword
        ] as CFDictionary
        
        let attributesToUpdate = [kSecValueData:data] as CFDictionary
        
        //update the existing item
       let status = SecItemUpdate(query, attributesToUpdate)
        if status == errSecSuccess{
            print("item updated")
        }
    }
    
    func genericRead<T>( service:String, account:String, type: T.Type )-> T? where T : Codable {
        
        guard let data = read(service: service, account: account) else {
            return nil
        }
        
        do {
            // Encode as JSON data and save in keychain
            let item = try JSONDecoder().decode(type, from: data)
            return item
        } catch {
            assertionFailure("Fail to decode item for keychain: \(error)")
            return nil
        }
    }
    
    //MARK: - Read from Keychain
    
    func read(service: String, account: String) -> Data? {
        
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        return (result as? Data)
    }
    
    //MARK: - Delete item from Keychain
    
    func delete(service: String, account: String) {
        
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            ] as CFDictionary
        
        // Delete item from keychain
        let status = SecItemDelete(query)
        
        if status == errSecSuccess{
            print("successfully item has been deleted")
        }else{
            print("Error:\(status)")
        }
    }
}
