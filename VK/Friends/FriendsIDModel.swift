//
//  Friends.swift
//  VK
//
//  Created by Дмитрий Супрун on 1.06.22.
//

import Foundation
import RealmSwift

// transform struct: Decodable in class: Object, Decodable for Realm
class FriendsIDModel: Object, Decodable {

    var items = List<Int>()

    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nestedContainer = try container.nestedContainer(keyedBy: ItemsCodingKeys.self, forKey: .response)
        self.items = try nestedContainer.decode(List<Int>.self, forKey: .items)
    }

    enum CodingKeys: String, CodingKey{
        case response
    }

    enum ItemsCodingKeys: String, CodingKey {
        case items
    }
}

/*
struct FriendsIDModel: Decodable {

    let items: [Int]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nestedContainer = try container.nestedContainer(keyedBy: ItemsCodingKeys.self, forKey: .response)
        self.items = try nestedContainer.decode([Int].self, forKey: .items)
    }

    enum CodingKeys: String, CodingKey{
        case response
    }

    enum ItemsCodingKeys: String, CodingKey {
        case items
    }
}
*/


// без инициализаторов
//struct FriendsIDModel: Decodable {
//    var response: ResponseFriendsID
//}
//
//struct ResponseFriendsID: Decodable {
//    var count: Int
//    var items: [Int]
//}



