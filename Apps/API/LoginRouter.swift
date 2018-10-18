//
//  LoginRouter.swift
//  NetworkDemo
//
//  Created by Mehul on 12/10/18.
//  Copyright © 2018 Mehul. All rights reserved.
//

import Alamofire

struct LoginAPIParameterKey {
    static let countryCode = "countryCode"
    static let mobileNumber = "mobileNumber"
    static let userType = "userType"
    static let deviceModel = "deviceModel"
    static let oSVersion = "oSVersion"
}

enum LoginRouter: URLRequestConvertible {
    
    case login(countryCode:String, mobileNumber:String, userType:Int, deviceModel:String, oSVersion:String)
    case articles
    case article(id: Int)
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .login: return .post
        case .articles, .article: return .get
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .login: return "/user/signUpOrlogin"
        case .articles: return "/articles/all.json"
        case .article(let id): return "/article/\(id)"
        }
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .login(let countryCode, let mobileNumber, let userType,let deviceModel,let oSVersion):
            return [LoginAPIParameterKey.countryCode: countryCode,
                    LoginAPIParameterKey.mobileNumber: mobileNumber,
                    LoginAPIParameterKey.userType: userType,
                    LoginAPIParameterKey.deviceModel: deviceModel,
                    LoginAPIParameterKey.oSVersion: oSVersion]
        case .articles, .article:
            return nil
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try K.ProductionServer.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        urlRequest.setValue("Bearer ", forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
        
        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return urlRequest
    }
}
