//
//  UILabelExtensions.swift
//  Poolr
//
//  Created by James Li on 7/16/17.
//  Copyright © 2017 PoolrApp. All rights reserved.
//

import UIKit

extension UILabel {
    
    func setTextSpacing(_ spacing:CGFloat) {
        let attributes: NSDictionary = [
            //NSFontAttributeName:UIFont(name: "FONT_NAME", size: TEXT_SIZE),
            NSAttributedStringKey.kern:CGFloat(spacing)
        ]
        let attributedTitle = NSAttributedString(string: self.text!, attributes:attributes as? [NSAttributedStringKey : AnyObject])
        
        self.attributedText = attributedTitle
    }
}
