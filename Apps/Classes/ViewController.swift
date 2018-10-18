//
//  ViewController.swift
//  NetworkDemo
//
//  Created by Mehul on 12/10/18.
//  Copyright © 2018 Mehul. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //Decodable With Alamofire
//        APIManager.login(withCountryCode: "+91", mobileNumber: "11111111", userType: 1, deviceModel: "iPhone X", oSVersion: "iOS 12") { (result) in
//            switch result {
//            case .success(let value):
//                print(value?.response.userId)
//            case .failure(let error):
//                print(error)
//            }
//        }
        
        
        //Manual Parding Alamofire
        APIManager.login1(withCountryCode: "+1", mobileNumber: "11111111", userType: 1, deviceModel: "iPhone X", oSVersion: "iOS 12") { (result) in
            switch result {
            case .success(let value):
                print("Final Result: \(value!)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

