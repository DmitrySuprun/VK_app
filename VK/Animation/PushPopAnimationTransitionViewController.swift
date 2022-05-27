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
        
        transitionContext.containerView.addSubview(destination)
        destination.frame = transitionContext.containerView.frame
        // эффект затемнения
        destination.alpha = 0
        
        // меняем точку поворота, через расширение UIView
        destination.setAnchorPoint(CGPoint(x: 1, y: 0))
        destination.transform = CGAffineTransform(rotationAngle: -.pi/2)
        
        UIView.animate(withDuration: timeInterval,
                       delay: 0,
                       options: .curveEaseOut) {
            
            sourse.alpha = 0
            destination.transform = .identity
            destination.alpha = 1
            
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
        
        transitionContext.containerView.addSubview(destination)
        destination.frame = transitionContext.containerView.frame
        destination.alpha = 0

        sourse.setAnchorPoint(CGPoint(x: 1, y: 0))
        
        UIView.animate(withDuration: 0,
                       delay: timeInterval,
                       options: .curveEaseOut) {
            
            destination.alpha = 1
            destination.layer.cornerRadius = 0
            
            sourse.transform = CGAffineTransform(rotationAngle: -.pi/2)
            sourse.alpha = 0
            
        } completion: { completed in
            transitionContext.completeTransition(completed && !transitionContext.transitionWasCancelled)
        }
    }
}

// Расширение позволяющее менять AnchorPoint (точку вокруг которой анимируется view, например при повороте)
// Если напрямую менять AnchorPoint будет перемещаться view

extension UIView {
    func setAnchorPoint(_ point: CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y);

        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)

        var position = layer.position

        position.x -= oldPoint.x
        position.x += newPoint.x

        position.y -= oldPoint.y
        position.y += newPoint.y

        layer.position = position
        layer.anchorPoint = point
    }
}
