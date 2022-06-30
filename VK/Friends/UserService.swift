//
//  UserService.swift
//  VK
//
//  Created by Дмитрий Супрун on 2.06.22.
//

import Foundation

final class UserService {
    
    func loadFriendsProfile(completion: @escaping(Result<UserModel, Error>) -> ()) {
        
        let session = URLSession(configuration: .default)
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/friends.get"
        urlComponents.queryItems = [URLQueryItem(name: "access_token", value: VKSession.instance.token),
                                    URLQueryItem(name: "v", value: "5.131"),
                                    URLQueryItem(name: "fields", value: "photo_200")]
        
        guard let url = urlComponents.url else { return }
        
        session.dataTask(with: url) { data, response, error in
    
            guard let data = data, error == nil else { return }
      
            do {
                let user = try JSONDecoder().decode(UserModel.self, from: data)
                completion(.success(user))
            } catch {
                print(#function)
                completion(.failure(error))
            }
        }.resume()
    }
}
