//
//  UITextField+Helpers.swift
//  Poolr
//
//  Created by James Li on 10/24/17.
//  Copyright © 2017 PoolrApp. All rights reserved.
//

import UIKit

extension UITextField  {
    
    func setBottomBorder(cgColor: CGColor? = nil) {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        
        if let color = cgColor {
            self.layer.shadowColor = color
        } else {
            self.layer.shadowColor = UIColor.darkGray.cgColor
        }
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
    func underlined(color: UIColor) {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    func formatPhoneNumber() {
        let cleanPhoneNumber = self.text!.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "(XXX) XXX-XXXX"
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask {
            if index == cleanPhoneNumber.endIndex {
                break
            }
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        self.text = result
    }

}
