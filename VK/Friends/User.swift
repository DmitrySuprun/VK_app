//
//  User.swift
//  VK
//
//  Created by Дмитрий Супрун on 2.06.22.
//

import Foundation



struct User: Decodable {
    let response: [ResponseUser]
}

struct ResponseUser: Decodable {
    
    let id: Int
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
