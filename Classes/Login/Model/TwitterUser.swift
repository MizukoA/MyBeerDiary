//
//  TwitterUser.swift
//  MyBeerDiary2
//
//  Created by Florian LUDOT on 11/17/18.
//  Copyright © 2018 青柳瑞子. All rights reserved.
//

import UIKit
import TwitterKit

struct TwitterUser {
    let sns: String = "Twitter"
    let userId: String
    let username: String
    let email: String
}

extension TwitterUser {
    func firebaseObject() -> [String : Any] {
        return [
            "sns": sns,
            "userId": userId,
            "username" : username,
            "email": email,
        ]
    }
}
