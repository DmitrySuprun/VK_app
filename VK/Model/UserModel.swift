//
//  UserModel.swift
//  VK
//
//  Created by Дмитрий Супрун on 9.04.22.
//

import UIKit

protocol UserListProtocol {
    var name: String { get }
    var avatarImage: UIImage? { get }
    var likeCount: Int { get }
}

struct UserModel: UserListProtocol {
    var name: String
    var avatarImage: UIImage?
    var likeCount: Int
    var isLike = false
    var images = [UIImage?]()
}

