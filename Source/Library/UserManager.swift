//
//  UserManager.swift
//  HoloArts
//
//  Created by Oleh Korchytskyi on 06/07/2017.
//  Copyright © 2017 Gamayun. All rights reserved.
//

import UIKit
//import KeychainSwift

fileprivate let kStoredAccountKey = "sk.gamayun.HoloArts.account"
fileprivate let kStoredPasswordKey = "sk.gamayun.HoloArts.password"


final class UserManager: Singleton {
    
    static let shared : UserManager = {
        let instance = UserManager()
        return instance
    }()
    
    struct User {
        typealias Balance = (amount: String, currency: String)
        
        let id: Int
        let name: String
        let balance: Balance
        let token: String
        
        init?(json: [String : Any]?, token: String) {
            
            guard
                let id = json?["id"] as? Int,
                let name = json?["name"] as? String,
                let balance = json?["balance"] as? [String : Any],
                let amount = balance["balance"] as? String,
                let currency = balance["currency"] as? String else {
                    return nil
            }
            
            self.id = id
            self.name = name
            self.balance = (amount: amount, currency: currency)
            self.token = token
        }
    }
    
    private(set) var user: User?
    
    var isAuthenticated: Bool {
        return user != nil
    }
    
    // MARK: - Keychain
    
    private var storedPassword: String? {
        get {
            let keychain = KeychainSwift()
            keychain.synchronizable = false
            return keychain.get(kStoredPasswordKey)
        }
        
        set {
            let keychain = KeychainSwift()
            keychain.synchronizable = false
            if let value = newValue {
                keychain.set(value, forKey: kStoredPasswordKey)
            } else {
                keychain.delete(kStoredPasswordKey)
            }
        }
    }
    
    private var storedAccount: String? {
        get {
            let keychain = KeychainSwift()
            keychain.synchronizable = false
            return keychain.get(kStoredAccountKey)
        }
        
        set {
            let keychain = KeychainSwift()
            keychain.synchronizable = false
            if let value = newValue {
                keychain.set(value, forKey: kStoredAccountKey)
            } else {
                keychain.delete(kStoredAccountKey)
            }
        }
    }
    
    var canRestoreSession: Bool {
        if let _ = storedAccount, let _ = storedPassword {
            return true
        } else {
            return false
        }
    }
    
    func restoreUserSession(_ success: APIRequestSuccess? = nil, _ failure: APIRequestFailure? = nil) {
        if let storedAccount = storedAccount, let storedPassword = storedPassword {
            authenticateUser(withEmail: storedAccount, andPassword: storedPassword, success, failure)
        } else {
            failure?(.DataNotAcquired)
        }
    }
    
    // MARK: - Calls
    func registerUser(withEmail email: String, name: String, andPassword password: String, _ success: APIRequestSuccess? = nil, _ failure: APIRequestFailure? = nil) {
        if let currendVendorId = UIDevice.currendVendorId {
            let request = APIRequest(endpoint: .SignUp, params: ["deviceId": currendVendorId,
                                                                 "email": email,
                                                                 "name": name,
                                                                 "pin": password])
            
            request.perform({ (result) in
                success?(result)
            }, { (error) in
                failure?(error)
            })
        }

    }
    
    func authenticateUser(withEmail email: String, andPassword password: String, _ success: APIRequestSuccess? = nil, _ failure: APIRequestFailure? = nil) {
        
        guard let currendVendorId = UIDevice.currendVendorId else {
            assertionFailure("Vendor ID not availeble!")
            return
        }
        
        let authRequest = APIRequest(endpoint: .SignIn, params: ["deviceId": currendVendorId,
                                                                 "email": email,
                                                                 "pin": password])
        
        authRequest.perform({ (result) in
            
            guard let token = result.json?["token"] as? String else {
                return
            }
            
            let userInfoRequest = APIRequest(endpoint: .User, headers: ["Auth-Token": token])
            
            userInfoRequest.perform({ [weak self] (result) in
                
                if let user = User(json: result.json, token: token) {
                    self?.user = user
                    self?.storedAccount = email
                    self?.storedPassword = password
                    success?(result)
                } else {
                    failure?(.BadData)
                }
                
                }, { (error) in
                    print(error.localizedDescription)
                    failure?(error)
            })
            
        }, { (error) in
            print(error.localizedDescription)
            failure?(error)
        })
    }
    
    func authenticateUser(withKiosk authURL: String, andPassword password: String, _ success: APIRequestSuccess? = nil, _ failure: APIRequestFailure? = nil) {
        
        guard let token = user?.token else {
            assertionFailure("User token not availeble!")
            return
        }
        
        let authRequest = APIRequest(endpoint: .QRLogin, headers: ["Auth-Token": token], params: ["url": authURL, "pin": password])
        
        authRequest.perform({ (result) in
            
            print(result.response ?? "**EMPTY RESULT**")
            print()
            
            success?(result)
            
        }, { (error) in
            print(error.localizedDescription)
            failure?(error)
        })
    }
}
