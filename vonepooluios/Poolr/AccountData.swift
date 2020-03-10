//
//  AccountData.swift
//  Poolr
//
//  Created by James Li on 1/11/18.
//  Copyright © 2018 PoolrApp. All rights reserved.
//

import Foundation

struct AccountData : Codable {
    let authToken: String?
    let userId: String?
    let email: String?
    let firstName: String?
    let lastName: String?
    let phoneNumber: String?
    let zipCode: String?
    let city: String?
    let state: String?
}
