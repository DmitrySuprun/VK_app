//
//  TestRealm.swift
//  VK
//
//  Created by Дмитрий Супрун on 18.06.22.
//

import Foundation
import RealmSwift

class TestRealmObject: Object {
    @objc dynamic var name = ""
    @objc dynamic var age = 0
    @objc dynamic var isStudent = false
    @objc dynamic var city = ""
}

class TestRealm {
    
    func runTest() {
        
        let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        
        let test = TestRealmObject()
        test.name = "Andrew"
        test.age = 16
        test.isStudent = false
        test.city = "New York"
        do {
            let realm = try Realm(configuration: config)
            print("realm file :: ")
            print(realm.configuration.fileURL)
            realm.beginWrite()
            realm.add(test)
            try realm.commitWrite()
        } catch {
            print("Error REALM")
        }
    }
}

