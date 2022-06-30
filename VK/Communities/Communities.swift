//
//  Communities.swift
//  VK
//
//  Created by Дмитрий Супрун on 11.06.22.
//

import Foundation

struct Communities: Decodable {
    var response: Response
    
    struct Response: Decodable {
        var count: Int
        var items: [Items]
        
        struct Items: Decodable {
            var id: Int
            var name: String
            var photo: String
            
            enum CodingKeys: String, CodingKey {
                case id
                case name
                case photo = "photo_50"
            }
        }
    }
}
