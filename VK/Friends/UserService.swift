//
//  UserService.swift
//  VK
//
//  Created by Дмитрий Супрун on 2.06.22.
//

import Foundation
import RealmSwift

final class UserService {
    
    func loadFriendsProfile() async {
        
        let session = URLSession(configuration: .default)
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/friends.get"
        urlComponents.queryItems = [URLQueryItem(name: "access_token", value: VKSession.instance.token),
                                    URLQueryItem(name: "v", value: "5.131"),
                                    URLQueryItem(name: "fields", value: "photo_200")]
        
        guard let url = urlComponents.url else { return }
        
        let request = URLRequest(url: url)
        
        do {
            let (data, _) = try await session.data(for: request)
            let result = try JSONDecoder().decode(UserModel.self, from: data)
            await saveRealm(object: result)
            
        } catch {
            print(#function)
            print("❌ Loading error")
            print(error)
        }
            
    }
}

extension UserService {
    
    private func saveRealm(object: UserModel) async {
        
        do {
            let realm = try await Realm()
            try realm.write {
                realm.add(object.userData, update: .modified)
            }
            
        } catch {
            print(#function)
            print("❌ Cant't save Realm data")
            print(error)
        }
        
    }
}
