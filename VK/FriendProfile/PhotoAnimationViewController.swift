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
    
    var propertyAnimateToRight: UIViewPropertyAnimator!
    var propertyAnimateToLeft: UIViewPropertyAnimator!
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
            
            propertyAnimateToRight = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut, animations: {
                self.image.transform = CGAffineTransform(translationX: distanceAnimation, y: 0)
                
            })
            propertyAnimateToLeft = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut, animations: {
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
                propertyAnimateToRight.fractionComplete = panMove
                propertyAnimateAppear.fractionComplete = panMove

            } else {
                propertyAnimateToLeft.fractionComplete = -panMove

            }
            
        case .ended:
            propertyAnimateToLeft.continueAnimation(withTimingParameters: nil, durationFactor: 1)
            propertyAnimateToRight.continueAnimation(withTimingParameters: nil, durationFactor: 1)
            propertyAnimateAppear.continueAnimation(withTimingParameters: nil, durationFactor: 1)
            
            // при завершении анимации UIImage возвращаются в исходное положение и .image меняются на следующие
            propertyAnimateToRight.addCompletion { _ in
                
                self.imagePrevious.image = self.image.image
                self.image.image = self.imageNext.image
                
                self.currentImageIndex += 1
                
                if self.currentImageIndex == self.userProfileInfo.images.count {
                    self.currentImageIndex = 0
                }
                self.calculatePreviousNextIndex()
    
                self.imageNext.image = self.userProfileInfo.images[self.nextImageIndex]
                self.image.transform = .identity
                self.imageNext.transform = .identity
                self.imageNext.alpha = 0
                
            }
            propertyAnimateToLeft.addCompletion { _ in
                
                self.imageNext.image = self.image.image
                self.image.image = self.imagePrevious.image
                
                self.currentImageIndex -= 1
                
                if self.currentImageIndex < 0 {
                    self.currentImageIndex = self.userProfileInfo.images.count - 1
                }
                self.calculatePreviousNextIndex()
                
                self.imagePrevious.image = self.userProfileInfo.images[self.previousImageIndex]
                self.image.transform = .identity
                self.image.alpha = 1
                self.imagePrevious.transform = .identity
                
            }
        default: break
        }
    }
    
    func updateData(user: User) {
        userProfileInfo = user
    }
    // Считаем индекс предыдущей и последующей картинки
    func calculatePreviousNextIndex() {
        
        switch currentImageIndex {
        case 0:
            previousImageIndex = userProfileInfo.images.count - 1
            nextImageIndex = 1
        case userProfileInfo.images.count - 1:
            previousImageIndex = userProfileInfo.images.count - 2
            nextImageIndex = 0
        default :
            previousImageIndex = currentImageIndex - 1
            nextImageIndex = currentImageIndex + 1
            
        }
        
    }
    
    
}
