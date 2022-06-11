//
//  TestResponse.swift
//  VK
//
//  Created by Дмитрий Супрун on 7.06.22.
//

import Foundation

final class TestResponse {
    
    static let instance = TestResponse()
    private init() {}
    
    func getResponse() {
        
        let session = URLSession(configuration: .default)
        var urlComponents = URLComponents()
        
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/photos.getAll"
        urlComponents.queryItems = [URLQueryItem(name: "access_token", value: VKSession.instance.token),
                                    URLQueryItem(name: "v", value: "5.131"),
                                    URLQueryItem(name: "owner_id", value: "346649827"),
                                    URLQueryItem(name: "extended", value: "1")
        ]
        
        guard let url = urlComponents.url else { return }
        let request = URLRequest(url: url)
        print("🏳️‍🌈🏳️‍🌈🏳️‍🌈🏳️‍🌈🏳️‍🌈🏳️‍🌈")
        print(url)
        print("🏳️‍🌈🏳️‍🌈🏳️‍🌈🏳️‍🌈🏳️‍🌈🏳️‍🌈")
        
        session.dataTask(with: request) { data, response, error in
            
            guard let data = data else { return }
            
            do {
                let photo = try JSONDecoder().decode(PhotoGetAllModel.self, from: data)
                print("🏳️‍🌈🏳️‍🌈🏳️‍🌈🏳️‍🌈🏳️‍🌈🏳️‍🌈")
                print(photo)
                print("🏳️‍🌈🏳️‍🌈🏳️‍🌈🏳️‍🌈🏳️‍🌈🏳️‍🌈")
            } catch {
                print("❌")
                print("ERROR")
                print("❌")

            }
            
        }.resume()
        
       
        
        
    }
}
