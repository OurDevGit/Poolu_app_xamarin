//
//  TicketService.swift
//  Poolr
//
//  Created by James Li on 5/8/18.
//  Copyright © 2018 PoolrApp. All rights reserved.
//

import Foundation

struct TicketService {
    
    static func LotteryNumbersForTicket(ticketId: Int,
                                        completion: @escaping ServiceHelper.FetchDataCompletion<String>) {
        var urlString: String = AppConstants.ticketLotteryNumbersURLString
        urlString += ("?ticketId=" + ("\(ticketId)"))
        
        let urlRequest = ServiceHelper.buildUrlRequest(urlString: urlString,
                                                       httpMethod: HttpMethod.GET,
                                                       authToken: Credentials.authToken)
        
        ServiceHelper.fetchData(urlRequest: urlRequest,
                                codableType: [String].self,
                                completion: completion)
    }
    
    static func removeTicket(ticketId: Int,
                             completion: @escaping ServiceHelper.ServiceErrorCompletion) {
        let params : [String: Any] = ["userId": Credentials.userId, "ticketId": ticketId]
        let urlRequest = ServiceHelper.buildUrlRequest(urlString: AppConstants.ticketPhotoURLString,
                                                       httpMethod: HttpMethod.PUT,
                                                       authToken: Credentials.authToken,
                                                       params: params)
        
        ServiceHelper.sendRequest(urlRequest: urlRequest, completion: completion)
    }
    
}
