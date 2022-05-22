//
//  AnimationTransitionViewController.swift
//  VK
//
//  Created by Дмитрий Супрун on 21.05.22.
//

import UIKit

let timeInterval: Double = 0.5

class PushAnimationTransitionViewController: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        timeInterval
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let sourse = transitionContext.view(forKey: .from) else { return }
        guard let destination = transitionContext.view(forKey: .to) else { return }
        destination.alpha = 0
        
        let heihtView = transitionContext.containerView.frame.height
        let widthView = transitionContext.containerView.frame.width
        
        transitionContext.containerView.addSubview(destination)
        destination.frame = transitionContext.containerView.frame
        destination.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
            .concatenating(CGAffineTransform(translationX: heihtView / 2 + widthView / 2, y: -widthView / 2))
                
        sourse.frame = transitionContext.containerView.frame
        
        UIView.animate(withDuration: timeInterval, delay: 0, options: .curveEaseOut) {
            
            destination.transform = .identity
            destination.alpha = 1
            destination.layer.cornerRadius = 50
            sourse.alpha = 0
            
        } completion: { completed in
            transitionContext.completeTransition(completed)
        }
    }
}

class PopAnimationTransitionViewController: NSObject, UIViewControllerAnimatedTransitioning {
        
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        timeInterval
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let sourse = transitionContext.view(forKey: .from) else { return }
        guard let destination = transitionContext.view(forKey: .to) else { return }
        destination.alpha = 0
        
        let heihtView = transitionContext.containerView.frame.height
        let widthView = transitionContext.containerView.frame.width
        
        transitionContext.containerView.addSubview(destination)
        destination.frame = transitionContext.containerView.frame
               
        sourse.frame = transitionContext.containerView.frame
        UIView.animate(withDuration: timeInterval, delay: 0, options: .curveEaseIn) {
            
            sourse.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
                .concatenating(CGAffineTransform(translationX: heihtView / 2 + widthView / 2, y: -widthView / 2))
            
            destination.alpha = 1
            destination.layer.cornerRadius = 0
            sourse.alpha = 0
            
        } completion: { completed in
            transitionContext.completeTransition(completed)
        }
    }
}
