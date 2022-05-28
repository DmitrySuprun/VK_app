//
//  VKSession.swift
//  VK
//
//  Created by Дмитрий Супрун on 27.05.22.
//

import UIKit

class VKSession {
    
    static var instance = VKSession()
    
    var token:String = ""
    var userID:Int? = 0
    
    private init () {}
}
