//
//  StringExtensions.swift
//  Poolr
//
//  Created by James Li on 9/3/17.
//  Copyright © 2017 PoolrApp. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func withBoldText(boldPartsOfString: Array<NSString>, font: UIFont!, boldFont: UIFont!) -> NSAttributedString {
        let nonBoldFontAttribute = [NSAttributedStringKey.font:font!]
        let boldFontAttribute = [NSAttributedStringKey.font:boldFont!]
        
        let boldString = NSMutableAttributedString(string: self as String, attributes:nonBoldFontAttribute)
        
        for i in 0 ..< boldPartsOfString.count {
            boldString.addAttributes(boldFontAttribute, range: (self as NSString).range(of: boldPartsOfString[i] as String))
        }
        
        return boldString
    }
    
    func toDate( dateFormat format  : String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current //STimeZone(name: "UTC") as TimeZone?
        return dateFormatter.date(from: self)!
    }
}
