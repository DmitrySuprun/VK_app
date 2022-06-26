////
////  Photo.swift
////  VK
////
////  Created by Дмитрий Супрун on 6.06.22.
////
//
//import Foundation
//import RealmSwift
//
//// transform struct: Decodable in class: Object, Decodable for Realm
//class PhotoGetAllModel: Object, Decodable {
//
//    var photos = List<Photos>()
//
//    enum CodingKeys: String, CodingKey {
//        case response
//    }
//
//    enum ResponseCodingKeys: String, CodingKey {
//        case items
//    }
//
//    convenience required init(from decoder: Decoder) throws {
//        self.init()
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let responseContainer = try container.nestedContainer(keyedBy: ResponseCodingKeys.self, forKey: .response)
//        self.photos = try responseContainer.decode(List<Photos>.self, forKey: .items)
//        for photo in self.photos {
//            
//        }
//
//    }
//}
//
//class Photos: Object, Decodable {
//    var sizes = List<Sizes>()
//    var likes: Like
//}
//
//class Sizes: Object, Decodable {
//    @objc dynamic var url: String = ""
//    @objc dynamic var type: String = ""
//}
//
//class Like: Object, Decodable {
//    @objc dynamic var count: Int = 0
//}
