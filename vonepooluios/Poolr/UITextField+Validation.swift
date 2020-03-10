//
//  UITextFieldExtensions.swift
//  Poolr
//
//  Created by James Li on 7/29/17.
//  Copyright © 2017 PoolrApp. All rights reserved.
//

import UIKit

extension UITextField  {
    
    func isNumber(_ string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    func isLetter(_ string: String) -> Bool {
        let allowedCharacters = CharacterSet.letters
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    func isLengthInLimitedRange(_ string: String, _ range: NSRange, lengthLimit: Int) -> Bool {
        let startingLength = self.text?.count ?? 0
        let lengthToAdd = string.count
        let lengthToReplace =  range.length
        let newLength = startingLength + lengthToAdd - lengthToReplace
        
        return newLength <= lengthLimit
    }
    
    func validateEmailAddress() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,15}"
        let emailCheck = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        return emailCheck.evaluate(with: self.text)
    }
    
    func validatePassword() -> Bool {
        if (self.text?.count)! < 8 {
            return false
        }
        
        return true
    }
    
    func validateReEnterPassword(_ password:String) -> Bool {
        return self.text == password
    }
    
    func validateName() -> Bool {
        let nameRegEx = "[A-Za-z]{2,20}"
        let nameCheck = NSPredicate(format: "SELF MATCHES %@", nameRegEx)
        
        return nameCheck.evaluate(with: self.text)
    }
    
    func validateUSZipCode() -> Bool {
        let zipCodeRegEx = "^[0-9]{5}(?:-[0-9]{4})?$"
        let zipCodeCheck = NSPredicate(format: "SELF MATCHES %@", zipCodeRegEx)
        
        return  zipCodeCheck.evaluate(with: self.text)
    }
    
    func validateUSPhone() -> Bool {
        let phoneNumberRegEx = "^\\(?\\d{3}\\)?[- ]?\\d{3}[- ]?\\d{4}$"
        
        let phoneNumberCheck = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegEx)
        
        return phoneNumberCheck.evaluate(with: self.text)
    }
    
    func validateVerificationCode() -> Bool {
        if (self.text?.count)! < 4  {
            return false
        }
        
        return true
    }
}
