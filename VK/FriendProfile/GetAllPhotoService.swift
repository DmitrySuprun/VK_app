//
//  AllPhotoService.swift
//  VK
//
//  Created by Дмитрий Супрун on 8.06.22.
//

import UIKit

class GetAllPhotoService {
    
    func loadPhoto(id: String, completion: @escaping (Result<[String], Error>) -> () ) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/photos.getAll"
        urlComponents.queryItems = [URLQueryItem(name: "access_token", value: VKSession.instance.token),
                                    URLQueryItem(name: "v", value: "5.131"),
                                    URLQueryItem(name: "owner_id", value: id),
                                    URLQueryItem(name: "extended", value: "1")
        ]
        
        guard let url = urlComponents.url else { return }
        
        print("🏳️‍🌈")
        print(url)
        print("🏳️‍🌈")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data else { return }
            
            do {
                var result = [String]()
                let photo = try JSONDecoder().decode(PhotoGetAllModel.self, from: data)
                for item in photo.photos {
                    for size in item.sizes {
                        if size.type == "x" {
                            result.append(size.url)
                        }
                    }
                }
                
                completion(.success(result))
            } catch {
                print(#function)
                completion(.failure(Constants.Service.ServiceError.decodingError))
            }
        }.resume()
    }
    
    func load (url: [String]) -> [UIImageView] {
        var result = [UIImageView]()
        for string in url {
            let imageView = UIImageView()
            imageView.loadImage(url: string)
            result.append(imageView)
        }
        return result
    }
}
