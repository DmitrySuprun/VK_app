//
//  TestRequestViewController.swift
//  VK
//
//  Created by Дмитрий Супрун on 29.05.22.
//

import UIKit

class TestRequestViewController: UIViewController {
        
    @IBOutlet weak var groupTextField: UITextField!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func getFriendList(_ sender: Any) {
        customRequest(items: [], method: "friends.get")
    }
    @IBAction func getPhoto(_ sender: Any) {
        
        customRequest(items: [URLQueryItem(name: "owner_id", value: "159716695")], method: "photos.getAlbums")
    }
    @IBAction func getGroup(_ sender: Any) {
        
        customRequest(items: [URLQueryItem(name: "owner_id", value: "159716695")], method: "groups.get")
    }
    @IBAction func findGroup(_ sender: Any) {
        // 139873795
        let desiredGrop = groupTextField.text
        customRequest(items: [URLQueryItem(name: "user_id", value: "159716695"),
                             URLQueryItem(name: "group_id", value: desiredGrop),
                             URLQueryItem(name: "extended", value: "1")], method: "groups.isMember")
    }
    
    // MARK: -Private Methods
    
    /// Тестовые запросы API VK
    /// - Parameters:
    ///   - items: параметры запроса
    ///   - method: метод API
    private func customRequest(items: [URLQueryItem], method: String) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/" + method
        urlComponents.queryItems = items
        urlComponents.queryItems?.append(URLQueryItem(name: "access_token", value: VKSession.instance.token))
        urlComponents.queryItems?.append(URLQueryItem(name: "v", value: "5.131"))
        
        guard let url = urlComponents.url else { return }
        print(url)
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                return
            }
            let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
            print(json)
        }
        task.resume()
    }
}
