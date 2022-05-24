//
//  CloudAnimationViewController.swift
//  VK
//
//  Created by Дмитрий Супрун on 3.05.22.
//

import UIKit

class CloudAnimationViewController: UIViewController {
    
    
    @IBOutlet weak var animationView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Cloud
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 224.67, y: 99.96))
        bezierPath.addLine(to: CGPoint(x: 27.73, y: 99.96))
        bezierPath.addCurve(to: CGPoint(x: 0.78, y: 65.88), controlPoint1: CGPoint(x: 27.73, y: 99.96), controlPoint2: CGPoint(x: -5.44, y: 99.96))
        bezierPath.addCurve(to: CGPoint(x: 44.31, y: 43.16), controlPoint1: CGPoint(x: 7, y: 31.81), controlPoint2: CGPoint(x: 44.31, y: 43.16))
        bezierPath.addCurve(to: CGPoint(x: 75.41, y: 11.36), controlPoint1: CGPoint(x: 44.31, y: 43.16), controlPoint2: CGPoint(x: 54.68, y: 11.36))
        bezierPath.addCurve(to: CGPoint(x: 110.65, y: 27.26), controlPoint1: CGPoint(x: 96.14, y: 11.36), controlPoint2: CGPoint(x: 110.65, y: 27.26))
        bezierPath.addCurve(to: CGPoint(x: 150.04, y: -0), controlPoint1: CGPoint(x: 110.65, y: 27.26), controlPoint2: CGPoint(x: 127.24, y: -0))
        bezierPath.addCurve(to: CGPoint(x: 181.14, y: 27.26), controlPoint1: CGPoint(x: 172.85, y: -0), controlPoint2: CGPoint(x: 181.14, y: 27.26))
        bezierPath.addCurve(to: CGPoint(x: 212.23, y: 27.26), controlPoint1: CGPoint(x: 181.14, y: 27.26), controlPoint2: CGPoint(x: 199.8, y: 20.45))
        bezierPath.addCurve(to: CGPoint(x: 230.89, y: 49.98), controlPoint1: CGPoint(x: 224.67, y: 34.08), controlPoint2: CGPoint(x: 230.89, y: 49.98))
        bezierPath.addCurve(to: CGPoint(x: 259.92, y: 72.7), controlPoint1: CGPoint(x: 230.89, y: 49.98), controlPoint2: CGPoint(x: 257.84, y: 43.16))
        bezierPath.addCurve(to: CGPoint(x: 224.67, y: 99.96), controlPoint1: CGPoint(x: 261.99, y: 102.23), controlPoint2: CGPoint(x: 224.67, y: 99.96))
        bezierPath.close()
        
        // Ложное облако для бэкграунда бегущей stroke
        let bezierPathBackground = bezierPath

        let layerBackgroundStroke = CAShapeLayer()
        layerBackgroundStroke.path = bezierPathBackground.cgPath
        layerBackgroundStroke.lineWidth = 10
        layerBackgroundStroke.strokeColor = UIColor.lightGray.cgColor
        layerBackgroundStroke.fillColor = UIColor.clear.cgColor
        layerBackgroundStroke.strokeStart = 0
        layerBackgroundStroke.strokeEnd = 1
        
        let layer = CAShapeLayer()
        layer.path = bezierPath.cgPath
        layer.lineWidth = 10
        layer.strokeColor = UIColor.systemBlue.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeStart = 0
        layer.strokeEnd = 1
        layer.lineCap = .round
        // прерывистая линия
//        layer.lineDashPattern = [15, 15]
    
        animationView.layer.addSublayer(layerBackgroundStroke)
        animationView.layer.addSublayer(layer)
        
        let strokeEndAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
//        strokeEndAnimation.duration = 3
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1
//        layer.add(strokeEndAnimation, forKey: nil)
        strokeEndAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        let strokeStartAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeStart))
//        strokeStartAnimation.duration = 3
        strokeStartAnimation.fromValue = -0.5
        strokeStartAnimation.toValue = 1
//        layer.add(strokeStartAnimation, forKey: nil)
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [strokeStartAnimation, strokeEndAnimation]
        groupAnimation.duration = 3
        groupAnimation.repeatCount = .infinity
        layer.add(groupAnimation, forKey: nil)
    }
}
