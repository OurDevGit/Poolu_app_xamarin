//
//  AccountRouter.swift
//  Poolr
//
//  Created by James Li on 8/30/17.
//  Copyright © 2017 PoolrApp. All rights reserved.
//

import Foundation
import Alamofire

enum ApiRouter: URLRequestConvertible {
    
    static let baseURLString = "https://www.pooluapp.com/api/"
    
    case sendVerifCode(phone: String)
    case checkVerifCode(phone: String, totp: String)

    
    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .sendVerifCode,.checkVerifCode:
                return .get
            }
        }
        
        let url : URL = {
            let path: String
            switch self {
            case .sendVerifCode(let phone):
                path = "account/mobile?phonenumber=" + phone.replacingOccurrences( of:"[^0-9]", with: "", options: .regularExpression)
            case .checkVerifCode(let phone, let totp):
                path = "account/verify?phonenumber=" + phone.replacingOccurrences( of:"[^0-9]", with: "", options: .regularExpression) + ("&totp=" + totp)
            }
            var url = URL(string: ApiRouter.baseURLString)!
            url.appendPathComponent(path)
            return url
        }()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        urlRequest.httpBody = nil
        
        if let authToken = UserDataPersistenceHelper.authToken {
            urlRequest.setValue("Bearer " + authToken, forHTTPHeaderField: "Authorization")
        }
        
        return urlRequest
    }
    
}
