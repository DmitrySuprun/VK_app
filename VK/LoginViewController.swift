//
//  LoginViewController.swift
//  VK
//
//  Created by Дмитрий Супрун on 4.04.22.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let blurEffect = UIBlurEffect(style: .extraLight)
    let visualEffect = UIVisualEffectView()
    
    // MARK: - Public Properties
    // MARK: - Private Properties
    // MARK: - Initializers
    
    // MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Анимация появления этого VC
        self.transitioningDelegate = self
        

        // Жест нажатия
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        // Присваиваем его UIScrollVIew
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
        
        // Добавляем extention для отображения параля в поле ввода
        passwordTextField.enablePasswordToggle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Подписываемся на два уведомления: одно приходит при появлении клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // Второе — когда она пропадает
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) { super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - IBActions
    
    @IBAction func loginButton(_ sender: Any) {
        
        addBlurEffect(effect: blurEffect)

        
        let login = loginTextField.text!
        let password = passwordTextField.text!
        
        
        if login == "admin" && password == "123456" {
            print("успешная авторизация")
        } else {
            let alert = UIAlertController(title: "Wrong password", message: "Check your password", preferredStyle: .alert)
            
            // временная помощь при входе
            let insertDefaultLoginAndPassword = UIAlertAction(title: "Insert admin password", style: .destructive) { _ in
                self.loginTextField.text = "admin"
                self.passwordTextField.text = "123456"
                self.removeBlurEffect(view: self.visualEffect)

            }
            
            let okButton = UIAlertAction(title: "Ok", style: .default) { _ in
                self.removeBlurEffect(view: self.visualEffect)
            }
            alert.addAction(okButton)
            alert.addAction(insertDefaultLoginAndPassword)
            present(alert, animated: true)
        }
    }
    
    // MARK: - Public Methods
    
    // Когда клавиатура появляется
    @objc func keyboardWasShown(notification: Notification) {
        
        // Получаем размер клавиатуры
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        
        // Добавляем отступ внизу UIScrollView, равный размеру клавиатуры
        self.scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    //Когда клавиатура исчезает
    @objc func keyboardWillBeHidden(notification: Notification) {
        
        // Устанавливаем отступ внизу UIScrollView, равный 0
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
    }
    
    @objc func hideKeyboard() {
        self.scrollView?.endEditing(true)
    }
    
    // MARK: - Private Methods
    
    private func addBlurEffect(effect: UIBlurEffect) {
        
        visualEffect.effect = effect
        self.view.addSubview(visualEffect)
        visualEffect.frame = self.view.frame
    }
    private func removeBlurEffect(view: UIVisualEffectView) {
        view.removeFromSuperview()
    }
    
}

// Отображение пароля в поле ввода
extension UITextField {
    fileprivate func setPasswordToggleImage(_ button: UIButton) {
        if (isSecureTextEntry) {
            button.setImage(UIImage(systemName: "eye"), for: .normal)
        } else {
            button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
    }
    // Добавляет кнопку "глаз" справа в textField
    func enablePasswordToggle() {
        let button = UIButton(type: .custom)
        setPasswordToggleImage(button)
        button.addTarget(self, action: #selector(self.togglePasswordView), for: .touchUpInside)
        self.rightView = button
        self.rightViewMode = .always
    }
    @IBAction func togglePasswordView(_ sender: Any) {
        isSecureTextEntry.toggle()
        setPasswordToggleImage(sender as! UIButton)
    }
}

extension LoginViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PushAnimationTransitionViewController()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PopAnimationTransitionViewController()
    }
    
}
