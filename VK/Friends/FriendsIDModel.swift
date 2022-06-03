//
//  Friends.swift
//  VK
//
//  Created by Дмитрий Супрун on 1.06.22.
//

import Foundation

struct FriendsIDModel: Decodable {
    var response: ResponseFriendsID
}

struct ResponseFriendsID: Decodable {
    var count: Int
    var items: [Int]    
}

