//
//  AllPhotoService.swift
//  VK
//
//  Created by Дмитрий Супрун on 8.06.22.
//

import UIKit
import RealmSwift

class FetchAllPhotoService {
    
    private lazy var session: URLSession = {
        return URLSession(configuration: .default)
    }()
    
    func loadPhoto(id: String) async {
        
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
        
        let request = URLRequest(url: url)
        do {
            let (data, _) = try await session.data(for: request)
            let result = try JSONDecoder().decode(UserAllPhotos.self, from: data)
            await saveRealm(photos: result)

        } catch {
            print(error)
        }
        
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

extension FetchAllPhotoService {
    
    func saveRealm(photos: UserAllPhotos) async {
        
        do {
            let realm = try await Realm()
            // Выводит в консоль схему данных в Realm
//            print(realm.schema.description)
            print(realm.configuration.fileURL ?? "❌ No Realm file")
            try realm.write {
                realm.add(photos, update: .modified)
            }
        } catch {
            print(#function)
            print("❌ Can't save Realm data")
            print(error)
        }
    }
}
