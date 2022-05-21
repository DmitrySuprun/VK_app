//
//  CustomAnimationUINavigationController.swift
//  VK
//
//  Created by Дмитрий Супрун on 21.05.22.
//

import UIKit

class CustomAnimationUINavigationController: UINavigationController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationTransitionViewController()
    }
    

   
}
