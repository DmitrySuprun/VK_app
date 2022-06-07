//
//  Photo.swift
//  VK
//
//  Created by Дмитрий Супрун on 6.06.22.
//

import Foundation

//struct Photo: Decodable {
//    
//    let count: Int
//    let albumID: Int
//    let date: Int
//    let id: Int
//    let ownerID: Int
//    let text: String
//    let hasTags: Bool
//    let likes: Int
//    let reposts: Int
//
//    
//    
//    let photo: String
//    let likeCount: Int
//
//    enum CodingKeys: String, CodingKey {
//        case response
//
//        enum ResponseCodingKeys: String, CodingKey {
//            case count
//            case items
//
//            enum ItemsCodingKeys: String, CodingKey {
//                case albumID = "album_id"
//                case date
//                case id
//                case ownerID = "owner_id"
//                case sizes
//                case text
//                case hasTags = "has_tags"
//                case likes
//                case reposts
//
//            }
//        }
//    }
//
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        
//        let responseContainer = try container.nestedContainer(keyedBy: CodingKeys.ResponseCodingKeys.self, forKey: .response)
//        self.count = try responseContainer.decode(Int.self, forKey: .count)
//        
//        let itemsContainer = try responseContainer.nestedContainer(keyedBy: CodingKeys.ResponseCodingKeys.ItemsCodingKeys.self, forKey: .items)
//        self.albumID = try itemsContainer.decode(Int.self, forKey: .albumID)
//        self.date = try itemsContainer.decode(Int.self, forKey: .date)
//        self.id = try itemsContainer.decode(Int.self, forKey: .id)
//        self.ownerID = try itemsContainer.decode(Int.self, forKey: .ownerID)
//        self.text = try itemsContainer.decode(String.self, forKey: .text)
//        self.hasTags = try itemsContainer.decode(Bool.self, forKey: .hasTags)
//        self.likes = try itemsContainer.decode(Int.self, forKey: .likes)
//        
//        self.reposts = try itemsContainer.decode(Int.self, forKey: .reposts)
//        
//        
//        
//    }
//
//}


struct Photo: Decodable {
    
    let response: Response
    
    struct Response: Decodable {
        let count: Int
        let items: [Items]
    }
    
    struct Items: Decodable {
        let albumID: Int
        let date: Int
        let id: Int
        let ownerID: Int
        let sizes: [Sizes]
        let text: String
        let hasTags: Bool
        let likes: Likes
        let reposts: Reposts
        
        enum CodingKeys: String, CodingKey {
            case albumID = "album_id"
            case date
            case id
            case ownerID = "owner_id"
            case sizes
            case text
            case hasTags = "has_tags"
            case likes
            case reposts
        }
        
        struct Sizes: Decodable {
            let height: Int
            let url: String
            let type: String
            let width: Int
        }
        
        struct Likes: Decodable {
            let count: Int
            let userLikes: Int
            
            enum CodingKeys: String, CodingKey {
                case count
                case userLikes = "user_likes"
            }
        }
        
        struct Reposts: Decodable {
            let count: Int
        }
    }
}


