//
//  Login.swift
//  NetworkDemo
//
//  Created by Mehul on 12/10/18.
//  Copyright © 2018 Mehul. All rights reserved.
//

import Foundation

//Decodable With Alamofire
//struct Login:Decodable {
//    let isSuccess = false
//    let showMessage = false
//    let response: Response
//}
//
//struct Response:Decodable {
//    let userId:Int
//}

//Manual Parsing Alamofire
struct Login: Decodable {

    var userId:Int

    init(_ dictionary:[String:Any]) {
        self.userId = dictionary["userId"] as? Int ?? -1
    }
}
