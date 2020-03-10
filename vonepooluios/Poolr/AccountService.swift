//
//  PoolrAPIService.swift
//  Poolr
//
//  Created by James Li on 8/12/17.
//  Copyright © 2017 PoolrApp. All rights reserved.
//

import Alamofire

struct AccountService {
    
    static func sendVerificationCodeToMobilePhone(phoneNumber: String,
                                                  completion: @escaping ServiceHelper.ServiceErrorCompletion)  {
        var urlString: String = AppConstants.mobileSubmitURLString
        urlString += ("?phonenumber=" + phoneNumber.replacingOccurrences( of:"[^0-9]", with: "", options: .regularExpression) )

        let urlRequest = ServiceHelper.buildUrlRequest(urlString: urlString, httpMethod: HttpMethod.GET)
        ServiceHelper.sendRequest(urlRequest: urlRequest, completion: completion)
    }
    
    static func checkVerificationCode(phoneNumber: String,
                                      totp: String,
                                      completion: @escaping ServiceHelper.SendRequestCompletion<AccountData>) {
        var urlString: String = AppConstants.mobileVerifyURLString
        urlString += ("?phonenumber=" + phoneNumber.replacingOccurrences( of:"[^0-9]", with: "", options: .regularExpression) )
        urlString += ("&totp=" + totp)
        
        let urlRequest = ServiceHelper.buildUrlRequest(urlString: urlString, httpMethod: HttpMethod.GET)
        ServiceHelper.sendRequest(urlRequest: urlRequest,
                                  codableType: AccountData.self,
                                  completion: completion)
    }

    static func createUser(_ signUpData: SignUpData,
                           completion: @escaping ServiceHelper.SendRequestCompletion<AccountData>) {
        let urlRequest = ServiceHelper.buildUrlRequest(urlString: AppConstants.accountURLString,
                                                       httpMethod: HttpMethod.POST,
                                                       encoableType: signUpData)
        
        ServiceHelper.sendRequest(urlRequest: urlRequest,
                                  codableType: AccountData.self,
                                  completion: completion)
    }
    
    static func updateUser(_ profileData: ProfileData,
                           completion: @escaping ServiceHelper.SendRequestCompletion<ProfileData>) {
        let urlRequest = ServiceHelper.buildUrlRequest(urlString: AppConstants.accountURLString,
                                                       httpMethod: HttpMethod.PUT,
                                                       authToken: Credentials.authToken,
                                                       encoableType: profileData)
        
        ServiceHelper.sendRequest(urlRequest: urlRequest,
                                  codableType: ProfileData.self,
                                  completion: completion)
    }
    
}


