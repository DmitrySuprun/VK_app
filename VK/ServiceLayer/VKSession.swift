//
//  VKSession.swift
//  VK
//
//  Created by Дмитрий Супрун on 27.05.22.
//

import UIKit

/// Singleton for store user login data
final class VKSession {
    
    static let instance = VKSession()
    
    var token:String = ""
    var userID:Int? = 0
    
    private init () {}
}
