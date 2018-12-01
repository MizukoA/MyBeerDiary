//
//  Database.swift
//  MyBeerDiary2
//
//  Created by Florian LUDOT on 11/17/18.
//  Copyright © 2018 青柳瑞子. All rights reserved.
//

import Foundation
import Firebase

enum FirebaseRootChild {
    static let users = "users"
    static let diaryNode = "diaryNode"
}

class FirebaseDatabase {
    
    
    
    let ref: DatabaseReference
    
    init() {
        ref = Database.database().reference()
    }
    
    func insertTwitterUser(ofId: String, data: [String : Any]) {
        self.ref.child("users").child(ofId).setValue(data)
    }
    
    func insertUser(id: String, email: String, username: String) {
        let user = ["id": id,
                    "email": email,
                    "username": username,
                    "isActive": true] as [String : Any]
        self.ref.child("users").child(id).setValue(user)
    }
    
    func deleteUser(id: String) {
        self.ref.child(id).removeValue()
    }
    
    
}
