//
//  Constant.swift
//  NetworkDemo
//
//  Created by Mehul on 12/10/18.
//  Copyright © 2018 Mehul. All rights reserved.
//

import Foundation

struct K {
    struct ProductionServer {
        static let baseURL = "http://192.168.1.192:8080/api"
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
}

// LIVE CHAT SERVER
var CHAT_DOMAIN_NAME                        = "@world-pc"
var CHAT_SERVER_LINK                        = "192.168.1.192"
var CHAT_SERVER_PORT                        = 5222
var CHAT_PASSWORD                           = "abcd@xmpp"
