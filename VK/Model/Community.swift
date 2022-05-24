//
//  Community.swift
//  VK
//
//  Created by Дмитрий Супрун on 11.04.22.
//

import Foundation

protocol CommunityProtocol {
    var name: String { get }
    var image: String { get }
}

// Для возможности сравнения пришлось подписать на Equatable
struct Community: Equatable {
    var name: String
    var image: String
}
