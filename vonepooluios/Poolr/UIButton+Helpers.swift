//
//  UIButtonExtensions.swift
//  Poolr
//
//  Created by James Li on 7/16/17.
//  Copyright © 2017 PoolrApp. All rights reserved.
//

import UIKit

extension UIButton {
    
    func setCornerRadius() {
        self.layer.cornerRadius = 4
    }
    
    func setCornerRadiusWithBorderColor() {
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 126.0/255.0, green: 211.0/255.0, blue: 33.0/255.0, alpha: 1.0).cgColor
    }
}
