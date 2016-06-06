//
//  SecureStore.swift
//  Cribber
//
//  Created by Tim Ross on 19/04/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import Foundation
import Locksmith

class SecureStore {
    
    private let userAccount = "Cribber"
    
    func valueForKey(key: String) -> String? {
        var data = loadData()
        return data[key]
    }
    
    func setValue(value: String, forKey key: String) -> Bool {
        var data = loadData()
        data[key] = value
        return saveData(data)
    }
    
    func deleteData() -> Bool {
        do {
            try Locksmith.deleteDataForUserAccount(userAccount)
        } catch let error as NSError {
            Log.Error("Deleting secure data", error: error)
            return false
        }
        return true
    }
    
    private func loadData() -> [String: String] {
        let dictionary = Locksmith.loadDataForUserAccount(userAccount)
        if dictionary != nil {
            return dictionary as! [String: String]
        }
        return [String: String]()
    }
    
    private func saveData(data: [String: String]) -> Bool {
        do {
            try Locksmith.updateData(data, forUserAccount: userAccount)
        } catch let error as NSError {
            Log.Error("Saving secure data", error: error)
            return false
        }
        return true
    }
}
