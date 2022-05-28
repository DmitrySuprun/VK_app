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
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html" else {
            decisionHandler(.allow)
            return
        }
        
        decisionHandler(.cancel)
//        let vc = LoginViewController()
//        self.navigationController?.pushViewController(vc, animated: true)

    }
}

private extension LoginVKViewController {
    func loadAuth() {

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
