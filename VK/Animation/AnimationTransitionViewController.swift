//
//  AnimationTransitionViewController.swift
//  VK
//
//  Created by Дмитрий Супрун on 21.05.22.
//

import UIKit

class AnimationTransitionViewController: NSObject, UIViewControllerAnimatedTransitioning {
    
    let timeInterval: Double = 2
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        timeInterval
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let sourse = transitionContext.view(forKey: .from) else { return }
        guard let destination = transitionContext.view(forKey: .to) else { return }
        destination.alpha = 0
        
        transitionContext.containerView.addSubview(destination)
        destination.frame = transitionContext.containerView.frame
        destination.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2).concatenating(CGAffineTransform(translationX: transitionContext.containerView.frame.height, y: -transitionContext.containerView.frame.width / 2))
                
        sourse.frame = transitionContext.containerView.frame
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseOut) {
            
            destination.transform = .identity
            destination.alpha = 1
            destination.layer.cornerRadius = 50
            sourse.alpha = 0
            
        } completion: { completed in
            transitionContext.completeTransition(completed)
        }

        
        
        
        
    }
    
    
}
