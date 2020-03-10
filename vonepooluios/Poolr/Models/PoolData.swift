//
//  PoolData.swift
//  Poolr
//
//  Created by James Li on 1/16/18.
//  Copyright © 2018 PoolrApp. All rights reserved.
//

import Foundation

struct PoolData : Codable {
    let poolID: Int
    let isJoined: Bool
    let poolName: String
    let poolSize: Int
    let drawDate: String
    let jackpot: String
    let poolerCount: Int
    let winnerShare: String
    let poolerShare: String
    let countDownInterval: Int
    let notificationInterval: Int
    var isOpenPool: Bool
    
    init(poolId: Int, poolName: String, drawDate: String, isJoined: Bool, isOpenPool: Bool) {
        self.poolID = poolId
        self.poolName = poolName
        self.drawDate = drawDate
        self.isJoined = isJoined
        self.isOpenPool = isOpenPool
        
        self.poolSize = 0
        self.jackpot = " "
        self.poolerCount = 0
        self.winnerShare = " "
        self.poolerShare = " "
        self.countDownInterval = 0
        self.notificationInterval = 0
    }
}
