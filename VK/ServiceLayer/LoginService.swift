//
//  LoginService.swift
//  VK
//
//  Created by Дмитрий Супрун on 27.05.22.
//

import UIKit
import WebKit

class LoginService {
    
}

/// Login VK with web interface. Response with token
final class LoginVKViewController: UIViewController {
    
    private var webView: WKWebView!
    
    // MARK: LifeCycle
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Тестовая проверка Realm
        let testRealm = TestRealm()
        testRealm.runTest()
        
        loadAuth()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Устанавливаем darkMode из userDefaults не работает во viewDidLoad и villAppear
        self.view.window?.overrideUserInterfaceStyle = userDefaults.bool(forKey: "darkMode") ? .dark : .light
    
    }
}


extension LoginVKViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment else {
            decisionHandler(.allow)
            return
        }
        
        // Stop navigation VKWebView
        decisionHandler(.cancel)
        
        // Get out token from URL
        
        let params = fragment.components(separatedBy: "&").map { $0.components(separatedBy: "=") }.reduce([String: String]()) { result, param in
            var dict = result
            let key = param[0]
            let value = param[1]
            dict[key] = value
            return dict
        }
        
        guard let token = params["access_token"], let userID = params["user_id"] else { return }
        VKSession.instance.token = token
        VKSession.instance.userID = Int(userID)
        
        // Present next VC
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "Login")
        vc.modalPresentationStyle = .fullScreen
        show(vc, sender: nil)
        
    }
}

private extension LoginVKViewController {
    
    // Web request for authorization form
    func loadAuth() {
        
        // Requirements from VK API for authorization and get token
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [ URLQueryItem(name: "client_id", value: "8090325"),
                                     URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
                                     URLQueryItem(name: "display", value: "mobile"),
                                     URLQueryItem(name: "response_type", value: "token"),
                                     URLQueryItem(name: "revoke", value: "1"),
                                     URLQueryItem(name: "scope", value: "offline,friends,groups,photos")
        ]
        guard let url = urlComponents.url else { return }
        let loginRequest = URLRequest(url: url)
        webView.load(loginRequest)
    }
}


