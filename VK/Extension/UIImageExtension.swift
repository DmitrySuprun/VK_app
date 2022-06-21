//
//  UIViewExtension.swift
//  VK
//
//  Created by Дмитрий Супрун on 4.06.22.
//

import UIKit
extension UIImageView {
    
    func loadImage(url: String, placeHolder: UIImage? = UIImage(systemName: "camera.circle.fill") ) {
        
        self.image = nil
        // Check validation URL Encoding замена символов на валидные
        let urlValid = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        guard let url = URL(string: urlValid) else {
            DispatchQueue.main.async {
                self.image = placeHolder
            }
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data else {
                    return
                }
                self.image = UIImage(data: data)
            }
        }.resume()
        
    }
    
}

