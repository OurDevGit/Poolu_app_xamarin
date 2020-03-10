//
//  Photo.swift
//  Poolr
//
//  Created by James Li on 2/5/18.
//  Copyright © 2018 PoolrApp. All rights reserved.
//

import Foundation

struct PoolerPhotoData: Codable, Equatable  {
    let userId: String
    let userName: String
    let stateName: String
    let photoName: String 
}

extension PoolerPhotoData {
    static func == (lhs: PoolerPhotoData, rhs: PoolerPhotoData) -> Bool {
        return lhs.photoName == rhs.photoName
    }
}


