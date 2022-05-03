//
//  UserModel.swift
//  VK
//
//  Created by Дмитрий Супрун on 9.04.22.
//

import Foundation
import UIKit

protocol UserListProtocol {
    var name: String { get }
    var avatarImage: String { get }
    var likeCount: Int { get }
}

struct User: UserListProtocol {
    var name: String
    var avatarImage: String
    var likeCount: Int
    var isLike = false
    var images = [UIImage?]()
}
