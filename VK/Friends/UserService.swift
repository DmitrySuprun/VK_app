//
//  UserService.swift
//  VK
//
//  Created by Дмитрий Супрун on 2.06.22.
//

import Foundation

final class UserService {
    
    typealias UserResult = Result<[Int], Error>
    
    func loadUser(completion: @escaping(UserResult) -> ()) {
        
        let session = URLSession(configuration: .default)
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/friends.get"
        
        guard let url = urlComponents.url else { return }
        
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
}
