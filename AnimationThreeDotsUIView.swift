//
//  AnimationThreeDotsUIView.swift
//  VK
//
//  Created by Дмитрий Супрун on 24.04.22.
//

import UIKit

class AnimationThreeDotsUIView: UIView {
    
    let dot1 = UIView()
    let dot2 = UIView()
    let dot3 = UIView()
    let hStack = UIStackView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // меняем размер вью и устанавливаем по центру экрана
        self.frame.size = CGSize(width: 130, height: 30)
        self.center = superview?.center ?? CGPoint(x: frame.width / 2, y: frame.height / 2)
        
        self.addSubview(hStack)
        
        setupUI(view: dot1)
        setupUI(view: dot2)
        setupUI(view: dot3)
        
        hStack.axis = .horizontal
        hStack.spacing = 20
        hStack.distribution = .fillEqually
        hStack.frame = CGRect(origin: .zero, size: self.frame.size)
        
        flashAnimation(view: dot1, startDelay: 0)
        flashAnimation(view: dot2, startDelay: 0.3)
        flashAnimation(view: dot3, startDelay: 0.6)

    }
    
    func setupUI(view: UIView) {
        view.clipsToBounds = true
        view.layer.cornerRadius = frame.height / 2
        view.backgroundColor = .systemBlue
        hStack.addArrangedSubview(view)
    }
    
    func flashAnimation(view: UIView, startDelay: Double) {
        
        let animation = CABasicAnimation(keyPath: "backgroundColor")
        animation.beginTime = CACurrentMediaTime() + startDelay
        animation.fromValue = UIColor.systemBlue.cgColor
        animation.toValue = UIColor.white.cgColor
        animation.duration = 0.6
        animation.repeatCount = 10
        animation.autoreverses = true
        view.layer.add(animation, forKey: "nil")
    }
}
