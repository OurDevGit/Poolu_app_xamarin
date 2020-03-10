//
//  PoolResults.swift
//  Poolr
//
//  Created by James Li on 2/3/18.
//  Copyright © 2018 PoolrApp. All rights reserved.
//

import Foundation

struct PoolResult : Codable {
    let poolId: Int
    let poolName: String
    let drawDate: String
    let jackpot: String
    let winningNumbers: String
    let winningPrize: String
    let isNewUser: Bool
    let isWinningPool: Bool?
    let winnerShare: String?
    let poolerShare: String?
}
