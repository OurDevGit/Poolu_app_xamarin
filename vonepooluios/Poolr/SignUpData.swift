//
//  SignUpData.swift
//  Poolr
//
//  Created by James Li on 3/10/18.
//  Copyright © 2018 PoolrApp. All rights reserved.
//

import Foundation

class SignUpData: Encodable {
    
    static let sharedInstance = SignUpData()
    
    private init() {}
    
    var email: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var phoneNumber: String = ""
    var zipCode: String = ""
    var photo: UIImage? = nil
    
    private enum CodingKeys: String, CodingKey {
        case email
        case firstName
        case lastName
        case phoneNumber
        case zipCode
    }
    
    func clearData() {
        self.email = ""
        self.firstName = ""
        self.lastName = ""
        self.phoneNumber = ""
        self.zipCode = ""
        self.photo = nil
    }
}
