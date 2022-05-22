//
//  CustomAnimationUINavigationController.swift
//  VK
//
//  Created by Дмитрий Супрун on 21.05.22.
//

import UIKit

class CustomAnimationUINavigationController: UINavigationController, UINavigationControllerDelegate {
    
    let interactieveTransition = CustomInteractiveTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactieveTransition.hasStarted ? interactieveTransition : nil
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch operation {
        case .pop:
            self.interactieveTransition.viewController = toVC
            return PopAnimationTransitionViewController()
        case .push:
            if navigationController.viewControllers.first != toVC {
                self.interactieveTransition.viewController = toVC
            }
            return PushAnimationTransitionViewController()
        case .none: return nil
        @unknown default: return nil
        }
    }
}
