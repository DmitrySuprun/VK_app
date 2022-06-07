//
//  UserService.swift
//  VK
//
//  Created by Дмитрий Супрун on 2.06.22.
//

import Foundation

final class UserService {
    
    typealias FriendsIDResult = Result<[Int], Error>
    typealias UserProfileResult = Result<User, Error>
    
    func loadFriendsID(completion: @escaping(FriendsIDResult) -> ()) {
        
        let session = URLSession(configuration: .default)
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/friends.get"
        urlComponents.queryItems = [URLQueryItem(name: "access_token", value: VKSession.instance.token),
                                    URLQueryItem(name: "v", value: "5.131")]
        guard let url = urlComponents.url else { return }
        
        print("♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️")
        print(url)
        print("♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️♦️")
        
        session.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil else { return }
            
            do {
                let friendsID = try JSONDecoder().decode(FriendsIDModel.self, from: data)
                completion(.success(friendsID.response.items))
            } catch {
                completion(.failure(Constants.Service.ServiceError.decodingError))
            }
        }.resume()
    }
    
    func loadFriendsProfile(userID: [Int], completion: @escaping(UserProfileResult) -> ()) {
        
        // форматирование ID в String c запятыми
        var ids = userID.reduce(into: "") { partialResult, next in
            partialResult += "," + String(next)
        }
        ids.removeFirst()
        
        let session = URLSession(configuration: .default)
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/users.get"
        urlComponents.queryItems = [URLQueryItem(name: "access_token", value: VKSession.instance.token),
                                    URLQueryItem(name: "v", value: "5.131"), URLQueryItem(name: "user_ids", value: ids),
                                    URLQueryItem(name: "fields", value: "photo_200")]
        
        guard let url = urlComponents.url else { return }
//        Для проверки через postman
//        print(url)

        session.dataTask(with: url) { data, response, error in
    
            guard let data = data, error == nil else { return }
      
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(Constants.Service.ServiceError.decodingError))
            }
        }.resume()
    }
}
