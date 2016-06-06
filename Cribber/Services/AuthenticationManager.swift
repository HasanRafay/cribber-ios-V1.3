//
//  AuthenticationManager.swift
//  Cribber
//
//  Created by Tim Ross on 19/04/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import Foundation
import Locksmith

class AuthenticationManager {
    
    let api: CribberAPI!
    let secureStore: SecureStore
    let dataStore: CoreDataStore
    
    private let AuthTokenKey = "authToken"
    private let PhoneNumberKey = "phoneNumber"
    
    static let sharedInstance = AuthenticationManager()
    
    convenience init() {
        self.init(api: CribberAPI(), secureStore: SecureStore(), dataStore: CoreDataStore())
    }
    
    init(api: CribberAPI, secureStore: SecureStore, dataStore: CoreDataStore) {
        self.api = api
        self.secureStore = secureStore
        self.dataStore = dataStore
    }
    
    func signin(phoneNumber: PhoneNumber, completion: (error: NSError?) -> Void) {
        savePhoneNumber(phoneNumber.description)
        api.authenticate(phoneNumber, response: {
            (json, error) in
            if error != nil {
                Log.Error("Signing in", error: error)
            }
            completion(error: error)
        })
    }
    
    func verify(phoneNumber: PhoneNumber, code: String, completion: (isAuthenticated: Bool, error: NSError?) -> Void) {
        api.verify(phoneNumber, code: code) {
            (json, error) in
            var authenticated = false
            if let token = json?["token"].string {
                authenticated = self.signin(token)
            }
            completion(isAuthenticated: authenticated, error: error)
        }
    }
    
    var authToken: String? {
        return secureStore.valueForKey(AuthTokenKey)
    }
    
    var phoneNumber: String? {
        return secureStore.valueForKey(PhoneNumberKey)
    }
    
    var isAuthenticated: Bool {
        return authToken != nil
    }
    
    private func signin(authToken: String) -> Bool {
        if self.saveAuthToken(authToken) {
            NSNotificationCenter.defaultCenter().postNotificationName(
                Constants.UserDidSignInNotification, object: nil)
            return true
        }
        return false
    }
    
    func signout() -> Bool {
        if secureStore.deleteData() {
            deleteDatabaseObjects()
            NSNotificationCenter.defaultCenter().postNotificationName(
                Constants.UserDidSignOutNotification, object: nil)
            return true
        }
        return false
    }
    
    private func saveAuthToken(authToken: String) -> Bool {
        return secureStore.setValue(authToken, forKey: AuthTokenKey)
    }
    
    private func savePhoneNumber(phoneNumber: String) -> Bool {
        return secureStore.setValue(phoneNumber, forKey: PhoneNumberKey)
    }
    
    private func deleteDatabaseObjects() {
        dataStore.deleteAll(FeedItem.self)
        dataStore.deleteAll(Station.self)
        dataStore.saveData()
    }
}
