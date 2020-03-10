//
//  UserDataHelper.swift
//  Poolr
//
//  Created by James Li on 9/9/17.
//  Copyright © 2017 PoolrApp. All rights reserved.
//

import Foundation
import SimpleKeychain
import CoreData

struct UserDataPersistenceHelper {
    
    static private(set) var authToken: String? {
        get {
            return A0SimpleKeychain().string(forKey: "authToken")
        }
        set {
            A0SimpleKeychain().setString(newValue!, forKey: "authToken")
        }
        
    }
    
    static private(set) var userId: String? {
        get {
            return A0SimpleKeychain().string(forKey: "userId")
        }
        set {
            A0SimpleKeychain().setString(newValue!, forKey: "userId")
        }
    }
    
    static var isNotificationOn: Bool? {
        get {
            if let _ = UserDefaults.standard.object(forKey: "notification") {
                return UserDefaults.standard.bool(forKey: "notification")
            } else {
                return true;
            }
        }
        set {
            UserDefaults.standard.set(newValue!, forKey: "notification")
        }
    }
    
    static private(set) var email: String? {
        get {
            return UserDefaults.standard.string(forKey: "email")
        }
        set {
            UserDefaults.standard.set(newValue!, forKey: "email")
        }
    }
    
    static private(set) var firstName: String? {
        get {
            return UserDefaults.standard.string(forKey: "firstName")
        }
        set {
            UserDefaults.standard.set(newValue!, forKey: "firstName")
            
        }
        
    }
    
    static private(set) var lastName: String? {
        get {
            return UserDefaults.standard.string(forKey: "lastName")
        }
        set {
             UserDefaults.standard.set(newValue!, forKey: "lastName")
        }
    }
    
    static var userName: String? {
        if let firstName = firstName,
           let lastName = lastName {
           return firstName + " " + lastName
        }
        return ""
    }
    
    static private(set) var phoneNumber: String? {
        get {
            return UserDefaults.standard.string(forKey: "phoneNumber")
        }
        set {
            UserDefaults.standard.set(newValue!, forKey: "phoneNumber")
        }
    }
    
    static private(set) var zipCode: String? {
        get {
            return UserDefaults.standard.string(forKey: "zipCode")
        }
        set {
            UserDefaults.standard.set(newValue!, forKey: "zipCode")
        }
    }
    
    static private(set) var city: String? {
        get {
            return UserDefaults.standard.string(forKey: "city")
        }
        set {
            UserDefaults.standard.set(newValue!, forKey: "city")
        }
    }
    
    static private(set) var state: String? {
        get {
            return UserDefaults.standard.string(forKey: "state")
        }
        set {
            UserDefaults.standard.set(newValue!, forKey: "state")
        }
    }
    
    static let applicationDocumentsDirectory: URL = {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }()
    
    static var profilePhotoUrl: URL {
        return applicationDocumentsDirectory.appendingPathComponent("photo")
    }

    static private func persistProfilePhoto(data: Data) {
        do {
            try data.write(to: profilePhotoUrl, options: .atomic)
        } catch {
            print("Error save profile photo: \(error)")
        }
    }
    
    static private func removeProfilePhoto() {
        do {
            if FileManager.default.fileExists(atPath: profilePhotoUrl.path) {
                try FileManager.default.removeItem(at: profilePhotoUrl)
            }
        } catch {
            print("Error remove profile photo: \(error)")
        }
    }
    
    static var profilePhoto: UIImage? {
        get {
            if FileManager.default.fileExists(atPath: profilePhotoUrl.path) {
                return UIImage(contentsOfFile: profilePhotoUrl.path)
            }
            return nil
        }
        set {
            if  newValue != nil,
                let data = UIImageJPEGRepresentation(newValue!, 1.0) {
               persistProfilePhoto(data: data)
            } else {
                removeProfilePhoto()
            }
        }
    }
    
    static func persistAccountData(_ userData: AccountData) -> Bool {
        self.authToken = userData.authToken
        self.userId = userData.userId
        self.email = userData.email
        self.firstName = userData.firstName
        self.lastName = userData.lastName
        self.phoneNumber = userData.phoneNumber
        self.zipCode = userData.zipCode
        self.city = userData.city
        self.state = userData.state
        
        return true
    }
    
    static func persistProfileData(_ userData: ProfileData) -> Bool {
        self.firstName = userData.firstName
        self.lastName = userData.lastName
        self.email = userData.email
        self.phoneNumber = userData.phoneNumber
        self.zipCode = userData.zipCode
        self.city = userData.city
        self.state = userData.state
        
        return true
    }
    
    static func removeAccountDataFromKeychain() {
        A0SimpleKeychain().deleteEntry(forKey: "authToken")
        A0SimpleKeychain().deleteEntry(forKey: "userId")
        
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "firstName")
        UserDefaults.standard.removeObject(forKey: "lastName")
        UserDefaults.standard.removeObject(forKey: "phoneNumber")
        UserDefaults.standard.removeObject(forKey: "zipCode")
        UserDefaults.standard.removeObject(forKey: "city")
        UserDefaults.standard.removeObject(forKey: "state")
      
    }
    
}
