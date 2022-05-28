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

final class LoginVKViewController: UIViewController {
    
    private var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        view = webView
        webView.navigationDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAuth()
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
        
        // Останавливаем навигацию VKWebView
        decisionHandler(.cancel)
        
        // Достаем Token из URL
        
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
        
        print(token)
        print(userID)

        
        // Презентуем VC приложения
        let stb = UIStoryboard(name: "Main", bundle: nil)
        let vc = stb.instantiateViewController(withIdentifier: "Login")
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

private extension LoginVKViewController {
    func loadAuth() {
        
        // Требования от VK API для регистрации и получения Token
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [ URLQueryItem(name: "client_id", value: "8090325"),
                                     URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
                                     URLQueryItem(name: "display", value: "mobile"),
                                     URLQueryItem(name: "response_type", value: "token"),
                                     URLQueryItem(name: "revoke", value: "1"),
                                     URLQueryItem(name: "scope", value: "111111111111")
        ]
        guard let url = urlComponents.url else { return }
        let loginRequest = URLRequest(url: url)
        print(url)
        webView.load(loginRequest)
    }
}
