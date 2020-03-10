//
//  PoolerTicketData.swift
//  Poolr
//
//  Created by James Li on 2/9/18.
//  Copyright © 2018 PoolrApp. All rights reserved.
//

import Foundation

struct TicketPhotoData: Codable, Equatable {
    let userId: String
    let userName: String
    let ticketId: Int
    let photoName: String
    let uploadTime: String
    let uploadDate: String
    let ticketStatus: String
}

extension TicketPhotoData {
    static func == (lhs: TicketPhotoData, rhs: TicketPhotoData) -> Bool {
        return lhs.photoName == rhs.photoName
    }
}

