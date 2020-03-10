//
//  LoginData.swift
//  Poolr
//
//  Created by James Li on 9/30/17.
//  Copyright © 2017 PoolrApp. All rights reserved.
//

import Foundation

class LoginData: Codable {
    
    var email: String
    var password: String
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
