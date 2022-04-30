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
    var image: String { get }
    var likeCount: Int { get }
}

struct User: UserListProtocol {
    var name: String
    var image: String
    var likeCount: Int
}
