//
//  PhotoAnimationViewController.swift
//  VK
//
//  Created by Дмитрий Супрун on 4.05.22.
//

import UIKit

class PhotoAnimationViewController: UIViewController {
    
    var userProfileInfo: User!
    var currentImageIndex = 1
    var nextImageIndex = 2
    var previousImageIndex = 0
    
    var propertyAnimateRight: UIViewPropertyAnimator!
    var propertyAnimateLeft: UIViewPropertyAnimator!
    var propertyAnimateAppear: UIViewPropertyAnimator!
    
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var imageNext: UIImageView!
    @IBOutlet weak var imagePrevious: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        image.image = userProfileInfo.images[currentImageIndex]
        imageNext.image = userProfileInfo.images[nextImageIndex]
        imagePrevious.image = userProfileInfo.images[previousImageIndex]
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
                self.imagePrevious.transform = CGAffineTransform(translationX: -distanceAnimation, y: 0)
                self.image.alpha = 0
                self.image.transform = CGAffineTransform(scaleX: 0.42, y: 0.42)
                
            })
            propertyAnimateAppear = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut, animations: {
                self.imageNext.alpha = 1
                self.imageNext.transform = CGAffineTransform(scaleX: 2.4, y: 2.4)
            })
            
            
        case .changed:
            
            let panMove = recognizer.translation(in: view).x / 200
            
            if panMove > 0 {
                propertyAnimateRight.fractionComplete = panMove
                propertyAnimateAppear.fractionComplete = panMove

            } else {
                propertyAnimateLeft.fractionComplete = -panMove

            }
            
        case .ended:
            propertyAnimateLeft.continueAnimation(withTimingParameters: nil, durationFactor: 1)
            propertyAnimateRight.continueAnimation(withTimingParameters: nil, durationFactor: 1)
            propertyAnimateAppear.continueAnimation(withTimingParameters: nil, durationFactor: 1)
            
            // при завершении анимации UIImage возвращаются в исходное положение и .image меняются на следующие
            propertyAnimateRight.addCompletion { _ in
                
                self.imagePrevious.image = self.image.image
                self.image.image = self.imageNext.image
                
                if self.currentImageIndex == self.userProfileInfo.images.count - 1 {
                    self.currentImageIndex = -1
                }
                self.currentImageIndex += 1
                
                if self.currentImageIndex == self.userProfileInfo.images.count - 1 {
                    self.nextImageIndex = 0
                } else {
                    self.nextImageIndex += 1
                }
    
                self.imageNext.image = self.userProfileInfo.images[self.nextImageIndex]
                self.image.transform = .identity
                self.imageNext.transform = .identity
                self.imageNext.alpha = 0
                
            }
            propertyAnimateLeft.addCompletion { _ in
                
                self.imageNext.image = self.image.image
                self.image.image = self.imagePrevious.image
                
                if self.currentImageIndex == 0 {
                    self.currentImageIndex = self.userProfileInfo.images.count
                }
                self.currentImageIndex -= 1
                
                if self.currentImageIndex == 0 {
                    self.previousImageIndex = self.userProfileInfo.images.count - 1
                } else {
                    self.previousImageIndex -= 1
                }
                
                self.imagePrevious.image = self.userProfileInfo.images[self.previousImageIndex]
                self.image.transform = .identity
                self.image.alpha = 1
                self.imagePrevious.transform = .identity
                
            }
            print(self.currentImageIndex)
        default: break
        }
    }
    
    func updateData(user: User) {
        userProfileInfo = user
    }
    
    
}
