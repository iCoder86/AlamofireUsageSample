//
//  APIManager.swift
//  NetworkDemo
//
//  Created by Mehul on 12/10/18.
//  Copyright © 2018 Mehul. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD

class APIManager {
    
    let network = NetworkManager.sharedInstance
    
    //Decodable With Alamofire
    static func login(withCountryCode countryCode:String, mobileNumber:String, userType:Int, deviceModel:String, oSVersion:String, completion:@escaping (Result<Login?>)->Void) {
        NetworkManager.isReachable { (instance) in
            SVProgressHUD.show(withStatus: "Loading")
            Alamofire.request(LoginRouter.login(countryCode: countryCode,
                                                mobileNumber: mobileNumber,
                                                userType: 1,
                                                deviceModel: deviceModel,
                                                oSVersion: oSVersion))
                .responseDecodable { (response:DataResponse<Login?>) in
                switch response.result {
                case .success:
                    SVProgressHUD.dismiss()                    
                    completion(response.result)
                case .failure:
                    SVProgressHUD.dismiss()
                    completion(response.result)
                }
                SVProgressHUD.dismiss()
            }
        }
    }
    
    //Manual Parsing Alamofire
    static func login1(withCountryCode countryCode:String, mobileNumber:String, userType:Int, deviceModel:String, oSVersion:String, completion:@escaping (Result<Login?>)->Void) {
        
        NetworkManager.isReachable { (instance) in
            SVProgressHUD.show(withStatus: "Loading")
            Alamofire.request(LoginRouter.login(countryCode: countryCode,
                                                mobileNumber: mobileNumber,
                                                userType:userType,
                                                deviceModel: deviceModel,
                                                oSVersion: oSVersion))
                .responseJSON { (response:DataResponse<Any>) in
                    switch response.result {
                    case .success(_):
                        do {
                            guard response.data != nil else { return }
                            let value = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:Any]
                            
                            guard let dataResponse = value!["response"] else { return }
                            let user = Login(dataResponse as! [String : Any])
                            SVProgressHUD.dismiss()
                            completion(Result{user})
                        }
                        catch {
                            print(error.localizedDescription)
                            SVProgressHUD.dismiss()
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                        SVProgressHUD.dismiss()
                    }
                    SVProgressHUD.dismiss()
            }
        }
    }
}

extension DataRequest {

    private func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            guard error == nil else { return .failure(error!) }
            guard let data = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }
            return Result { try JSONDecoder().decode(T.self, from: data) }
        }
    }

    @discardableResult
    func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
    }
}

