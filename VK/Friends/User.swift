//
//  User.swift
//  VK
//
//  Created by Дмитрий Супрун on 2.06.22.
//

import Foundation
import RealmSwift

// transform struct: Decodable in class: Object, Decodable for Realm
class User: Object, Decodable {

    var userData = List<ResponseUser>()
    
    enum CodingKeys: String, CodingKey {
        case response
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userData = try container.decode(List<ResponseUser>.self, forKey: .response)
    }
}

class ResponseUser: Object, Decodable {

    @objc dynamic var id: Int = 0
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var avatarImage: String = ""

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case avatarImage = "photo_200"
    }
}


//struct User: Decodable {
//
//    let userData: [ResponseUser]
//
//    enum CodingKeys: String, CodingKey {
//        case response
//    }
//
//    struct ResponseUser: Decodable {
//
//        let id: Int
//        let firstName: String
//        let lastName: String
//        let avatarImage: String
//
//        enum CodingKeys: String, CodingKey {
//            case id
//            case firstName = "first_name"
//            case lastName = "last_name"
//            case avatarImage = "photo_200"
//        }
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.userData = try container.decode([ResponseUser].self, forKey: .response)
//    }
//}
