//
//  CommunitiesService.swift
//  VK
//
//  Created by Дмитрий Супрун on 11.06.22.
//

import UIKit

class CommunitiesService {
    
    func loadGroup(completion: @escaping (Result<Communities, Error>) -> () ) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/groups.get"
        urlComponents.queryItems = [URLQueryItem(name: "access_token", value: VKSession.instance.token),
                                    URLQueryItem(name: "v", value: "5.131"),
                                    URLQueryItem(name: "extended", value: "1")
                                    
        ]
        
        guard let url = urlComponents.url else { return }
        
        print("⚽️")
        print(url)
        print("⚽️")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data else { return }
            
            do {
                let communities = try JSONDecoder().decode(Communities.self, from: data)
                completion(.success(communities))
                print("⚽️")
                print(communities)
                print("⚽️")
            } catch {
                print(#function)
                completion(.failure(Constants.Service.ServiceError.decodingError))
            }
        }.resume()
    }
}
