//
//  PhotoService.swift
//  Poolr
//
//  Created by James Li on 9/19/17.
//  Copyright © 2017 PoolrApp. All rights reserved.
//

import Foundation
import Alamofire

enum PhotoType: String {
    case lotteryTicket
    case user
    
    var format: String {
        switch self {
        case .lotteryTicket:
            return ".png"
        case .user:
            return ".jpg"
        }
    }
    
    var mineType: String {
        switch self {
        case .lotteryTicket:
            return "image/png"
        case .user:
            return "image/jpg"
        }
    }
    
}

struct PhotoService {

    static func uploadLotteryTicket(poolId: Int,
                                    photoData: Data,
                                    completionHandler: @escaping (String?, ServiceError?) -> Void) {
        
        let photoName = NSUUID().uuidString + PhotoType.lotteryTicket.format
        let urlString = AppConstants.ticketPhotoURLString
        let params : [String: String] = ["poolId": "\(poolId)"]
        
        uploadPhoto(photoName: photoName,
                    photoData: photoData,
                    photoMineType: PhotoType.lotteryTicket.mineType,
                    uploadUrlString: urlString,
                    params: params,
                    completionHandler: completionHandler)
    }
    
    static func uploadUserProfilePhoto(photoData: Data,
                                      completionHandler: @escaping (String?, ServiceError?) -> Void) {
        uploadPhoto(photoName: NSUUID().uuidString + PhotoType.user.format,
                     photoData: photoData,
                     photoMineType: PhotoType.user.mineType,
                     uploadUrlString: AppConstants.profilePhotoURLString,
                     params: ["photoType": "1"],
                     completionHandler: completionHandler)
    }
    
    static private func uploadPhoto(photoName: String,
                                    photoData: Data,
                                    photoMineType: String,
                                    uploadUrlString: String,
                                    params: [String: String],
                                    completionHandler: @escaping (String?, ServiceError?) -> Void) {
        var uploadParams : [String: String] = ["userId": Credentials.userId]
        params.forEach { (k,v) in uploadParams[k] = v }
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(photoData,
                                         withName: "photoFile",
                                         fileName: photoName,
                                         mimeType: photoMineType)
                for (key, value) in uploadParams
                {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            },
            to: uploadUrlString,
            headers: ["Authorization": "Bearer " + Credentials.authToken],
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.validate()
                    upload.responseJSON { response in
                        guard response.result.isSuccess else {
                            completionHandler(nil, ServiceError.uploadPhotoError(reason: response.result.error! as NSError))
                            return
                        }
                        guard let responseJson = response.result.value as? [String: Any],
                            let photoName = responseJson["photoName"] as? String else {
                                completionHandler(nil, ServiceError.photoError(reason: "Invalid server response"))
                                return
                        }
                        completionHandler(photoName, nil)
                    }
                case .failure(let encodingError):
                    completionHandler(nil, ServiceError.uploadPhotoError(reason: encodingError as NSError))
                    return
                }
            }
        ) // end upload
    }
    
    static func downloadProfilePhoto(completion: @escaping (Data?, ServiceError?) -> Void) {
        guard let userId = UserDataPersistenceHelper.userId,
              let authToken = UserDataPersistenceHelper.authToken else {
            completion(nil, ServiceError.authenticationError(reason: "Invaild user id or auth token"))
            return
        }
        
        var downloadParams = [String: String]()
        downloadParams["userId"] = userId
      
        Alamofire.request(
            AppConstants.profilePhotoURLString,
            parameters: downloadParams,
            headers: ["Authorization": "Bearer " + authToken]
        )
        .responseData { response in
            guard response.result.isSuccess else {
                completion(nil, ServiceError.downloadPhotoError(reason: response.result.error as! String))
                return
            }
            
            if let data = response.result.value {
                completion(data, nil)
            } else {
                completion(nil, ServiceError.downloadPhotoError(reason: "Invaild photo received from the service"))
            }
        }
    }

    static func downloadPhoto(_ urlString: String,
                              completionHandler: @escaping (UIImage?, ServiceError?) -> Void) {
        Alamofire.request(urlString).responseData {
            response in
            guard response.result.isSuccess else {
                completionHandler(nil, ServiceError.downloadPhotoError(reason: response.result.error as! String))
                return
            }
            
            if let data = response.result.value,
                let image = UIImage(data: data) {
                completionHandler(image, nil)
            } else {
                completionHandler(nil, ServiceError.downloadPhotoError(reason: "Invaild photo received from the service"))
            }
        }
    }
    
   

}
