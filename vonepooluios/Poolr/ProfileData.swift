//
//  ProfileData.swift
//  Poolr
//
//  Created by James Li on 10/13/17.
//  Copyright © 2017 PoolrApp. All rights reserved.
//

import Foundation

class ProfileData: Codable {
    
    var userId: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var phoneNumber: String?
    var zipCode: String?
    var city: String?
    var state: String?
    
    var hasVaildProfileData: Bool {
        return
            firstName != "" &&
            lastName != "" &&
            email != "" &&
            phoneNumber != "" &&
            zipCode != ""
    }
    
    func getProfileData() {
        if let userId = UserDataPersistenceHelper.userId,
           let firstName = UserDataPersistenceHelper.firstName,
           let lastName = UserDataPersistenceHelper.lastName,
           let email = UserDataPersistenceHelper.email,
           let phoneNumber = UserDataPersistenceHelper.phoneNumber,
           let zipCode = UserDataPersistenceHelper.zipCode {
    
            self.userId = userId
            self.firstName = firstName
            self.lastName = lastName
            self.email = email
            self.phoneNumber = phoneNumber
            self.zipCode = zipCode
        }
        
    }
    

    
}
