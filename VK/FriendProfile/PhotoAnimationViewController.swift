//
//  PhotoAnimationViewController.swift
//  VK
//
//  Created by Дмитрий Супрун on 4.05.22.
//

import UIKit

class PhotoAnimationViewController: UIViewController {
    
    var userProfileInfo: User!
    
    var propertyAnimateRight: UIViewPropertyAnimator!
    var propertyAnimateLeft: UIViewPropertyAnimator!
    var propertyAnimateAppear: UIViewPropertyAnimator!
    
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var imageNext: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        image.image = userProfileInfo.images[0]
        imageNext.image = userProfileInfo.images[1]
        imageNext.alpha = 0
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        view.addGestureRecognizer(panGestureRecognizer)
        
        }
    
    @objc func viewPanned (_ recognizer: UIPanGestureRecognizer) {
        
        switch recognizer.state {
            
        case .began:
            
            let distanceAnimation = self.view.frame.width / 2 + self.image.frame.width / 2
            
            propertyAnimateRight = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut, animations: {
                self.image.transform = CGAffineTransform(translationX: distanceAnimation, y: 0)
                    })
            propertyAnimateLeft = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut, animations: {
                self.image.transform = CGAffineTransform(translationX: -distanceAnimation, y: 0)
                    })
            propertyAnimateAppear = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut, animations: {
                self.imageNext.alpha = 1
                self.imageNext.bounds = CGRect(x: 87, y: 328, width: 240, height: 240)
            })
            
            

        case .changed:
            
            let panMove = recognizer.translation(in: view).x / 200
            
            if panMove > 0 {
                propertyAnimateRight.fractionComplete = panMove
                propertyAnimateAppear.fractionComplete = panMove
            } else {
                propertyAnimateLeft.fractionComplete = -panMove
                propertyAnimateAppear.fractionComplete = -panMove
            }
            
//            image.transform = CGAffineTransform(translationX: recognizer.translation(in: view).x, y: recognizer.translation(in: view).y)
            
        case .ended:
//            image.transform = .identity
            propertyAnimateLeft.continueAnimation(withTimingParameters: nil, durationFactor: 1)
            propertyAnimateRight.continueAnimation(withTimingParameters: nil, durationFactor: 1)
            propertyAnimateAppear.continueAnimation(withTimingParameters: nil, durationFactor: 1)
            

        default: break
        }
    }
    
    
    func updateData(user: User) {
        userProfileInfo = user
    }
    
    
}
