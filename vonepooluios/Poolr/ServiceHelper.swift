//
//  ServiceHelper.swift
//  Poolr
//
//  Created by James Li on 5/31/18.
//  Copyright © 2018 PoolrApp. All rights reserved.
//

import Foundation

enum HttpMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
}

enum Credentials {
    static let userId = UserDataPersistenceHelper.userId!
    static let authToken = UserDataPersistenceHelper.authToken!
}

struct ServiceHelper {
    static func buildUrlRequest(urlString: String,
                                httpMethod: HttpMethod,
                                authToken: String? = nil,
                                params: [String: Any]? = nil) -> URLRequest {
        var urlRequest = URLRequest(url: URL(string: urlString)!,
                                    cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                    timeoutInterval: AppConstants.requestTimeoutInterval)
       
        urlRequest.httpMethod = httpMethod.rawValue
        
        if httpMethod == HttpMethod.PUT {
            if let params = params {
                urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            }
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        if let authToken = authToken {
             urlRequest.addValue("Bearer " + authToken, forHTTPHeaderField: "Authorization")
        }
        
        return urlRequest
    }
    
    static func buildUrlRequest<T: Encodable>(urlString: String,
                                              httpMethod: HttpMethod,
                                              authToken: String? = nil,
                                              encoableType: T?) -> URLRequest {
        var urlRequest = URLRequest(url: URL(string: urlString)!,
                                    cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                    timeoutInterval: AppConstants.requestTimeoutInterval)
        
        urlRequest.httpMethod = httpMethod.rawValue
        
        if httpMethod == HttpMethod.PUT || httpMethod == HttpMethod.POST {
           if let type = encoableType {
                urlRequest.httpBody = try? JSONEncoder().encode(type)
            }
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        if let authToken = authToken {
            urlRequest.addValue("Bearer " + authToken, forHTTPHeaderField: "Authorization")
        }
        
        return urlRequest
    }
    
    static func getServiceError(_ data: Data?, _ response: URLResponse?) -> ServiceError {
        if let errorReponse = try? JSONSerialization.jsonObject(with: data!) as? [String: String] {
            return ServiceError.responseDisplayError(reason: (errorReponse?["error"])!)
        } else {
            return ServiceError.responseError(reason: response.debugDescription)
        }
    }
  
    typealias FetchDataCompletion<T: Codable> = ([T]?, ServiceError?) -> ()
    typealias SendRequestCompletion<T: Codable> = (T?, ServiceError?) -> ()
    typealias ServiceErrorCompletion = (ServiceError?) -> ()
    
    static func fetchData<T: Codable>(urlRequest: URLRequest,
                                      codableType: [T].Type,
                                      completion: @escaping FetchDataCompletion<T>) {
        URLSession.shared.dataTask(with: urlRequest) {
            (data, response, error) in
            DispatchQueue.main.async {
                if let _ = error {
                    completion(nil, ServiceError.requestError(reason: "Request for " + urlRequest.description + " failed"))
                } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    do {
                        let results = try JSONDecoder().decode(codableType, from: data!)
                        completion(results, nil)
                    } catch {
                        completion(nil, ServiceError.jsonDecodeError(reason: "Decode " + String(describing: T.self) + " failed"))
                    }
                } else {
                    completion(nil, ServiceHelper.getServiceError(data, response))
                }
            }
        }.resume()
    }
    
    static func sendRequest(urlRequest: URLRequest,
                           completion: @escaping ServiceErrorCompletion) {
        URLSession.shared.dataTask(with: urlRequest) {
            (data, response, error) in
            DispatchQueue.main.async {
                if let _ = error {
                    completion(ServiceError.requestError(reason: "Request for " + urlRequest.description + " failed"))
                } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    completion(nil)
                } else {
                    completion(ServiceHelper.getServiceError(data, response))
                }
            }
        }.resume()
    }
    
    static func sendRequest<T: Codable>(urlRequest: URLRequest,
                                        codableType: T.Type,
                                        completion: @escaping SendRequestCompletion<T>) {
        URLSession.shared.dataTask(with: urlRequest) {
            (data, response, error) in
            DispatchQueue.main.async {
                if let _ = error {
                    completion(nil, ServiceError.requestError(reason: "Request for " + urlRequest.description + " failed"))
                } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    do {
                        let results = try JSONDecoder().decode(codableType, from: data!)
                        completion(results, nil)
                    } catch {
                        completion(nil, ServiceError.jsonDecodeError(reason: "Decode " + String(describing: T.self)  + " failed"))
                    }
                } else {
                    completion(nil, ServiceHelper.getServiceError(data, response))
                }
            }
        }.resume()
    }
   
}
