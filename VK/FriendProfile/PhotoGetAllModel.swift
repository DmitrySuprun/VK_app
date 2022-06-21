//
//  Photo.swift
//  VK
//
//  Created by Дмитрий Супрун on 6.06.22.
//

import Foundation
import RealmSwift

// transform struct: Decodable in class: Object, Decodable for Realm
class PhotoGetAllModel: Object, Decodable {

    var photos = List<Photos>()

    enum CodingKeys: String, CodingKey {
        case response
    }

    enum ResponseCodingKeys: String, CodingKey {
        case items
    }

    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let responseContainer = try container.nestedContainer(keyedBy: ResponseCodingKeys.self, forKey: .response)
        self.photos = try responseContainer.decode(List<Photos>.self, forKey: .items)

    }
}

class Photos: Object, Decodable {
    var sizes = List<Sizes>()
    var likes: Like?
}

class Sizes: Object, Decodable {
    @objc dynamic var url: String = ""
    @objc dynamic var type: String = ""
}

class Like: Object, Decodable {
    @objc dynamic var count: Int = 0
}


//struct PhotoGetAllModel: Decodable {
//
//    let photos: [Photos]
//
//    struct Photos: Decodable {
//        let sizes: [Sizes]
//        let likes: Like
//    }
//
//    struct Sizes: Decodable {
//        let url: String
//        let type: String
//
//    }
//
//    struct Like: Decodable {
//        let count: Int
//    }
//
//    enum CodingKeys: String, CodingKey {
//        case response
//    }
//
//    enum ResponseCodingKeys: String, CodingKey {
//        case items
//    }
//
//
//    init(from decoder: Decoder) throws {
//
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let responseContainer = try container.nestedContainer(keyedBy: ResponseCodingKeys.self, forKey: .response)
//        self.photos = try responseContainer.decode([Photos].self, forKey: .items)
//
//    }
//}

// Тестовые struct с большим количеством информации
//struct PhotoGetAll: Decodable {
//
//    let response: Response
//
//    struct Response: Decodable {
//        let items: [Items]
//
//        struct Items: Decodable {
//            let sizes: [Sizes]
//            let likes: Likes
//
//            enum CodingKeys: String, CodingKey {
//                case sizes
//                case likes
//            }
//
//            struct Sizes: Decodable {
//                let url: String
//                let type: String
//            }
//
//            struct Likes: Decodable {
//                let count: Int
//
//                enum CodingKeys: String, CodingKey {
//                    case count
//                }
//            }
//        }
//    }
//}

//struct PhotoGetAll: Decodable {
//
//    let response: Response
//
//    struct Response: Decodable {
//        let count: Int
//        let items: [Items]
//
//        struct Items: Decodable {
//            let albumID: Int
//            let date: Int
//            let id: Int
//            let ownerID: Int
//            let sizes: [Sizes]
//            let text: String
//            let hasTags: Bool
//            let likes: Likes
//            let reposts: Reposts
//
//            enum CodingKeys: String, CodingKey {
//                case albumID = "album_id"
//                case date
//                case id
//                case ownerID = "owner_id"
//                case sizes
//                case text
//                case hasTags = "has_tags"
//                case likes
//                case reposts
//            }
//
//            struct Sizes: Decodable {
//                let height: Int
//                let url: String
//                let type: String
//                let width: Int
//            }
//
//            struct Likes: Decodable {
//                let count: Int
//                let userLikes: Int
//
//                enum CodingKeys: String, CodingKey {
//                    case count
//                    case userLikes = "user_likes"
//                }
//            }
//
//            struct Reposts: Decodable {
//                let count: Int
//            }
//        }
//    }
//}




