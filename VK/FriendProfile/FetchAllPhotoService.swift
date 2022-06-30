//
//  AllPhotoService.swift
//  VK
//
//  Created by Дмитрий Супрун on 8.06.22.
//

import UIKit
import RealmSwift

class FetchAllPhotoService {
    
    func loadPhoto(id: String, completion: @escaping (Result<UserAllPhotos, Error>) -> () ) {
        
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
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            guard let data = data else { return }
            
            do {
                let allPhoto = try JSONDecoder().decode(UserAllPhotos.self, from: data)
                completion(.success(allPhoto))
                
            } catch {
                print(#function)
                completion(.failure(error))
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

//extension FetchAllPhotoService {
//    func saveRealmData(photos: UserAllPhotos) async {
//
//        if let realm = try? await Realm() {
//            print(realm.configuration.fileURL ?? "❌ No Realm file")
//            do {
//                try realm.write {
//                    realm.add(photos)
//                }
//            } catch {
//                print(#function)
//                print("❌ Can't save Realm data")
//                print(error)
//            }
//        }
//    }
//}
