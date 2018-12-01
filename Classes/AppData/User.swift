//
//  User.swift
//  MyBeerDiary2
//
//  Created by Florian LUDOT on 11/24/18.
//  Copyright © 2018 青柳瑞子. All rights reserved.
//

import UIKit


class User {
    
    let kIsLogged = "kIsLogged"
    let kLoginToken = "kLoginToken"
    let kUserName = "kUserName"
    
    init() {
        setDefaultValues()
    }
    
    var isLogged: Bool {
        get {
            return UserDefaults.standard.bool(forKey: kIsLogged)
        }
        
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: kIsLogged)
        }
    }
    
    var loginToken: String?  {
        get {
            return UserDefaults.standard.string(forKey: kLoginToken)
        }
        
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: kLoginToken)
        }
    }
    
    var username: String?  {
        get {
            return UserDefaults.standard.string(forKey: kUserName)
        }
        
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: kUserName)
        }
    }
    
    private func setDefaultValues() {
        UserDefaults.standard.register(defaults: [kIsLogged : false])
    }
    
}
