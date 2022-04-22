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
    
    @IBOutlet weak var verticalSpaceConstraintLogoLine: NSLayoutConstraint!
    @IBOutlet weak var widthLineConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animateLine.clipsToBounds = true
        animateLine.layer.cornerRadius = animateLine.frame.height / 2
        
        verticalSpaceConstraintLogoLine.isActive = false
        widthLineConstraint.isActive = false
        
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: [.repeat, .autoreverse]) {
            self.view.layoutIfNeeded()

        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {


    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
