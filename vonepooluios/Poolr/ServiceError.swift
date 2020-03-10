//
//  ServiceError.swift
//  Poolr
//
//  Created by James Li on 9/14/17.
//  Copyright © 2017 PoolrApp. All rights reserved.
//

import Foundation

enum ServiceError: LocalizedError, CustomNSError, Error {
    case jsonEncodeError(reason: String)
    case jsonDecodeError(reason: String)
    case jsonMappingError(reason: String)
    case responseError(reason: String)
    case responseDisplayError(reason: String)
    case requestError(reason: String)
    case uploadPhotoError(reason: NSError)
    case downloadPhotoError(reason: String)
    case photoError(reason: String)
    case poolDataError(reason: String)
    case authenticationError(reason: String)
    
    var showError: String {
        switch self {
        case .responseDisplayError(let reason):
            return reason
        default:
            return AppConstants.generalErrorMessage
        }
    }
    
}

