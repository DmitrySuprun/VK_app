//
//  Photo.swift
//  VK
//
//  Created by Дмитрий Супрун on 6.06.22.
//

import Foundation
import RealmSwift

class UserAllPhotos: Object, Decodable {

    var photos = List<Photos>()
    @objc dynamic var ownerID = 0

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
    
    @objc dynamic var photoURL = ""
    @objc dynamic var likeCount = 0
    @objc dynamic var isLiked = false
    
    
    enum CodingKeys: CodingKey {
        case sizes
        case likes
    }
    
    enum Sizes: CodingKey {
        case url
        case type
    }
    
    enum Likes: String, CodingKey {
        case count
        case isLiked = "user_likes"
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var sizes = try container.nestedUnkeyedContainer(forKey: .sizes)
        
        // A Boolean value indicating whether there are no more elements left to be decoded in the container.
        while !sizes.isAtEnd {
            let sizeItem = try sizes.nestedContainer(keyedBy: Sizes.self)
            let url = try sizeItem.decode(String.self, forKey: .url)
            let type = try sizeItem.decode(String.self, forKey: .type)
            guard type == "x" else { continue }
            self.photoURL = url
        }
        
        let likes = try container.nestedContainer(keyedBy: Likes.self, forKey: .likes)
        self.likeCount = try likes.decode(Int.self, forKey: .count)
        
        switch try likes.decode(Int.self, forKey: .isLiked) {
        case 0: self.isLiked = false
        case 1: self.isLiked = true
        default:
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: likes.codingPath + [Likes.isLiked], debugDescription: "Can't decode user_likes into Bool"))
        }
    }
}
