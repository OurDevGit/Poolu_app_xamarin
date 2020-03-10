//
//  PoolService.swift
//  Poolr
//
//  Created by James Li on 1/16/18.
//  Copyright © 2018 PoolrApp. All rights reserved.
//

import Foundation

struct PoolService {
    static func poolDataForOpenPools(poolId: Int? = nil,
                                     completion: @escaping ServiceHelper.FetchDataCompletion<PoolData>) {
        var urlString: String = AppConstants.poolDataURLString
        urlString += ("?userid=" + Credentials.userId)
        
        if let poolId = poolId {
            urlString += ("&poolid=" + "\(poolId)")
        }
        
        let urlRequest = ServiceHelper.buildUrlRequest(urlString: urlString,
                                                       httpMethod: HttpMethod.GET,
                                                       authToken: Credentials.authToken)
        
        ServiceHelper.fetchData(urlRequest: urlRequest,
                                codableType: [PoolData].self,
                                completion: completion)
    }
    
    static func poolResultsForClosedPools(completion: @escaping ServiceHelper.FetchDataCompletion<PoolResult>) {
        let urlString = AppConstants.poolResultsURLString + "?userid=" + Credentials.userId
        let urlRequest = ServiceHelper.buildUrlRequest(urlString: urlString,
                                                       httpMethod: HttpMethod.GET,
                                                       authToken: Credentials.authToken)
        
        ServiceHelper.fetchData(urlRequest: urlRequest,
                                codableType: [PoolResult].self,
                                completion: completion)
    }
    
    static func photoDataForPoolers(poolId: Int,
                                    completion: @escaping ServiceHelper.FetchDataCompletion<PoolerPhotoData>) {
        var urlString: String = AppConstants.poolerPhotoDataURLString
        urlString += ("?userid=" + Credentials.userId)
        urlString += ("&poolid=" + "\(poolId)")
        
        let urlRequest = ServiceHelper.buildUrlRequest(urlString: urlString,
                                                       httpMethod: HttpMethod.GET,
                                                       authToken: Credentials.authToken)
       ServiceHelper.fetchData(urlRequest: urlRequest,
                               codableType: [PoolerPhotoData].self,
                               completion: completion)
    }
    
    static func photoDataForTickets(poolId: Int,
                                    poolerUserId: String,
                                    completion: @escaping ServiceHelper.FetchDataCompletion<TicketPhotoData>) {
        var urlString: String = AppConstants.poolerTicketPhotoDataURLString
        urlString.append("?userid=" + Credentials.userId)
        urlString.append("&poolid=" + "\(poolId)")
        urlString.append("&poolerUserId=" + "\(poolerUserId)")
        
        let urlRequest = ServiceHelper.buildUrlRequest(urlString: urlString,
                                                       httpMethod: HttpMethod.GET,
                                                       authToken: Credentials.authToken)
        
        ServiceHelper.fetchData(urlRequest: urlRequest,
                                codableType: [TicketPhotoData].self,
                                completion: completion)
        
    }
    
}
