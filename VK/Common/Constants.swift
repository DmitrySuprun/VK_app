//
//  Constants.swift
//  VK
//
//  Created by Дмитрий Супрун on 3.06.22.
//

import Foundation

struct Constants {
    enum Service: String {
        enum ServiceError: Error {
            case phraseError
            case requestError(Error)
            case serviceUnavailable
            case decodingError
        }
        
        case scheme = "https"
        case host = "oauth.vk.com"
        case hostApi = "api.vk.com"
        case path = "/authorize"
        case pathMethod = "/method/"
    }
}


