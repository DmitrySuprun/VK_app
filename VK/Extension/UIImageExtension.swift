//
//  UIViewExtension.swift
//  VK
//
//  Created by Дмитрий Супрун on 4.06.22.
//

import UIKit
extension UIImageView {
    
    func loadImage(url: String, placeHolder: UIImage? = UIImage(systemName: "❌") ) {
        self.image = nil
        // Encode url
//        let urlValid = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        guard let urlValid = URL(string: url) else {
            DispatchQueue.main.async {
                self.image = placeHolder
            }
            return
        }
        URLSession.shared.dataTask(with: urlValid) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data else {
                    return
                }
                self.image = UIImage(data: data)
            }
        }.resume()
        
    }
    
}

