//
//  PoolType.swift
//  Poolr
//
//  Created by James Li on 12/3/17.
//  Copyright © 2017 PoolrApp. All rights reserved.
//

import Foundation

enum PoolType {
    case powerball
    case megaMillions
    
    var name: String {
        switch self {
        case .powerball:
            return "Powerball"
        case .megaMillions:
            return "Mega Millions"
        }
    }
    
    var type: String {
        switch self {
        case .powerball:
            return "1"
        case .megaMillions:
            return "2"
        }
    }
    
    var ticketType: String {
        switch self {
        case .powerball:
            return "1"
        case .megaMillions:
            return "2"
        }
    }
    
}
