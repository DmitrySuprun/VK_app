//
//  AnimationViewController.swift
//  VK
//
//  Created by Дмитрий Супрун on 22.04.22.
//

import UIKit

class AnimationViewController: UIViewController {
    
    @IBOutlet weak var animatedLogo: UIImageView!
    @IBOutlet weak var animateLine: UIView!
    
    @IBOutlet var verticalSpaceConstraintLogoLine: NSLayoutConstraint!
    @IBOutlet var widthLineConstraint: NSLayoutConstraint!
    @IBOutlet var safeAreaTopConstraintLogoLine: NSLayoutConstraint!
    @IBOutlet var shortWidthLineConstraint: NSLayoutConstraint!
    @IBOutlet var thinHeightLineConstraint: NSLayoutConstraint!
    @IBOutlet var heightLineConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animateLine.clipsToBounds = true
        animateLine.layer.cornerRadius = animateLine.frame.height / 2
        // Удаляет констрейнты с высоки приоритетом и начинают работать низкоприоритетные контстрейнты
        // Лого устанавливается вверху, линия делается толстая и короткая
        verticalSpaceConstraintLogoLine.isActive = false
        widthLineConstraint.isActive = false
        thinHeightLineConstraint.isActive = false
    }
    
    override func viewDidAppear (_ animated: Bool) {
        
        animate()
    }
    // Восстанавливает первоначальные констрейнты как на сториборде
    func setup() {
        self.verticalSpaceConstraintLogoLine = NSLayoutConstraint(item: self.animateLine!, attribute: .top, relatedBy: .equal, toItem: self.animatedLogo, attribute: .bottom, multiplier: 1, constant: 10)
        self.verticalSpaceConstraintLogoLine.priority = UILayoutPriority(rawValue: 1000)
        self.verticalSpaceConstraintLogoLine.isActive = true
        
        self.widthLineConstraint = NSLayoutConstraint(item: self.animateLine!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 200)
        self.widthLineConstraint.priority = UILayoutPriority(rawValue: 1000)
        self.widthLineConstraint.isActive = true
        
        self.thinHeightLineConstraint = NSLayoutConstraint(item: self.animateLine!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 15)
        self.thinHeightLineConstraint.priority = UILayoutPriority(rawValue: 1000)
        self.thinHeightLineConstraint.isActive = true
        
    }
    
    func animate () {
        UIView.animate(withDuration: 0.8,
                       delay: 0,
//                       usingSpringWithDamping: 0.3,
//                       initialSpringVelocity: 0,
                       options: [.autoreverse, .curveEaseIn]) {
            
            self.animatedLogo.transform = CGAffineTransform(rotationAngle: .pi)
            self.setup()
            self.view.layoutIfNeeded()
            
        } completion: { _ in
            
            self.verticalSpaceConstraintLogoLine.isActive = false
            self.widthLineConstraint.isActive = false
            self.thinHeightLineConstraint.isActive = false
            self.view.layoutIfNeeded()
            
            self.animatedLogo.transform = .identity
            
            UIView.animate(withDuration: 0.8,
                           delay: 0,
                           options: [.autoreverse, .curveEaseIn]) {
                
                self.animatedLogo.transform = CGAffineTransform(rotationAngle: .pi * 1.001)
                self.setup()
                self.view.layoutIfNeeded()
                
            }
        }
    }
}
