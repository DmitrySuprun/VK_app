//
//  User.swift
//  VK
//
//  Created by Дмитрий Супрун on 2.06.22.
//

import Foundation
import RealmSwift

struct UserModel: Decodable {
    
    var userData = [User]()
    
    enum CodingKeys: String, CodingKey {
        case response
    }
    enum Response: String, CodingKey {
        case items
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let responseContainer = try container.nestedContainer(keyedBy: Response.self, forKey: .response)
        self.userData = try responseContainer.decode([User].self, forKey: .items)
    }
}

class User: Object, Decodable {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var avatarImage: String = ""
    
    var name: String {
        get{
            firstName + lastName
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case avatarImage = "photo_200"
    }
    
    override class func primaryKey() -> String? {
        "id"
    }
}
