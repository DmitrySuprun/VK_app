//
//  Friends.swift
//  VK
//
//  Created by Дмитрий Супрун on 1.06.22.
//

import Foundation

struct Friends: Decodable {
    var response: FriendsResponse
}

struct FriendsResponse: Decodable {
    var count: Int
    var items: [Int]
}

